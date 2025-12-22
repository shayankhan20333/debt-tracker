import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

abstract class TransactionModel {
  int get id;
  firestore.Timestamp get createdAt;
}
