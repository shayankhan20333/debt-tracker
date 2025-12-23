import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/widgets/my_app_Bar.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivableDetailScreen extends StatefulWidget {
  final List<IsarReceivable> receivables;
  final String userName;
  final String? debtorId;
  final String initialFilter;

  const ReceivableDetailScreen({
    super.key,
    required this.receivables,
    required this.userName,
    this.debtorId,
    this.initialFilter = 'all',
  });

  @override
  State<ReceivableDetailScreen> createState() => _ReceivableDetailScreenState();
}

class _ReceivableDetailScreenState extends State<ReceivableDetailScreen> {
  bool _isProcessing = false;
  late String _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final totalOutstanding = widget.receivables.fold<double>(
      0,
      (prev, r) =>
          prev +
          r.rate.asMap().entries
              .where((e) => e.key > 0)
              .fold<double>(0, (p, e) => p + e.value),
    );
    return Scaffold(
      appBar: MyAppBar(
        title: "Receivable Details",
        hasTitleInCenter: true,
      ),
      body: Stack(
        children: [
          Consumer<ReceivableProvider>(
            builder: (context, provider, child) {
          final receivableIds = widget.receivables
              .map((r) => r.receivableId ?? '')
              .toList();
          final allReceivables = provider.getReceivables
              .where((r) => receivableIds.contains(r.receivableId ?? ''))
              .toList();

          return FutureBuilder<List<IsarReceivable>>(
            future: _filterAndSortReceivables(allReceivables),
            builder: (context, snapshot) {
              final sortedReceivables = snapshot.data ?? [];
              final visible = _applyFilter(sortedReceivables);

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: (visible.isEmpty ? 3 : visible.length + 2),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _detailHeader(
                      outstanding: totalOutstanding,
                      count: sortedReceivables.length,
                    );
                  }
                  if (index == 1) {
                    return _filterChips();
                  }
                  if (visible.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          TitleText(
                            title: _filter == 'settled'
                                ? "No Settled receivables"
                                : _filter == 'outstanding'
                                    ? "No Outstanding receivables"
                                    : "No Receivables",
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _filter = 'all';
                              });
                            },
                            child: const Text("Show All"),
                          ),
                        ],
                      ),
                    );
                  }
                  return receivableCard(visible[index - 2]);
                },
              );
            },
          );
        },
      ),
          if (_isProcessing)
            Container(
              color: const Color.fromARGB(80, 0, 0, 0),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  List<IsarReceivable> _applyFilter(List<IsarReceivable> items) {
    if (_filter == 'settled') {
      return items.where((r) => _isSettled(r)).toList();
    }
    if (_filter == 'outstanding') {
      return items.where((r) => !_isSettled(r)).toList();
    }
    return items;
  }

  bool _isSettled(IsarReceivable receivable) {
    final idx = _debtorIndex(receivable);
    if (idx == null) return false;
    if (idx >= receivable.isPaid.length || idx >= receivable.isReceived.length) {
      return false;
    }
    return receivable.isPaid[idx] && receivable.isReceived[idx];
  }

  int? _debtorIndex(IsarReceivable receivable) {
    if (widget.debtorId != null) {
      final idx = receivable.participants.indexOf(widget.debtorId!);
      if (idx > 0) return idx;
    }
    return null;
  }

  Widget _filterChips() {
    final filters = {
      'all': 'All',
      'outstanding': 'Outstanding',
      'settled': 'Settled',
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        children: filters.entries.map((entry) {
          final selected = _filter == entry.key;
          return ChoiceChip(
            label: Text(entry.value),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _filter = entry.key;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget receivableCard(IsarReceivable receivable) {
    final DateTime dateTime = receivable.createdAt ?? DateTime.now();
    final String formattedDateTime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    return FutureBuilder<double>(
      future: _getUserAmount(receivable),
      builder: (context, snapshot) {
        final userAmount = snapshot.data ?? 0.0;
        return _buildCard(receivable, formattedDateTime, userAmount);
      },
    );
  }

  Widget _buildCard(
    IsarReceivable receivable,
    String formattedDateTime,
    double userAmount,
  ) {
    final currentUserId = FirebaseAuthService().getCurrentUserId();
    final bool isCreator = receivable.participants.isNotEmpty &&
        receivable.participants.first == currentUserId;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.grey[850]!, Colors.grey[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TitleText(
                      title: receivable.description ?? 'No Description',
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SubtitleText(
                      title: formattedDateTime,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SubtitleText(
                      title: receivable.method ?? 'Unknown Method',
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SubtitleText(
                    title: "Rs $userAmount",
                    fontSize: 16,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, bool>>(
                key: ValueKey(
                  '${receivable.receivableId ?? ''}_${receivable.isReceived}_${receivable.isPaid}',
                ),
                future: _getReceivableStatus(receivable),
                builder: (context, snapshot) {
                  final status =
                      snapshot.data ?? {'isReceived': false, 'isPaid': false};
                  final settled = status['isReceived']! && status['isPaid']!;
                  return Row(
                    children: [
                      _statusChip(
                        label:
                            "Received: ${status['isReceived']! ? 'Yes' : 'No'}",
                        color: status['isReceived']!
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      _statusChip(
                        label: "Paid: ${status['isPaid']! ? 'Yes' : 'No'}",
                        color: status['isPaid']! ? Colors.green : Colors.orange,
                      ),
                      if (settled) ...[
                        const SizedBox(width: 8),
                        _statusChip(label: "Settled", color: Colors.green),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isCreator)
                    ElevatedButton.icon(
                      onPressed:
                          _isProcessing ? null : () => _showDeleteOptions(),
                      icon: Icon(Icons.delete, size: 16),
                      label: Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  FutureBuilder<Map<String, bool>>(
                    key: ValueKey(
                      '${receivable.receivableId ?? ''}_${receivable.isReceived}',
                    ),
                    future: _getUserPaymentStatus(receivable),
                    builder: (context, snapshot) {
                      final statuses = snapshot.data ??
                          const {'isPaid': false, 'isReceived': false};
                      final settled =
                          statuses['isPaid']! && statuses['isReceived']!;
                      if (settled) return SizedBox.shrink();
                      return Row(
                        children: [
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _isProcessing
                                ? null
                                : () => _markAsPaid(receivable),
                            icon: Icon(Icons.payment, size: 16),
                            label: Text('Receive'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: SubtitleText(
        title: label,
        fontSize: 11,
        color: color,
      ),
    );
  }

  Widget _detailHeader({required double outstanding, required int count}) {
    final colors = [
      Colors.blue.withOpacity(0.85),
      Colors.purple.withOpacity(0.75),
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                title: widget.userName,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 6),
              SubtitleText(
                title: "$count records",
                color: Colors.white70,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TitleText(
                title: "Rs ${outstanding.toStringAsFixed(0)}",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.assignment, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    SubtitleText(
                      title: "Details",
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _markAsPaid(IsarReceivable receivable) async {
    if (mounted) {
      setState(() {
        _isProcessing = true;
      });
    }
    final provider = Provider.of<ReceivableProvider>(context, listen: false);
    final debtorIndex = await _findUserIndex(receivable);
    if (debtorIndex != null && debtorIndex < receivable.participants.length) {
      final debtorId = receivable.participants[debtorIndex];
      await provider.updateReceivedStatus(
        context: context,
        receivableId: receivable.receivableId ?? '',
        userId: debtorId,
      );
    }
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> _showDeleteOptions() async {
    final currentUserId = FirebaseAuthService().getCurrentUserId();
    if (currentUserId == null) return;
    final isCreator = widget.receivables.isNotEmpty &&
        widget.receivables.first.participants.isNotEmpty &&
        widget.receivables.first.participants.first == currentUserId;
    if (!isCreator) return;

    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Delete entire receivable"),
              subtitle: const Text("Removes this record for everyone."),
              onTap: () => Navigator.pop(context, 'delete_all'),
            ),
            ListTile(
              leading: const Icon(Icons.person_remove, color: Colors.orange),
              title: const Text("Remove this user from receivable"),
              subtitle: Text("Removes only ${widget.userName} from this receivable."),
              onTap: () => Navigator.pop(context, 'remove_user'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );

    if (choice == 'delete_all') {
      await _deleteAllReceivables();
    } else if (choice == 'remove_user') {
      await _removeDebtorFromReceivables();
    }
  }

  Future<void> _deleteAllReceivables() async {
    if (_isProcessing) return;
    if (mounted) {
      setState(() {
        _isProcessing = true;
      });
    }
    final provider = Provider.of<ReceivableProvider>(context, listen: false);
    for (final r in widget.receivables) {
      await provider.deleteReceivable(
        context: context,
        receivableId: r.receivableId ?? '',
      );
    }
    if (!mounted) return;
    Navigator.pop(context);
    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> _removeDebtorFromReceivables() async {
    if (_isProcessing) return;
    if (mounted) {
      setState(() {
        _isProcessing = true;
      });
    }
    final provider = Provider.of<ReceivableProvider>(context, listen: false);
    for (final r in widget.receivables) {
      final idx = await _findUserIndex(r);
      if (idx != null && idx > 0) {
        await provider.removeUserFromReceivable(
          context: context,
          receivableId: r.receivableId ?? '',
          userIndex: idx,
        );
      }
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User removed from receivable")),
    );
    Navigator.pop(context);
    setState(() {
      _isProcessing = false;
    });
  }

  Future<Map<String, bool>> _getUserPaymentStatus(
    IsarReceivable receivable,
  ) async {
    final idx = await _findUserIndex(receivable);
    if (idx != null) {
      final paid = idx < receivable.isPaid.length
          ? receivable.isPaid[idx]
          : false;
      final received = idx < receivable.isReceived.length
          ? receivable.isReceived[idx]
          : false;
      return {'isPaid': paid, 'isReceived': received};
    }
    return {'isPaid': false, 'isReceived': false};
  }

  Future<List<IsarReceivable>> _filterAndSortReceivables(
    List<IsarReceivable> receivables,
  ) async {
    final List<MapEntry<IsarReceivable, bool>> receivablesWithStatus = [];

    for (final receivable in receivables) {
      // Check if user is still a participant with an amount > 0
      final userAmount = await _getUserAmount(receivable);
      if (userAmount > 0) {
        final status = await _getUserPaymentStatus(receivable);
        final settled = status['isPaid']! && status['isReceived']!;
        receivablesWithStatus.add(MapEntry(receivable, settled));
      }
    }

    receivablesWithStatus.sort((a, b) {
      // First sort by payment status (unpaid first)
      if (a.value && !b.value) return 1;
      if (!a.value && b.value) return -1;

      // Then sort by date/time (newest first)
      return (b.key.createdAt ?? DateTime.now()).compareTo(
        a.key.createdAt ?? DateTime.now(),
      );
    });

    return receivablesWithStatus.map((entry) => entry.key).toList();
  }

  Future<double> _getUserAmount(IsarReceivable receivable) async {
    final idx = await _findUserIndex(receivable);
    if (idx != null && idx < receivable.rate.length) {
      return receivable.rate[idx];
    }
    return 0.0;
  }

  Future<int?> _findUserIndex(IsarReceivable receivable) async {
    if (widget.debtorId != null) {
      final idx = receivable.participants.indexOf(widget.debtorId!);
      if (idx != -1) return idx;
    }
    for (int i = 0; i < receivable.participants.length; i++) {
      final userId = receivable.participants[i];
      final userService = UserService();
      final user = await userService.fetchUserById(userId);
      if (user?.userName == widget.userName) {
        return i;
      }
    }
    return null;
  }

  Future<Map<String, bool>> _getReceivableStatus(
    IsarReceivable receivable,
  ) async {
    final userIndex = await _findUserIndex(receivable);
    if (userIndex != null) {
      final isReceived = userIndex < receivable.isReceived.length
          ? receivable.isReceived[userIndex]
          : false;
      final isPaid = userIndex < receivable.isPaid.length
          ? receivable.isPaid[userIndex]
          : false;

      return {'isReceived': isReceived, 'isPaid': isPaid};
    }

    return {'isReceived': false, 'isPaid': false};
  }
}
