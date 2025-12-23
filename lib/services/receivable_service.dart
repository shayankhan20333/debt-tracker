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

  List<T> _normalizeList<T>(
    List<T> values,
    int targetLength,
    T fillValue,
  ) {
    if (values.length >= targetLength) {
      return values.take(targetLength).toList();
    }
    return [...values, ...List.filled(targetLength - values.length, fillValue)];
  }

  Future<List<IsarReceivable>> _normalizeStoredReceivables(
    List<IsarReceivable> receivables,
  ) async {
    final isar = await _localReceivableRepo.databaseInstance;
    bool updated = false;

    for (final receivable in receivables) {
      final participantCount = receivable.participants.length;
      final alignedRates = _normalizeList<double>(
        List<double>.from(receivable.rate),
        participantCount,
        0.0,
      );
      final alignedReceived = _normalizeList<bool>(
        List<bool>.from(receivable.isReceived),
        participantCount,
        false,
      );
      final alignedPaid = _normalizeList<bool>(
        List<bool>.from(receivable.isPaid),
        participantCount,
        false,
      );

      final needsAlignment = alignedRates.length != receivable.rate.length ||
          alignedReceived.length != receivable.isReceived.length ||
          alignedPaid.length != receivable.isPaid.length;

      if (needsAlignment) {
        receivable
          ..rate = alignedRates
          ..isReceived = alignedReceived
          ..isPaid = alignedPaid;
        updated = true;
      }
    }

    if (updated) {
      await isar.writeTxn(() async {
        await isar.collection<IsarReceivable>().putAll(receivables);
      });
    }

    return receivables;
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
        final rates = _normalizeList<double>(
          List<double>.from(
            data['rate']?.map((r) => (r as num).toDouble()) ?? [],
          ),
          participants.length,
          0.0,
        );
        final received = _normalizeList<bool>(
          List<bool>.from(
            data['isReceived'] ?? [],
          ),
          participants.length,
          false,
        );
        final paid = _normalizeList<bool>(
          List<bool>.from(
            data['isPaid'] ?? [],
          ),
          participants.length,
          false,
        );
        return IsarReceivable()
          ..receivableId = data["id"]?.toString() ?? ''
          ..participants = participants
          ..description = data['description']?.toString() ?? 'No Description'
          ..method = data['method']?.toString() ?? 'Unknown Method'
          ..rate = rates
          ..isReceived = received
          ..isPaid = paid
          ..createdAt = createdAt;
      }).toList();

      await isar.writeTxn(() async {
        await isar.collection<IsarReceivable>().putAll(mapped);
      });
      final deduped = {
        for (final r in mapped) r.receivableId ?? r.id.toString(): r
      }.values.toList();
      return deduped;
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
          final rates = _normalizeList<double>(
            List<double>.from(
              data['rate']?.map((r) => (r as num).toDouble()) ?? [],
            ),
            participants.length,
            0.0,
          );
          final received = _normalizeList<bool>(
            List<bool>.from(data['isReceived'] ?? []),
            participants.length,
            false,
          );
          final paid = _normalizeList<bool>(
            List<bool>.from(data['isPaid'] ?? []),
            participants.length,
            false,
          );
          return IsarReceivable()
            ..receivableId = data["id"]?.toString() ?? ''
            ..participants = participants
            ..description = data['description']?.toString() ?? 'No Description'
            ..method = data['method']?.toString() ?? 'Unknown Method'
            ..rate = rates
            ..isReceived = received
            ..isPaid = paid
            ..createdAt = createdAt;
        }).toList();

        await isar.writeTxn(() async {
          await isar.collection<IsarReceivable>().putAll(receivables);
        });
        final List<IsarReceivable> stored =
            await isar.collection<IsarReceivable>().where().findAll();
        final List<IsarReceivable> deduped = {
          for (final r in stored) r.receivableId ?? r.id.toString(): r
        }.values.toList();
        return await _normalizeStoredReceivables(deduped);
      }

      final List<IsarReceivable> localReceivables =
          await (await _localReceivableRepo.databaseInstance)
              .collection<IsarReceivable>()
              .where()
              .findAll();
      final List<IsarReceivable> deduped = {
        for (final r in localReceivables) r.receivableId ?? r.id.toString(): r
      }.values.toList();
      return await _normalizeStoredReceivables(deduped);
    } catch (e) {
      print('ERROR fetching receivables: $e');
      return [];
    }
  }

  Future<void> _syncReceivables() async {
    try {
      final Isar isar = await _localReceivableRepo.databaseInstance;

      // Fallback to count-based sync
      List<dynamic> firebasedata = await _remoteReceivableRepo
          .receivablesLength();
      int isarcount = await _localReceivableRepo.receivablesLength();

      if (firebasedata[0] > isarcount) {
        final existingIds = await isar
            .collection<IsarReceivable>()
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
              final rates = _normalizeList<double>(
                List<double>.from(
                  data['rate']?.map((r) => (r as num).toDouble()) ?? [],
                ),
                participants.length,
                0.0,
              );
              final received = _normalizeList<bool>(
                List<bool>.from(
                  data['isReceived'] ?? [],
                ),
                participants.length,
                false,
              );
              final paid = _normalizeList<bool>(
                List<bool>.from(
                  data['isPaid'] ?? [],
                ),
                participants.length,
                false,
              );
              final createdAt = _parseCreatedAt(
                data['createdAt'],
                data["id"]?.toString() ?? '',
              );
              return IsarReceivable()
                ..receivableId = data["id"]?.toString() ?? ''
                ..participants = participants
                ..description =
                    data['description']?.toString() ?? 'No Description'
                ..method = data['method']?.toString() ?? 'Unknown Method'
                ..rate = rates
                ..isReceived = received
                ..isPaid = paid
                ..createdAt = createdAt;
            })
            .toList();

        if (newReceivables.isNotEmpty) {
          await isar.writeTxn(() async {
            await isar.collection<IsarReceivable>().putAll(newReceivables);
          });
        }
      }
    } catch (e) {
      // Ignore sync errors
    }
  }

  Future<firestore.DocumentReference<Map<String, dynamic>>?>
      _resolveDocRef(String receivableId) async {
    final collection =
        firestore.FirebaseFirestore.instance.collection('Receivables');
    final directRef = collection.doc(receivableId);
    final directSnap = await directRef.get();
    if (directSnap.exists) return directRef;

    final fallback = await collection
        .where('id', isEqualTo: receivableId)
        .limit(1)
        .get();
    if (fallback.docs.isNotEmpty) {
      return fallback.docs.first.reference;
    }
    return null;
  }

  Future<void> updatePaymentStatus(String receivableId, String userId) async {
    await initializeDatabase();
    final Isar isar = await _localReceivableRepo.databaseInstance;

    final receivable = await isar
        .collection<IsarReceivable>()
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      final userIndex = receivable.participants.indexOf(userId);
      if (userIndex != -1) {
        final updatedPaidStatus = _normalizeList<bool>(
          List<bool>.from(receivable.isPaid),
          receivable.participants.length,
          false,
        );
        updatedPaidStatus[userIndex] = true;

        receivable.isPaid = updatedPaidStatus;

        await isar.writeTxn(() async {
          await isar.collection<IsarReceivable>().put(receivable);

          // Update sync status
          try {
            final status = IsarStatus()
              ..lastTimeUpdatedFirebase = DateTime.now()
              ..lastTimeUpdatedIsar = DateTime.now()
              ..receivableId = receivableId;
            await isar.collection<IsarStatus>().put(status);
          } catch (e) {
            // Ignore sync status errors
          }
        });

        // Update Firebase directly
        final docRef = await _resolveDocRef(receivableId);
        if (docRef != null) {
          try {
            await docRef.update({
              'isPaid': updatedPaidStatus,
              'lastModified': firestore.Timestamp.now(),
            });
          } on firestore.FirebaseException catch (e) {
            if (e.code != 'not-found') rethrow;
          }
        }
      }
    }
  }

  Future<void> updateReceivedStatus(String receivableId, String userId) async {
    await initializeDatabase();
    final Isar isar = await _localReceivableRepo.databaseInstance;

    final receivable = await isar
        .collection<IsarReceivable>()
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      final userIndex = receivable.participants.indexOf(userId);
      if (userIndex != -1) {
        final updatedReceivedStatus = _normalizeList<bool>(
          List<bool>.from(receivable.isReceived),
          receivable.participants.length,
          false,
        );
        updatedReceivedStatus[userIndex] = true;

        receivable.isReceived = updatedReceivedStatus;

        await isar.writeTxn(() async {
          await isar.collection<IsarReceivable>().put(receivable);

          // Update sync status
          try {
            final status = IsarStatus()
              ..lastTimeUpdatedFirebase = DateTime.now()
              ..lastTimeUpdatedIsar = DateTime.now()
              ..receivableId = receivableId;
            await isar.collection<IsarStatus>().put(status);
          } catch (e) {
            // Ignore sync status errors
          }
        });

        // Update Firebase directly
        final docRef = await _resolveDocRef(receivableId);
        if (docRef != null) {
          try {
            await docRef.update({
              'isReceived': updatedReceivedStatus,
              'lastModified': firestore.Timestamp.now(),
            });
          } on firestore.FirebaseException catch (e) {
            if (e.code != 'not-found') rethrow;
          }
        }
      }
    }
  }

  Future<void> deleteReceivable(String receivableId) async {
    await initializeDatabase();
    final currentUserId = FirebaseAuthService().getCurrentUserId();
    if (currentUserId == null) return;

    final Isar isar = await _localReceivableRepo.databaseInstance;
    final existing = await isar
        .collection<IsarReceivable>()
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (existing == null ||
        existing.participants.isEmpty ||
        existing.participants.first != currentUserId) {
      return;
    }

    await _localReceivableRepo.deleteReceivable(receivableId);
    final docRef = await _resolveDocRef(receivableId);
    if (docRef != null) {
      try {
        await docRef.delete();
      } on firestore.FirebaseException catch (e) {
        if (e.code != 'not-found') rethrow;
      }
    }
    await _remoteReceivableRepo.deleteReceivable(receivableId);
  }

  Future<void> removeUserFromReceivable(
    String receivableId,
    int userIndex,
  ) async {
    await initializeDatabase();
    final Isar isar = await _localReceivableRepo.databaseInstance;

    final receivable = await isar
        .collection<IsarReceivable>()
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null && userIndex < receivable.participants.length) {
      final updatedParticipants = [...receivable.participants];
      final updatedRates = _normalizeList<double>(
        List<double>.from(receivable.rate),
        updatedParticipants.length,
        0.0,
      );
      final updatedIsReceived = _normalizeList<bool>(
        List<bool>.from(receivable.isReceived),
        updatedParticipants.length,
        false,
      );
      final updatedIsPaid = _normalizeList<bool>(
        List<bool>.from(receivable.isPaid),
        updatedParticipants.length,
        false,
      );

      updatedParticipants.removeAt(userIndex);
      if (userIndex < updatedRates.length) updatedRates.removeAt(userIndex);
      if (userIndex < updatedIsReceived.length) {
        updatedIsReceived.removeAt(userIndex);
      }
      if (userIndex < updatedIsPaid.length) updatedIsPaid.removeAt(userIndex);

      if (updatedParticipants.length <= 1) {
        await isar.writeTxn(() async {
          await isar.collection<IsarReceivable>().delete(receivable.id);
        });
        final docRef = await _resolveDocRef(receivableId);
        if (docRef != null) {
          try {
            await docRef.delete();
          } on firestore.FirebaseException catch (e) {
            if (e.code != 'not-found') rethrow;
          }
        }
      } else {
        receivable.participants = updatedParticipants;
        receivable.rate = updatedRates;
        receivable.isReceived = updatedIsReceived;
        receivable.isPaid = updatedIsPaid;

        await isar.writeTxn(() async {
          await isar.collection<IsarReceivable>().put(receivable);

          // Update sync status
          try {
            final status = IsarStatus()
              ..lastTimeUpdatedFirebase = DateTime.now()
              ..lastTimeUpdatedIsar = DateTime.now()
              ..receivableId = receivableId;
            await isar.collection<IsarStatus>().put(status);
          } catch (e) {
            // Ignore sync status errors
          }
        });

        // Update Firebase directly
        final docRef = await _resolveDocRef(receivableId);
        if (docRef != null) {
          try {
            await docRef.update({
              'participants': updatedParticipants,
              'rate': updatedRates,
              'isReceived': updatedIsReceived,
              'isPaid': updatedIsPaid,
              'lastModified': firestore.Timestamp.now(),
            });
          } on firestore.FirebaseException catch (e) {
            if (e.code != 'not-found') rethrow;
          }
        }
      }
    }
  }
}
