import 'package:isar/isar.dart';

// dart run build_runner build --delete-conflicting-outputs

part 'isar_collections.g.dart';

@collection
class IsarUserProfile {
  Id id = Isar.autoIncrement;

  String? userId;
  String? userName;
  String? userEmail;
  String? userContact;
  String? userImagePath;
  DateTime? createdAt;
}

@collection
class IsarLoan {
  Id id = Isar.autoIncrement;

  String? loanId;
  String? userId;
  String? method;
  double? rate;
  DateTime? createdAt;
}

@collection
class IsarReceivable {
  Id id = Isar.autoIncrement;

  String? receivableId;
  String? description;
  List<String> participants = [];
  String? method;
  List<double> rate = [];
  List<bool> isReceived = [];
  List<bool> isPaid = [];
  DateTime? createdAt;
}

@collection
class IsarStatus {
  Id id = Isar.autoIncrement;
  DateTime? lastTimeUpdatedFirebase;
  DateTime? lastTimeUpdatedIsar;
  String? receivableId;
}
