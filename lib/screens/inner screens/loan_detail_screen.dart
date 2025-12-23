import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/widgets/my_app_Bar.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> loans;
  final String lenderName;
  final String initialFilter;

  const LoanDetailScreen({
    super.key,
    required this.loans,
    required this.lenderName,
    this.initialFilter = 'all',
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  bool _isProcessing = false;
  late String _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Loan Details",
        hasTitleInCenter: true,
      ),
      body: Stack(
        children: [
          Consumer<ReceivableProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _filterAndSortLoans(provider),
                builder: (context, snapshot) {
                  final sortedLoans = snapshot.data ?? [];
                  final visibleLoans = _applyFilter(sortedLoans);
                  final outstandingAmount = sortedLoans.fold<double>(
                    0,
                    (prev, loan) {
                      final settled = (loan['isPaid'] == true) &&
                          (loan['isReceived'] == true);
                      return settled
                          ? prev
                          : prev +
                              ((loan['amount'] as num?)?.toDouble() ?? 0.0);
                    },
                  );
                  final settledCount = sortedLoans
                      .where(
                        (loan) =>
                            (loan['isPaid'] == true) &&
                            (loan['isReceived'] == true),
                      )
                      .length;

                  if (visibleLoans.isEmpty) {
                    return Column(
                      children: [
                        _detailHeader(
                          outstanding: outstandingAmount,
                          count: sortedLoans.length,
                          settledCount: settledCount,
                        ),
                        _filterChips(),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TitleText(
                                  title: _filter == 'settled'
                                      ? "No Settled loans"
                                      : _filter == 'outstanding'
                                          ? "No Outstanding loans"
                                          : "No Loans Available",
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
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: visibleLoans.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _detailHeader(
                          outstanding: outstandingAmount,
                          count: sortedLoans.length,
                          settledCount: settledCount,
                        );
                      }
                      if (index == 1) {
                        return _filterChips();
                      }
                      return loanCard(visibleLoans[index - 2]);
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

  List<Map<String, dynamic>> _applyFilter(List<Map<String, dynamic>> items) {
    if (_filter == 'settled') {
      return items
          .where((loan) =>
              (loan['isPaid'] == true) && (loan['isReceived'] == true))
          .toList();
    }
    if (_filter == 'outstanding') {
      return items
          .where((loan) =>
              !(loan['isPaid'] == true && loan['isReceived'] == true))
          .toList();
    }
    return items;
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

  Widget loanCard(Map<String, dynamic> loan) {
    final DateTime dateTime =
        (loan['createdAt'] as DateTime?) ?? DateTime.now();
    final bool isPaid = loan['isPaid'] == true;
    final bool isReceived = loan['isReceived'] == true;
    final bool settled = isPaid && isReceived;
    final double amount = (loan['amount'] as num?)?.toDouble() ?? 0.0;
    final String formattedDateTime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    final statusColor = settled ? Colors.green : Colors.orangeAccent;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
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
                      title: loan['description'] ?? 'No Description',
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
              const SizedBox(height: 12),
              Row(
                children: [
                  _statusChip(
                    label: loan['method'] ?? 'Unknown Method',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  SubtitleText(
                    title: "Rs ${amount.toStringAsFixed(0)}",
                    fontSize: 16,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _statusChip(
                    label: "Paid: ${isPaid ? 'Yes' : 'No'}",
                    color: isPaid ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _statusChip(
                    label: "Received: ${isReceived ? 'Yes' : 'No'}",
                    color: isReceived ? Colors.green : Colors.orange,
                  ),
                  if (settled) ...[
                    const SizedBox(width: 8),
                    _statusChip(label: "Settled", color: Colors.green),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!settled)
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : () => _markAsPaid(loan),
                      icon: Icon(Icons.payment, size: 16),
                      label: Text('Pay'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _filterAndSortLoans(
    ReceivableProvider provider,
  ) async {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();
    final updatedLoans = <Map<String, dynamic>>[];

    for (final loan in widget.loans) {
      final receivableId = loan['receivableId'] as String?;
      double amount = (loan['amount'] as num?)?.toDouble() ?? 0.0;
      bool isPaid = loan['isPaid'] == true;
      bool isReceived = loan['isReceived'] == true;
      DateTime createdAt =
          (loan['createdAt'] as DateTime?) ?? DateTime.now();

      if (receivableId != null && currentUserId != null) {
        final receivable = provider.getReceivables
            .where((r) => r.receivableId == receivableId)
            .firstOrNull;
        if (receivable != null) {
          final userIndex = receivable.participants.indexOf(currentUserId);
          if (userIndex != -1) {
            if (userIndex < receivable.rate.length) {
              amount = receivable.rate[userIndex];
            }
            if (userIndex < receivable.isPaid.length) {
              isPaid = receivable.isPaid[userIndex];
            }
            if (userIndex < receivable.isReceived.length) {
              isReceived = receivable.isReceived[userIndex];
            }
          }
          createdAt = receivable.createdAt ?? createdAt;
        }
      }

      updatedLoans.add({
        ...loan,
        'amount': amount,
        'isPaid': isPaid,
        'isReceived': isReceived,
        'createdAt': createdAt,
      });
    }

    updatedLoans.sort((a, b) {
      final aSettled = (a['isPaid'] == true) && (a['isReceived'] == true);
      final bSettled = (b['isPaid'] == true) && (b['isReceived'] == true);
      if (aSettled && !bSettled) return 1;
      if (!aSettled && bSettled) return -1;
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    return updatedLoans;
  }

  Future<void> _markAsPaid(Map<String, dynamic> loan) async {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();

    if (currentUserId != null) {
      if (mounted) {
        setState(() {
          _isProcessing = true;
        });
      }
      final provider = Provider.of<ReceivableProvider>(context, listen: false);
      await provider.updatePaymentStatus(
        context: context,
        receivableId: loan['receivableId'] as String,
        userId: currentUserId,
      );
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Widget _detailHeader({
    required double outstanding,
    required int count,
    required int settledCount,
  }) {
    final colors = [
      Theme.of(context).colorScheme.primary.withOpacity(0.85),
      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            title: "Loans from ${widget.lenderName}",
            color: Colors.white,
            fontSize: 18,
          ),
          const SizedBox(height: 6),
          SubtitleText(
            title: "$count records • $settledCount settled",
            color: Colors.white70,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleText(
                    title: "Outstanding",
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 4),
                  TitleText(
                    title: "Rs ${outstanding.toStringAsFixed(0)}",
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.update, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      "Pull to refresh",
                      style: TextStyle(fontSize: 11, color: Colors.white),
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

  Widget _statusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: SubtitleText(
        title: label,
        fontSize: 12,
        color: color,
      ),
    );
  }
}
