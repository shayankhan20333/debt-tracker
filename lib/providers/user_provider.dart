import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/my_app_function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class UserProvider with ChangeNotifier {
  late List<IsarUserProfile> _users = [];

  List<IsarUserProfile> get getUser {
    return _users;
  }

  Future<List<IsarUserProfile>> getAllUsers({
    required BuildContext context,
  }) async {
    try {
      _users = await UserService().fetchAllUsers();
    } on FirebaseException catch (error) {
      if (context.mounted) {
        MyAppFunction.showErrorAndAlertDialog(
          context: context,
          description: error.message.toString(),
          fucntionBtnName: 'Ok',
          function: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      }
    } on IsarError catch (error) {
      if (context.mounted) {
        MyAppFunction.showErrorAndAlertDialog(
          context: context,
          description: error.message.toString(),
          fucntionBtnName: 'Ok',
          function: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      }
    } catch (error) {
      if (context.mounted) {
        MyAppFunction.showErrorAndAlertDialog(
          context: context,
          description: error.toString(),
          fucntionBtnName: 'Ok',
          function: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      }
    }
    return _users;
  }
}
