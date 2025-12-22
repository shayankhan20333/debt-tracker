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

  DateTime _parseCreatedAt(dynamic value, String id) {
    if (value is firestore.Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }
    // try derive from numeric id
    final parsedId = int.tryParse(id);
    if (parsedId != null && parsedId > 1000000000000) {
      return DateTime.fromMillisecondsSinceEpoch(parsedId);
    }
    return DateTime.now();
  }

  Stream<List<IsarReceivable>> watchReceivables() {
    return firestore.FirebaseFirestore.instance
        .collection('Receivables')
        .snapshots()
        .asyncMap((snapshot) async {
      final Isar isar = await _localReceivableRepo.databaseInstance;
      final mapped = snapshot.docs.map<IsarReceivable>((doc) {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);
        final createdAt =
            _parseCreatedAt(data['createdAt'], data["id"]?.toString() ?? '');
        return IsarReceivable()
          ..receivableId = data["id"]?.toString() ?? ''
          ..participants = participants
          ..description = data['description']?.toString() ?? 'No Description'
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
          ..createdAt = createdAt;
      }).toList();

      await isar.writeTxn(() async {
        await isar.isarReceivables.putAll(mapped);
      });
      return mapped;
    });
  }

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
    try {
      await initializeDatabase();
      await _remoteReceivableRepo.addReceivable(receivable);
      await _localReceivableRepo.addReceivable(receivable);
      print('Receivable saved successfully: ${receivable.id}');
    } catch (e) {
      print('ERROR in createReceivable: $e');
      rethrow;
    }
  }

  Future<List<IsarReceivable>> fetchAllReceivables() async {
    await initializeDatabase();
    try {
      List<dynamic> firebasedata =
          await _remoteReceivableRepo.receivablesLength();

      if (firebasedata[0] > 0 && firebasedata[1].isNotEmpty) {
        final Isar isar = await _localReceivableRepo.databaseInstance;
        final receivables = firebasedata[1].map<IsarReceivable>((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final participants = List<String>.from(data['participants'] ?? []);
          final createdAt =
              _parseCreatedAt(data['createdAt'], data["id"]?.toString() ?? '');
          return IsarReceivable()
            ..receivableId = data["id"]?.toString() ?? ''
            ..participants = participants
            ..description = data['description']?.toString() ?? 'No Description'
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
            ..createdAt = createdAt;
        }).toList();

        await isar.writeTxn(() async {
          await isar.isarReceivables.putAll(receivables);
        });
        return await isar.isarReceivables.where().findAll();
      }

      return await (await _localReceivableRepo.databaseInstance)
          .isarReceivables
          .where()
          .findAll();
    } catch (e) {
      print('ERROR fetching receivables: $e');
      return [];
    }
  }

  Future<void> _syncReceivables() async {
    try {
      final isar = await _localReceivableRepo.databaseInstance;

      // Fallback to count-based sync
      List<dynamic> firebasedata = await _remoteReceivableRepo
          .receivablesLength();
      int isarcount = await _localReceivableRepo.receivablesLength();

      if (firebasedata[0] > isarcount) {
        final existingIds = await isar.isarReceivables
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
              final participants = List<String>.from(
                data['participants'] ?? [],
              );
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
          await isar.writeTxn(() async {
            await isar.isarReceivables.putAll(newReceivables);
          });
        }
      }
    } catch (e) {
      // Ignore sync errors
    }
  }

  Future<void> updatePaymentStatus(String receivableId, String userId) async {
    await initializeDatabase();
    final isar = await _localReceivableRepo.databaseInstance;

    final receivable = await isar.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      final userIndex = receivable.participants.indexOf(userId);
      if (userIndex != -1) {
        final updatedPaidStatus = [...receivable.isPaid];
        updatedPaidStatus[userIndex] = true;

        receivable.isPaid = updatedPaidStatus;

        await isar.writeTxn(() async {
          await isar.isarReceivables.put(receivable);

          // Update sync status
          try {
            final status = IsarStatus()
              ..lastTimeUpdatedFirebase = DateTime.now()
              ..lastTimeUpdatedIsar = DateTime.now()
              ..receivableId = receivableId;
            await isar.isarStatuss.put(status);
          } catch (e) {
            // Ignore sync status errors
          }
        });

        // Update Firebase directly
        await firestore.FirebaseFirestore.instance
            .collection('Receivables')
            .doc(receivableId)
            .update({
              'isPaid': updatedPaidStatus,
              'lastModified': firestore.Timestamp.now(),
            });
      }
    }
  }

  Future<void> updateReceivedStatus(String receivableId, String userId) async {
    await initializeDatabase();
    final isar = await _localReceivableRepo.databaseInstance;

    final receivable = await isar.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      final userIndex = receivable.participants.indexOf(userId);
      if (userIndex != -1) {
        final updatedReceivedStatus = [...receivable.isReceived];
        updatedReceivedStatus[userIndex] = true;

        receivable.isReceived = updatedReceivedStatus;

        await isar.writeTxn(() async {
          await isar.isarReceivables.put(receivable);

          // Update sync status
          try {
            final status = IsarStatus()
              ..lastTimeUpdatedFirebase = DateTime.now()
              ..lastTimeUpdatedIsar = DateTime.now()
              ..receivableId = receivableId;
            await isar.isarStatuss.put(status);
          } catch (e) {
            // Ignore sync status errors
          }
        });

        // Update Firebase directly
        await firestore.FirebaseFirestore.instance
            .collection('Receivables')
            .doc(receivableId)
            .update({
              'isReceived': updatedReceivedStatus,
              'lastModified': firestore.Timestamp.now(),
            });
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
    final isar = await _localReceivableRepo.databaseInstance;

    final receivable = await isar.isarReceivables
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

      if (updatedParticipants.length <= 1) {
        await isar.writeTxn(() async {
          await isar.isarReceivables.delete(receivable.id);
        });
        await firestore.FirebaseFirestore.instance
            .collection('Receivables')
            .doc(receivableId)
            .delete();
      } else {
        receivable.participants = updatedParticipants;
        receivable.rate = updatedRates;
        receivable.isReceived = updatedIsReceived;
        receivable.isPaid = updatedIsPaid;

        await isar.writeTxn(() async {
          await isar.isarReceivables.put(receivable);

          // Update sync status
          try {
            final status = IsarStatus()
              ..lastTimeUpdatedFirebase = DateTime.now()
              ..lastTimeUpdatedIsar = DateTime.now()
              ..receivableId = receivableId;
            await isar.isarStatuss.put(status);
          } catch (e) {
            // Ignore sync status errors
          }
        });

        // Update Firebase directly
        await firestore.FirebaseFirestore.instance
            .collection('Receivables')
            .doc(receivableId)
            .update({
              'participants': updatedParticipants,
              'rate': updatedRates,
              'isReceived': updatedIsReceived,
              'isPaid': updatedIsPaid,
              'lastModified': firestore.Timestamp.now(),
            });
      }
    }
  }
}
