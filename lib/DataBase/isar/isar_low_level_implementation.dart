import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/database_abstract_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/model/loan_model.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:depth_tracker/model/user_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarUserRepository implements IUserRepository {
  static IsarUserRepository? _instance;
  static Isar? _isar;

  @override
  Future<Isar> get databaseInstance async {
    if (_isar == null || !_isar!.isOpen) {
      await initializeDatabase();
    }
    return _isar!;
  }

  IsarUserRepository._internal();

  factory IsarUserRepository() {
    return _instance ??= IsarUserRepository._internal();
  }

  @override
  Future<Isar> initializeDatabase() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      IsarUserProfileSchema,
      IsarLoanSchema,
      IsarReceivableSchema,
    ], directory: dir.path);

    return _isar!;
  }

  @override
  Future<void> addUser(UserModel user) async {
    final isarUser = IsarUserProfile()
      ..userId = user.userId
      ..userName = user.userName
      ..userEmail = user.userEmail
      ..userContact = user.userContact
      ..userImagePath = user.userImagePath
      ..createdAt = user.createdAt.toDate();

    await _isar!.writeTxn(() async {
      await _isar!.isarUserProfiles.put(isarUser);
    });
  }

  @override
  Future<int> usersLength() async {
    return await _isar!.isarUserProfiles.count();
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    final isarUser = await _isar!.isarUserProfiles
        .filter()
        .userIdEqualTo(userId)
        .findFirst();

    if (isarUser == null) return null;

    return UserModel(
      userId: isarUser.userId ?? '',
      userName: isarUser.userName ?? '',
      userEmail: isarUser.userEmail ?? '',
      userContact: isarUser.userContact ?? '',
      userImagePath: isarUser.userImagePath ?? '',
      createdAt: firestore.Timestamp.fromDate(
        isarUser.createdAt ?? DateTime.now(),
      ),
    );
  }

  Future<List<String>> getOtherUser() async {
    final isarUsers = await _isar!.isarUserProfiles.where().findAll();
    return isarUsers.map((user) => user.userName ?? '').toList();
  }
}

class IsarLoanRepository implements ILoanRepository {
  static IsarLoanRepository? _instance;
  static Isar? _isar;

  @override
  Future<Isar> get databaseInstance async {
    if (_isar == null || !_isar!.isOpen) {
      await initializeDatabase();
    }
    return _isar!;
  }

  IsarLoanRepository._internal();

  factory IsarLoanRepository() {
    return _instance ??= IsarLoanRepository._internal();
  }

  @override
  Future<Isar> initializeDatabase() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      IsarUserProfileSchema,
      IsarLoanSchema,
      IsarReceivableSchema,
    ], directory: dir.path);
    return _isar!;
  }

  @override
  Future<int> loanLength() async {
    return await _isar!.isarLoans.count();
  }

  @override
  Future<void> addLoan(LoanModel loan) async {
    final isarLoan = IsarLoan()
      ..loanId = loan.id.toString()
      ..userId = loan.userId
      ..method = loan.method.name
      ..rate = loan.rate
      ..createdAt = loan.createdAt.toDate();

    await _isar!.writeTxn(() async {
      await _isar!.isarLoans.put(isarLoan);
    });
  }

  @override
  Future<List<LoanModel>> getLoans(String userId) async {
    final isarLoans = await _isar!.isarLoans
        .filter()
        .userIdEqualTo(userId)
        .findAll();

    return isarLoans
        .map(
          (l) => LoanModel(
            id: l.id,
            userId: l.userId ?? '',
            lenderUserId: '', // Default empty for existing data
            receivableId: '', // Default empty for existing data
            method: LoanMethod.values.firstWhere((m) => m.name == l.method),
            rate: l.rate ?? 0.0,
            createdAt: firestore.Timestamp.fromDate(
              l.createdAt ?? DateTime.now(),
            ),
          ),
        )
        .toList();
  }
}

class IsarReceivableRepository implements IReceivableRepository {
  static IsarReceivableRepository? _instance;
  static Isar? _isar;

  @override
  Future<Isar> get databaseInstance async {
    if (_isar == null || !_isar!.isOpen) {
      await initializeDatabase();
    }
    return _isar!;
  }

  IsarReceivableRepository._internal();

  factory IsarReceivableRepository() {
    return _instance ??= IsarReceivableRepository._internal();
  }

  @override
  Future<Isar> initializeDatabase() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      IsarUserProfileSchema,
      IsarLoanSchema,
      IsarReceivableSchema,
    ], directory: dir.path);
    return _isar!;
  }

  @override
  Future<int> receivablesLength() async {
    return await _isar!.isarReceivables.count();
  }

  @override
  Future<void> addReceivable(ReceivableModel receivable) async {
    final isarReceivable = IsarReceivable()
      ..receivableId = receivable.id.toString()
      ..participants = receivable.participants
      ..description = receivable.description
      ..method = receivable.method
      ..rate = receivable.rate
      ..isReceived = receivable.isReceived
      ..isPaid = receivable.isPaid
      ..createdAt = receivable.createdAt.toDate();

    await _isar!.writeTxn(() async {
      await _isar!.isarReceivables.put(isarReceivable);
    });
  }

  @override
  Future<List<ReceivableModel>> getReceivables(String userId) async {
    final isarReceivables = await _isar!.isarReceivables.where().findAll();

    return isarReceivables
        .map(
          (r) => ReceivableModel(
            id: r.id,
            description: r.description ?? '',
            participants: r.participants,
            method: r.method ?? '',
            rate: r.rate,
            isReceived: r.isReceived,
            isPaid: r.isPaid,
            createdAt: firestore.Timestamp.fromDate(
              r.createdAt ?? DateTime.now(),
            ),
          ),
        )
        .toList();
  }

  @override
  Future<void> updateReceivable(String receivableId, List<bool> isPaid) async {
    final receivable = await _isar!.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      receivable.isPaid = isPaid;

      await _isar!.writeTxn(() async {
        await _isar!.isarReceivables.put(receivable);
      });
    }
  }

  @override
  Future<void> deleteReceivable(String receivableId) async {
    final receivable = await _isar!.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      await _isar!.writeTxn(() async {
        await _isar!.isarReceivables.delete(receivable.id);
      });
    }
  }
}
