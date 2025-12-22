import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/database_abstract_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/model/loan_model.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:depth_tracker/model/user_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static Isar? _isar;
  
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }
    
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      IsarUserProfileSchema,
      IsarLoanSchema,
      IsarReceivableSchema,
      IsarStatusSchema,
    ], directory: dir.path);
    
    return _isar!;
  }
}

class IsarUserRepository implements IUserRepository {
  static IsarUserRepository? _instance;

  @override
  Future<Isar> get databaseInstance async {
    return await IsarService.getInstance();
  }

  IsarUserRepository._internal();

  factory IsarUserRepository() {
    return _instance ??= IsarUserRepository._internal();
  }

  @override
  Future<Isar> initializeDatabase() async {
    return await IsarService.getInstance();
  }

  @override
  Future<void> addUser(UserModel user) async {
    final isar = await IsarService.getInstance();
    final isarUser = IsarUserProfile()
      ..userId = user.userId
      ..userName = user.userName
      ..userEmail = user.userEmail
      ..userContact = user.userContact
      ..userImagePath = user.userImagePath
      ..createdAt = user.createdAt.toDate();

    await isar.writeTxn(() async {
      await isar.isarUserProfiles.put(isarUser);
    });
  }

  @override
  Future<int> usersLength() async {
    final isar = await IsarService.getInstance();
    return await isar.isarUserProfiles.count();
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    final isar = await IsarService.getInstance();
    final isarUser = await isar.isarUserProfiles
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
    final isar = await IsarService.getInstance();
    final isarUsers = await isar.isarUserProfiles.where().findAll();
    return isarUsers.map((user) => user.userName ?? '').toList();
  }
}

class IsarLoanRepository implements ILoanRepository {
  static IsarLoanRepository? _instance;

  @override
  Future<Isar> get databaseInstance async {
    return await IsarService.getInstance();
  }

  IsarLoanRepository._internal();

  factory IsarLoanRepository() {
    return _instance ??= IsarLoanRepository._internal();
  }

  @override
  Future<Isar> initializeDatabase() async {
    return await IsarService.getInstance();
  }

  @override
  Future<int> loanLength() async {
    final isar = await IsarService.getInstance();
    return await isar.isarLoans.count();
  }

  @override
  Future<void> addLoan(LoanModel loan) async {
    final isar = await IsarService.getInstance();
    final isarLoan = IsarLoan()
      ..loanId = loan.id.toString()
      ..userId = loan.userId
      ..method = loan.method.name
      ..rate = loan.rate
      ..createdAt = loan.createdAt.toDate();

    await isar.writeTxn(() async {
      await isar.isarLoans.put(isarLoan);
    });
  }

  @override
  Future<List<LoanModel>> getLoans(String userId) async {
    final isar = await IsarService.getInstance();
    final isarLoans = await isar.isarLoans
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

  @override
  Future<Isar> get databaseInstance async {
    return await IsarService.getInstance();
  }

  IsarReceivableRepository._internal();

  factory IsarReceivableRepository() {
    return _instance ??= IsarReceivableRepository._internal();
  }

  @override
  Future<Isar> initializeDatabase() async {
    return await IsarService.getInstance();
  }

  @override
  Future<int> receivablesLength() async {
    final isar = await IsarService.getInstance();
    return await isar.isarReceivables.count();
  }

  @override
  Future<void> addReceivable(ReceivableModel receivable) async {
    final isar = await IsarService.getInstance();
    final isarReceivable = IsarReceivable()
      ..receivableId = receivable.id.toString()
      ..participants = receivable.participants
      ..description = receivable.description
      ..method = receivable.method
      ..rate = receivable.rate
      ..isReceived = receivable.isReceived
      ..isPaid = receivable.isPaid
      ..createdAt = receivable.createdAt.toDate();

    await isar.writeTxn(() async {
      await isar.isarReceivables.put(isarReceivable);
    });
  }

  @override
  Future<List<ReceivableModel>> getReceivables(String userId) async {
    final isar = await IsarService.getInstance();
    final isarReceivables = await isar.isarReceivables.where().findAll();

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
    final isar = await IsarService.getInstance();
    final receivable = await isar.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      receivable.isPaid = isPaid;

      await isar.writeTxn(() async {
        await isar.isarReceivables.put(receivable);
      });
    }
  }

  @override
  Future<void> deleteReceivable(String receivableId) async {
    final isar = await IsarService.getInstance();
    final receivable = await isar.isarReceivables
        .filter()
        .receivableIdEqualTo(receivableId)
        .findFirst();

    if (receivable != null) {
      await isar.writeTxn(() async {
        await isar.isarReceivables.delete(receivable.id);
      });
    }
  }
}
