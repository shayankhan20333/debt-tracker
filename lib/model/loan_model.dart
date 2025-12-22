import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/model/abstractModels/transaction_model.dart';

enum LoanMethod { equalDistribution, perHead }

class LoanModel extends TransactionModel {
  @override
  final int id;
  final String userId; // Current user who owes money
  final String lenderUserId; // User who lent the money
  final String receivableId; // Reference to the original receivable
  final LoanMethod method;
  final double rate;
  @override
  final firestore.Timestamp createdAt;

  LoanModel({
    required this.id,
    required this.userId,
    required this.lenderUserId,
    required this.receivableId,
    required this.method,
    required this.rate,
    required this.createdAt,
  });
}
