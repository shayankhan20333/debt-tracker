import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/database_abstract_classes.dart';
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/DataBase/isar/isar_low_level_implementation.dart';
import 'package:depth_tracker/model/loan_model.dart';
import 'package:isar/isar.dart';

class LoanService {
  static LoanService? _instance;

  late ILoanRepository _remoteLoanRepo;
  late ILoanRepository _localLoanRepo;

  LoanService._internal() {
    _remoteLoanRepo = FirebaseLoanRepository();
    _localLoanRepo = IsarLoanRepository();
    _instance = this;
  }

  factory LoanService() => _instance ?? LoanService._internal();

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
    Isar isarInstance = await _localLoanRepo.databaseInstance;

    List<dynamic> firebasedata = await _remoteLoanRepo.loanLength();
    int isarcount = await _localLoanRepo.loanLength();

    if (firebasedata[0] > isarcount) {
      final existingIds = await isarInstance.isarLoans
          .where()
          .loanIdProperty()
          .findAll();

      final newLoans = firebasedata[1]
          .where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final docId = data["id"]?.toString() ?? '';
            return !existingIds.contains(docId);
          })
          .map<IsarLoan>((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return IsarLoan()
              ..loanId = data["id"]?.toString() ?? ''
              ..userId = data['userId']?.toString() ?? ''
              ..method = data['method']?.toString() ?? 'Unknown Method'
              ..rate = (data['rate'] as num?)?.toDouble() ?? 0.0
              ..createdAt = DateTime.now();
          })
          .toList();

      if (newLoans.isNotEmpty) {
        await isarInstance.writeTxn(() async {
          await isarInstance.isarLoans.putAll(newLoans);
        });
      }
    } else if (isarcount > firebasedata[0]) {
      final firebaseIds = firebasedata[1].map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data["id"]?.toString() ?? '';
      }).toList();

      final localLoans = await isarInstance.isarLoans.where().findAll();
      final newLocalLoans = localLoans.where((loan) {
        return !firebaseIds.contains(loan.loanId);
      }).toList();

      for (var loan in newLocalLoans) {
        final loanModel = LoanModel(
          id: int.parse(loan.loanId ?? '0'),
          userId: loan.userId ?? '',
          lenderUserId: '', // Default empty since we don't have this info
          receivableId: '', // Default empty since we don't have this info
          method: LoanMethod.values.firstWhere(
            (m) => m.name == loan.method,
            orElse: () => LoanMethod.equalDistribution,
          ),
          rate: loan.rate ?? 0.0,
          createdAt: firestore.Timestamp.fromDate(loan.createdAt ?? DateTime.now()),
        );
        await _remoteLoanRepo.addLoan(loanModel);
      }
    }

    return await isarInstance.isarLoans.filter().userIdEqualTo(userId).findAll();
  }
}
