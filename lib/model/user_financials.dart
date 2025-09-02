import 'package:cloud_firestore/cloud_firestore.dart'  as firestore;

class UserFinancials {
  final double totalReceivables;
  final double totalLoan;
  final firestore.Timestamp timestamp;

  UserFinancials({
    required this.totalReceivables,
    required this.totalLoan,
    required this.timestamp,
  });
}
