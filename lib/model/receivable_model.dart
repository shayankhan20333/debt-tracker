import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/model/abstractModels/transaction_model.dart';

class ReceivableModel extends TransactionModel {
  @override
  final int id;
  final String description;
  final List<String> participants;
  final String method;
  final List<double> rate;
  final List<bool> isReceived;
  final List<bool> isPaid;
  @override
  final firestore.Timestamp createdAt;

  ReceivableModel({
    required this.id,
    required this.description,
    required this.participants,
    required this.method,
    required this.rate,
    required this.isReceived,
    required this.isPaid,
    required this.createdAt,
  });
}
