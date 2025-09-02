import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:depth_tracker/services/receivable_service.dart';
import 'package:flutter/material.dart';

class ReceivableProvider with ChangeNotifier {
  late List<IsarReceivable> _receivables = [];
  late ReceivableService _receivableService;

  ReceivableProvider() {
    _receivableService = ReceivableService();
  }

  List<IsarReceivable> get getReceivables => _receivables;

  Future<void> createReceivable({
    required BuildContext context,
    required ReceivableModel receivable,
  }) async {
    await _receivableService.initializeDatabase();
    await _receivableService.createReceivable(receivable);
    notifyListeners();
  }

  Future<List<IsarReceivable>> getAllReceivables({
    required BuildContext context,
  }) async {
    try {
      await _receivableService.initializeDatabase();
      _receivables = await _receivableService.fetchAllReceivables();
      notifyListeners();
      return _receivables;
    } catch (e) {
      return [];
    }
  }

  Future<void> updatePaymentStatus({
    required BuildContext context,
    required String receivableId,
    required String userId,
  }) async {
    await _receivableService.updatePaymentStatus(receivableId, userId);
    if (!context.mounted) return;
    await getAllReceivables(context: context);
  }

  Future<void> updateReceivedStatus({
    required BuildContext context,
    required String receivableId,
    required String userId,
  }) async {
    await _receivableService.updateReceivedStatus(receivableId, userId);
    if (!context.mounted) return;
    await getAllReceivables(context: context);
  }

  Future<void> deleteReceivable({
    required BuildContext context,
    required String receivableId,
  }) async {
    await _receivableService.deleteReceivable(receivableId);
    if (!context.mounted) return;
    await getAllReceivables(context: context);
  }

  Future<void> removeUserFromReceivable({
    required BuildContext context,
    required String receivableId,
    required int userIndex,
  }) async {
    await _receivableService.removeUserFromReceivable(receivableId, userIndex);
    if (!context.mounted) return;
    await getAllReceivables(context: context);
  }
}
