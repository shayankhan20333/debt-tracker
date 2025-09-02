import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depth_tracker/DataBase/database_abstract_classes.dart';
import 'package:depth_tracker/model/loan_model.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:depth_tracker/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUserRepository implements IUserRepository {
  static FirebaseUserRepository? _instance;
  static FirebaseApp? _firebaseApp;

  late CollectionReference<Map<String, dynamic>> _db;

  FirebaseUserRepository._internal();

  factory FirebaseUserRepository() {
    return _instance ??= FirebaseUserRepository._internal();
  }

  @override
  Future<FirebaseApp> get databaseInstance async {
    return _firebaseApp ??= await initializeDatabase();
  }

  @override
  Future<FirebaseApp> initializeDatabase() async {
    _firebaseApp ??= await Firebase.initializeApp();
    _db = FirebaseFirestore.instance.collection("Users");
    return _firebaseApp!;
  }

  @override
  Future<void> addUser(UserModel user) async {
    await _db.doc(user.userId).set({
      "userId": user.userId,
      "userName": user.userName,
      "userEmail": user.userEmail,
      "userContact": user.userContact,
      "userImagePath": user.userImagePath,
      "createdAccount": user.createdAt,
    });
  }

  @override
  Future<List<dynamic>> usersLength() async {
    final firestoreSnapshot = await _db.get();
    final firestoreUsers = firestoreSnapshot.docs;
    final firestoreCount = firestoreUsers.length;
    return [firestoreCount, firestoreUsers];
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    final snapshot = await _db.doc(userId).get();
    if (!snapshot.exists) return null;
    final data = snapshot.data()!;
    return UserModel(
      userId: userId,
      userName: data["userName"],
      userEmail: data["userEmail"],
      userContact: data["userContact"],
      userImagePath: data["userImagePath"],
      createdAt: data["createdAccount"],
    );
  }

  Future<List<Map<String, dynamic>>> fetchUserIdsAndNames() async {
    final querySnapshot = await _db.get();

    // Extract only id and name fields
    final users = querySnapshot.docs.map((doc) {
      return {'userId': doc['userId'], 'userName': doc['userName']};
    }).toList();

    return users;
  }
}

// -----------------------------------------------------------------------------
class FirebaseLoanRepository implements ILoanRepository {
  static FirebaseLoanRepository? _instance;
  static FirebaseApp? _firebaseApp;
  late CollectionReference<Map<String, dynamic>> _db;

  FirebaseLoanRepository._internal();

  factory FirebaseLoanRepository() {
    return _instance ??= FirebaseLoanRepository._internal();
  }

  @override
  Future<FirebaseApp> get databaseInstance async {
    return _firebaseApp ??= await initializeDatabase();
  }

  @override
  Future<FirebaseApp> initializeDatabase() async {
    _firebaseApp ??= await Firebase.initializeApp();
    _db = FirebaseFirestore.instance.collection("loans");
    return _firebaseApp!;
  }

  @override
  Future<List<dynamic>> loanLength() async {
    final snapshot = await _db.get();
    final docs = snapshot.docs;
    return [docs.length, docs];
  }

  @override
  Future<void> addLoan(LoanModel loan) async {
    await _db.doc(loan.id.toString()).set({
      "id": loan.id,
      "userId": loan.userId,
      "lenderUserId": loan.lenderUserId,
      "receivableId": loan.receivableId,
      "method": loan.method.name,
      "rate": loan.rate,
      "createdAt": Timestamp.now(),
    });
  }

  @override
  Future<List<LoanModel>> getLoans(String userId) async {
    final snapshot = await _db.where("userId", isEqualTo: userId).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return LoanModel(
        id: data['id'],
        userId: data["userId"],
        lenderUserId: data["lenderUserId"] ?? '',
        receivableId: data["receivableId"] ?? '',
        method: LoanMethod.values.firstWhere((m) => m.name == data["method"]),
        rate: (data["rate"] as num).toDouble(),
        createdAt: Timestamp.fromDate(data["createdAt"]),
      );
    }).toList();
  }
}

// -----------------------------------------------------------------------------
class FirebaseReceivableRepository implements IReceivableRepository {
  static FirebaseReceivableRepository? _instance;
  static FirebaseApp? _firebaseApp;
  late CollectionReference<Map<String, dynamic>> _db;

  FirebaseReceivableRepository._internal();

  factory FirebaseReceivableRepository() {
    return _instance ??= FirebaseReceivableRepository._internal();
  }

  @override
  Future<FirebaseApp> get databaseInstance async {
    return _firebaseApp ??= await initializeDatabase();
  }

  @override
  Future<FirebaseApp> initializeDatabase() async {
    _firebaseApp ??= await Firebase.initializeApp();
    _db = FirebaseFirestore.instance.collection("Receivables");
    return _firebaseApp!;
  }

  @override
  Future<List<dynamic>> receivablesLength() async {
    final snapshot = await _db.get();
    final docs = snapshot.docs;
    return [docs.length, docs];
  }

  @override
  Future<void> addReceivable(ReceivableModel receivable) async {
    await _db.doc(receivable.id.toString()).set({
      "id": receivable.id,
      "description": receivable.description,
      "participants": receivable.participants,
      "method": receivable.method,
      "rate": receivable.rate,
      "isReceived": receivable.isReceived,
      "isPaid": receivable.isPaid,
      "createdAt": Timestamp.now(),
    });
  }

  @override
  Future<List<ReceivableModel>> getReceivables(String userId) async {
    final snapshot = await _db.where("userId", isEqualTo: userId).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final participants = List<String>.from(data["participants"] ?? []);
      return ReceivableModel(
        id: data["id"],
        description: data["description"],
        participants: participants,
        method: data["method"],
        rate: List<double>.from(
          data["rate"]?.map((r) => (r as num).toDouble()) ?? [],
        ),
        isReceived: List<bool>.from(
          data["isReceived"] ?? List.filled(participants.length, false),
        ),
        isPaid: List<bool>.from(
          data["isPaid"] ?? List.filled(participants.length, false),
        ),
        createdAt: Timestamp.fromDate(data["createdAt"]),
      );
    }).toList();
  }

  @override
  Future<void> updateReceivable(String receivableId, List<bool> isPaid) async {
    await _db.doc(receivableId).update({"isPaid": isPaid});
  }

  Future<void> updateReceivableReceived(
    String receivableId,
    List<bool> isReceived,
  ) async {
    await _db.doc(receivableId).update({"isReceived": isReceived});
  }

  @override
  Future<void> deleteReceivable(String receivableId) async {
    await _db.doc(receivableId).delete();
  }
}

// -----------------------------------------------------------------------------
class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseAuthService? _instance;

  FirebaseAuthService._internal();

  factory FirebaseAuthService() {
    return _instance ??= FirebaseAuthService._internal();
  }

  @override
  Future<String?> createNewUserWithEmailandPassword(
    String email,
    String password,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return result.user?.uid;
  }

  @override
  Future<String?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user?.uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
      serverClientId:
          "292012661595-brlt3olikkpql73t49kr3ienkv2p9mea.apps.googleusercontent.com",
    );
    // await googleSignIn.disconnect();
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return "Login cancelled";
    }

    final googleAuth = await googleUser.authentication;
    late UserCredential credential;

    if (googleAuth.accessToken != null && googleAuth.idToken != null) {
      credential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );
    } else {
      return "Google sign-in failed: Missing tokens";
    }

    if (credential.additionalUserInfo!.isNewUser) {
      return "new user";
    }

    return "old user";
  }

  @override
  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
