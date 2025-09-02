import 'package:depth_tracker/DataBase/database_abstract_classes.dart';
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/DataBase/isar/isar_low_level_implementation.dart';
import 'package:depth_tracker/model/user_model.dart';
import 'package:isar/isar.dart';

class UserService {
  static UserService? _instance;

  late IUserRepository _remoteUserRepo;
  late IUserRepository _localUserRepo;

  UserService._internal() {
    _remoteUserRepo = FirebaseUserRepository();
    _localUserRepo = IsarUserRepository();
    _instance = this;
  }

  factory UserService() => _instance ?? UserService._internal();

  Future<UserModel?> fetchUserById(String userId) async {
    final localUser = await _localUserRepo.getUser(userId);
    if (localUser != null) return localUser;

    final remoteUser = await _remoteUserRepo.getUser(userId);
    if (remoteUser != null) {
      await _localUserRepo.addUser(remoteUser);
    }
    return remoteUser;
  }

  Future<void> initlizeDataBase() async {
    await _remoteUserRepo.initializeDatabase();

    await _localUserRepo.initializeDatabase();
  }

  Future<void> createUser(UserModel user) async {
    await _remoteUserRepo.addUser(user);

    await _localUserRepo.addUser(user);
  }

  Future<List<IsarUserProfile>> fetchAllUsers() async {
    Isar isarInstance = await _localUserRepo.databaseInstance;

    List firebasedata = await _remoteUserRepo.usersLength();
    int isarcount = await _localUserRepo.usersLength();

    if (firebasedata[0] != isarcount) {
      // Fetch all users from Firebase
      final users = firebasedata[1].map<IsarUserProfile>((doc) {
        return IsarUserProfile()
          ..userId = doc["userId"]
          ..userName = doc['userName']
          ..userEmail = doc['userEmail']
          ..userContact = doc['userContact']
          ..userImagePath = doc['userImagePath']
          ..createdAt = DateTime.now();
      }).toList();

      await isarInstance.writeTxn(() async {
        await isarInstance.isarUserProfiles.clear();
        await isarInstance.isarUserProfiles.putAll(users);
      });
    }
    return await isarInstance.isarUserProfiles.where().findAll();
  }
}
