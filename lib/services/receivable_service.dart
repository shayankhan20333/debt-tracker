import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/database_abstract_classes.dart';
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/DataBase/isar/isar_low_level_implementation.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:isar/isar.dart';

class ReceivableService {
  static ReceivableService? _instance;

  late IReceivableRepository _remoteReceivableRepo;
  late IReceivableRepository _localReceivableRepo;

  ReceivableService._internal() {
    _remoteReceivableRepo = FirebaseReceivableRepository();
    _localReceivableRepo = IsarReceivableRepository();
    _instance = this;
  }

  factory ReceivableService() => _instance ?? ReceivableService._internal();

  Future<ReceivableModel?> fetchReceivableById(String receivableId) async {
    final localReceivable = await _localReceivableRepo.getReceivables(
      receivableId,
    );
    if (localReceivable.isNotEmpty) return localReceivable.first;

    final remoteReceivable = await _remoteReceivableRepo.getReceivables(
      receivableId,
    );
    if (remoteReceivable.isNotEmpty) {
      await _localReceivableRepo.addReceivable(remoteReceivable.first);
      return remoteReceivable.first;
    }
    return null;
  }

  Future<void> initializeDatabase() async {
    await _remoteReceivableRepo.initializeDatabase();
    await _localReceivableRepo.initializeDatabase();
  }

  Future<void> createReceivable(ReceivableModel receivable) async {
    await initializeDatabase();
    await _remoteReceivableRepo.addReceivable(receivable);
    await _localReceivableRepo.addReceivable(receivable);
  }

  Future<List<IsarReceivable>> fetchAllReceivables() async {
    await initializeDatabase();
    Isar isarInstance = await _localReceivableRepo.databaseInstance;

    List<dynamic> firebasedata = await _remoteReceivableRepo
        .receivablesLength();
    int isarcount = await _localReceivableRepo.receivablesLength();

    if (firebasedata[0] > isarcount) {
      final existingIds = await isarInstance.isarReceivables
          .where()
          .receivableIdProperty()
          .findAll();

      final newReceivables = firebasedata[1]
          .where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final docId = data["id"]?.toString() ?? '';
            return !existingIds.contains(docId);
          })
          .map<IsarReceivable>((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final participants = List<String>.from(data['participants'] ?? []);
            return IsarReceivable()
              ..receivableId = data["id"]?.toString() ?? ''
              ..participants = participants
              ..description =
                  data['description']?.toString() ?? 'No Description'
              ..method = data['method']?.toString() ?? 'Unknown Method'
              ..rate = List<double>.from(
                data['rate']?.map((r) => (r as num).toDouble()) ?? [],
              )
              ..isReceived = List<bool>.from(
                data['isReceived'] ?? List.filled(participants.length, false),
              )
              ..isPaid = List<bool>.from(
                data['isPaid'] ?? List.filled(participants.length, false),
              )
              ..createdAt = DateTime.now();
          })
          .toList();

      if (newReceivables.isNotEmpty) {
        await isarInstance.writeTxn(() async {
          await isarInstance.isarReceivables.putAll(newReceivables);
        });
      }
    } else if (isarcount > firebasedata[0]) {
      final firebaseIds = firebasedata[1].map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data["id"]?.toString() ?? '';
      }).toList();

      final localReceivables = await isarInstance.isarReceivables
          .where()
          .findAll();
      final newLocalReceivables = localReceivables.where((receivable) {
        return !firebaseIds.contains(receivable.receivableId);
      }).toList();

      for (var receivable in newLocalReceivables) {
        final receivableModel = ReceivableModel(
          id: int.parse(receivable.receivableId ?? '0'),
          description: receivable.description ?? '',
          participants: receivable.participants,
          method: receivable.method ?? '',
          rate: receivable.rate,
          isReceived: receivable.isReceived,
          isPaid: receivable.isPaid,
          createdAt: firestore.Timestamp.fromDate(
            receivable.createdAt ?? DateTime.now(),
          ),
        );
        await _remoteReceivableRepo.addReceivable(receivableModel);
      }
    }

    return await isarInstance.isarReceivables.where().findAll();
  }

  Future<void> updatePaymentStatus(String receivableId, String userId) async {
    await initializeDatabase();
    Isar isarInstance = await _localReceivableRepo.databaseInstance;

    final receivable = await isarInstance.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      final userIndex = receivable.participants.indexOf(userId);
      if (userIndex != -1) {
        final updatedPaidStatus = [...receivable.isPaid];
        updatedPaidStatus[userIndex] = true;
        await _localReceivableRepo.updateReceivable(
          receivableId,
          updatedPaidStatus,
        );
        await _remoteReceivableRepo.updateReceivable(
          receivableId,
          updatedPaidStatus,
        );
      }
    }
  }

  Future<void> updateReceivedStatus(String receivableId, String userId) async {
    await initializeDatabase();
    Isar isarInstance = await _localReceivableRepo.databaseInstance;

    final receivable = await isarInstance.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      final userIndex = receivable.participants.indexOf(userId);
      if (userIndex != -1) {
        final updatedReceivedStatus = [...receivable.isReceived];
        updatedReceivedStatus[userIndex] = true;

        receivable.isReceived = updatedReceivedStatus;

        await isarInstance.writeTxn(() async {
          await isarInstance.isarReceivables.put(receivable);
        });

        final firebaseRepo =
            _remoteReceivableRepo as FirebaseReceivableRepository;
        await firebaseRepo.updateReceivableReceived(
          receivableId,
          updatedReceivedStatus,
        );
      }
    }
  }

  Future<void> deleteReceivable(String receivableId) async {
    await initializeDatabase();
    await _localReceivableRepo.deleteReceivable(receivableId);
    await _remoteReceivableRepo.deleteReceivable(receivableId);
  }

  Future<void> removeUserFromReceivable(
    String receivableId,
    int userIndex,
  ) async {
    await initializeDatabase();
    Isar isarInstance = await _localReceivableRepo.databaseInstance;

    final receivable = await isarInstance.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null && userIndex < receivable.participants.length) {
      final updatedParticipants = [...receivable.participants];
      final updatedRates = [...receivable.rate];
      final updatedIsReceived = [...receivable.isReceived];
      final updatedIsPaid = [...receivable.isPaid];

      updatedParticipants.removeAt(userIndex);
      if (userIndex < updatedRates.length) updatedRates.removeAt(userIndex);
      if (userIndex < updatedIsReceived.length) {
        updatedIsReceived.removeAt(userIndex);
      }
      if (userIndex < updatedIsPaid.length) updatedIsPaid.removeAt(userIndex);

      receivable.participants = updatedParticipants;
      receivable.rate = updatedRates;
      receivable.isReceived = updatedIsReceived;
      receivable.isPaid = updatedIsPaid;

      await isarInstance.writeTxn(() async {
        await isarInstance.isarReceivables.put(receivable);
      });

      // Update Firebase as well
      await _remoteReceivableRepo.updateReceivable(receivableId, updatedIsPaid);
    }
  }
}
