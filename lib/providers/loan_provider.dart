import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/model/loan_model.dart';
import 'package:depth_tracker/services/loan_service.dart';
import 'package:flutter/material.dart';

class LoanProvider with ChangeNotifier {
  late List<IsarLoan> _loans = [];
  late LoanService _loanService;

  LoanProvider() {
    _loanService = LoanService();
  }

  List<IsarLoan> get getLoans => _loans;

  Future<void> createLoan({
    required BuildContext context,
    required LoanModel loan,
  }) async {
    await _loanService.initializeDatabase();
    await _loanService.createLoan(loan);
    notifyListeners();
  }

  Future<List<IsarLoan>> getAllLoans({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      await _loanService.initializeDatabase();
      _loans = await _loanService.fetchAllLoans(userId);
      notifyListeners();
      return _loans;
    } catch (e) {
      return [];
    }
  }
}
