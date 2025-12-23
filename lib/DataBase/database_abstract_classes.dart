import 'package:depth_tracker/model/loan_model.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:depth_tracker/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IUserRepository<T> {
  Future<T> get databaseInstance;
  Future<void> initializeDatabase();
  Future<T> usersLength();
  Future<void> addUser(UserModel user);
  Future<UserModel?> getUser(String userId);
}

abstract class ILoanRepository<T> {
  Future<T> get databaseInstance;
  Future<void> initializeDatabase();
  Future<T> loanLength();
  Future<void> addLoan(LoanModel loan);
  Future<List<LoanModel>> getLoans(String userId);
}

abstract class IReceivableRepository<T> {
  Future<T> get databaseInstance;
  Future<void> initializeDatabase();
  Future<T> receivablesLength();
  Future<void> addReceivable(ReceivableModel receivable);
  Future<List<ReceivableModel>> getReceivables(String userId);
  Future<void> updateReceivable(String receivableId, List<bool> isPaid);
  Future<void> deleteReceivable(String receivableId);
}

abstract class IAuthService {
  Future<String?> createNewUserWithEmailandPassword(
    String email,
    String password,
  );
  Future<String?> signInWithEmail(String email, String password);
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
  String? getCurrentUserId();
  Future<void> sendPasswordReset(String email);
}
