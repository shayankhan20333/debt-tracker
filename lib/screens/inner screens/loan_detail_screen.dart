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

  const LoanDetailScreen({
    super.key,
    required this.loans,
    required this.lenderName,
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Loans from ${widget.lenderName}",
        hasTitleDecoration: true,
      ),
      body: Stack(
        children: [
          Consumer<ReceivableProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _filterAndSortLoans(provider),
                builder: (context, snapshot) {
                  final sortedLoans = snapshot.data ?? [];

                  if (sortedLoans.isEmpty) {
                    return Center(child: TitleText(title: "No Loans Available"));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: sortedLoans.length,
                    itemBuilder: (context, index) {
                      return loanCard(sortedLoans[index]);
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

  Widget loanCard(Map<String, dynamic> loan) {
    final DateTime dateTime = loan['createdAt'] as DateTime;
    final String formattedDateTime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 58, 44, 44),
              const Color.fromARGB(255, 180, 38, 38),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.description, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: TitleText(
                      title: loan['description'] ?? 'No Description',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  SubtitleText(
                    title: formattedDateTime,
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.currency_rupee, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  SubtitleText(
                    title: 'Rs ${(loan['amount'] as double).roundToDouble()}',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.payment, color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  SubtitleText(
                    title: loan['method'] ?? 'Unknown Method',
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ],
              ),
              SizedBox(height: 8),
              FutureBuilder<Map<String, bool>>(
                key: ValueKey(
                  '${loan['receivableId']}_${DateTime.now().millisecondsSinceEpoch}',
                ),
                future: _getPaymentStatus(loan),
                builder: (context, snapshot) {
                  final status =
                      snapshot.data ?? {'isPaid': false, 'isReceived': false};
                  final settled = status['isPaid']! && status['isReceived']!;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payment, color: Colors.white70, size: 16),
                          SizedBox(width: 8),
                          SubtitleText(
                            title:
                                'You: ${status['isPaid']! ? 'Paid' : 'Not Paid'}',
                            fontSize: 14,
                            color: status['isPaid']!
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.receipt, color: Colors.white70, size: 16),
                          SizedBox(width: 8),
                          SubtitleText(
                            title: '${widget.lenderName}: ${status['isReceived']! ? 'Received' : 'Not Received'}',
                            fontSize: 14,
                            color: status['isReceived']!
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      SubtitleText(
                        title: settled ? 'Settled' : 'Outstanding',
                        fontSize: 12,
                        color: settled ? Colors.green : Colors.orange,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              Builder(builder: (context) {
                final loanPaid = loan['isPaid'] ?? false;
                final loanReceived = loan['isReceived'] ?? false;
                final loanSettled = loanPaid && loanReceived;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : () => _deleteLoan(loan),
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
                    if (!loanSettled) ...[
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed:
                            _isProcessing ? null : () => _markAsPaid(loan),
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
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _filterAndSortLoans(
    ReceivableProvider provider,
  ) async {
    // Sort: unpaid first, then by date
    final sortedLoans = List<Map<String, dynamic>>.from(widget.loans);
    sortedLoans.sort((a, b) {
      final aSettled =
          (a['isPaid'] ?? false) && (a['isReceived'] ?? false);
      final bSettled =
          (b['isPaid'] ?? false) && (b['isReceived'] ?? false);
      if (aSettled && !bSettled) return 1;
      if (!aSettled && bSettled) return -1;
      return (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime);
    });

    return sortedLoans;
  }

  Future<void> _deleteLoan(Map<String, dynamic> loan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Loan'),
        content: Text('Remove yourself from this loan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isProcessing = true;
      });
      await _removeUserFromLoan(loan);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _markAsPaid(Map<String, dynamic> loan) async {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();

    if (currentUserId != null) {
      setState(() {
        _isProcessing = true;
      });
      final provider = Provider.of<ReceivableProvider>(context, listen: false);
      await provider.updatePaymentStatus(
        context: context,
        receivableId: loan['receivableId'] as String,
        userId: currentUserId,
      );
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _removeUserFromLoan(Map<String, dynamic> loan) async {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();
    final provider = Provider.of<ReceivableProvider>(context, listen: false);
    final receivableId = loan['receivableId'] as String;

    // Find user index in the receivable
    final receivable = provider.getReceivables
        .where((r) => r.receivableId == receivableId)
        .firstOrNull;

    if (receivable != null && currentUserId != null) {
      final userIndex = receivable.participants.indexOf(currentUserId);
      if (userIndex != -1) {
        await provider.removeUserFromReceivable(
          context: context,
          receivableId: receivableId,
          userIndex: userIndex,
        );
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<Map<String, bool>> _getPaymentStatus(Map<String, dynamic> loan) async {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();
    final provider = Provider.of<ReceivableProvider>(context, listen: false);
    final receivableId = loan['receivableId'] as String;

    final receivable = provider.getReceivables
        .where((r) => r.receivableId == receivableId)
        .firstOrNull;

    if (receivable != null && currentUserId != null) {
      final userIndex = receivable.participants.indexOf(currentUserId);
      if (userIndex != -1) {
        final isPaid = userIndex < receivable.isPaid.length
            ? receivable.isPaid[userIndex]
            : false;
        final isReceived = userIndex < receivable.isReceived.length
            ? receivable.isReceived[userIndex]
            : false;

        return {'isPaid': isPaid, 'isReceived': isReceived};
      }
    }

    return {'isPaid': false, 'isReceived': false};
  }
}
