import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:depth_tracker/services/receivable_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ReceivableProvider with ChangeNotifier {
  late List<IsarReceivable> _receivables = [];
  late ReceivableService _receivableService;
  StreamSubscription<List<IsarReceivable>>? _subscription;

  ReceivableProvider() {
    _receivableService = ReceivableService();
  }

  List<IsarReceivable> get getReceivables => _receivables;

  List<IsarReceivable> _dedupeById(List<IsarReceivable> items) {
    final Map<String, IsarReceivable> byId = {};
    for (final item in items) {
      final id = item.receivableId ?? item.id.toString();
      byId[id] = item;
    }
    return byId.values.toList();
  }

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
      _receivables =
          _dedupeById(await _receivableService.fetchAllReceivables());
      notifyListeners();
      return _receivables;
    } catch (e) {
      return [];
    }
  }
  
  Stream<List<IsarReceivable>> watchReceivables() {
    return _receivableService.watchReceivables();
  }
  
  void startListening() {
    _subscription?.cancel();
    _subscription = _receivableService.watchReceivables().listen(
      (receivables) {
        _receivables = _dedupeById(receivables);
        notifyListeners();
      },
    );
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
    _receivables.removeWhere(
      (r) => (r.receivableId ?? r.id.toString()) == receivableId,
    );
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
