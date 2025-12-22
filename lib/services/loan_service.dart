import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/database_abstract_classes.dart';
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/DataBase/isar/isar_low_level_implementation.dart';
import 'package:depth_tracker/model/loan_model.dart';

class LoanService {
  static LoanService? _instance;

  late ILoanRepository _remoteLoanRepo;
  late ILoanRepository _localLoanRepo;

  LoanService._internal() {
    _remoteLoanRepo = FirebaseLoanRepository();
    _localLoanRepo = IsarLoanRepository();
    _instance = this;
    _startFirebaseListener();
  }

  factory LoanService() => _instance ?? LoanService._internal();

  void _startFirebaseListener() {
    firestore.FirebaseFirestore.instance.collection('Loans').snapshots().listen(
      (snapshot) {
        _syncFromFirebase(snapshot.docs);
      },
    );
  }

  Future<void> _syncFromFirebase(
    List<firestore.QueryDocumentSnapshot> docs,
  ) async {
    try {
      final isar = await _localLoanRepo.databaseInstance;
      final loans = docs.map<IsarLoan>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IsarLoan()
          ..loanId = data["id"]?.toString() ?? ''
          ..userId = data['userId']?.toString() ?? ''
          ..method = data['method']?.toString() ?? 'Unknown Method'
          ..rate = (data['rate'] as num?)?.toDouble() ?? 0.0
          ..createdAt = DateTime.now();
      }).toList();

      await isar.writeTxn(() async {
        await isar.isarLoans.clear();
        await isar.isarLoans.putAll(loans);
      });
    } catch (e) {
      print('Error syncing loans from Firebase: $e');
    }
  }

  Stream<List<IsarLoan>> watchLoans(String userId) async* {
    try {
      final isar = await _localLoanRepo.databaseInstance;
      yield* isar.isarLoans
          .filter()
          .userIdEqualTo(userId)
          .watch(fireImmediately: true);
    } catch (e) {
      print('Error watching loans: $e');
      yield [];
    }
  }

  Future<void> initializeDatabase() async {
    await _remoteLoanRepo.initializeDatabase();
    await _localLoanRepo.initializeDatabase();
  }

  Future<void> createLoan(LoanModel loan) async {
    await initializeDatabase();
    await _remoteLoanRepo.addLoan(loan);
    await _localLoanRepo.addLoan(loan);
  }

  Future<List<IsarLoan>> fetchAllLoans(String userId) async {
    await initializeDatabase();
    try {
      final isar = await _localLoanRepo.databaseInstance;
      return await isar.isarLoans.filter().userIdEqualTo(userId).findAll();
    } catch (e) {
      print('ERROR fetching loans: $e');
      return [];
    }
  }
}
