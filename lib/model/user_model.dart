import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class UserModel {
  final String userId;
  final String userName;
  final String userEmail;
  final String userContact;
  final String userImagePath;
  final firestore.Timestamp createdAt;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userContact,
    required this.userImagePath,
    required this.createdAt,
  });
}
