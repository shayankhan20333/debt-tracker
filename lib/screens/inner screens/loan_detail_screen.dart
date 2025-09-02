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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Loans from ${widget.lenderName}",
        hasTitleDecoration: true,
      ),
      body: Consumer<ReceivableProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _filterAndSortLoans(provider),
            builder: (context, snapshot) {
              final sortedLoans = snapshot.data ?? [];

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
                            title:
                                '${widget.lenderName}: ${status['isReceived']! ? 'Received' : 'Not Received'}',
                            fontSize: 14,
                            color: status['isReceived']!
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _deleteLoan(loan),
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
                  if (!(loan['isPaid'] ?? false)) ...[
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _markAsPaid(loan),
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

    List<Map<String, dynamic>> validLoans = [];

    for (final loan in widget.loans) {
      final receivableId = loan['receivableId'] as String;
      final receivable = provider.getReceivables
          .where((r) => r.receivableId == receivableId)
          .firstOrNull;

      if (receivable != null) {
        // Check if current user is still a participant with amount > 0
        for (int i = 0; i < receivable.participants.length; i++) {
          if (receivable.participants[i] == currentUserId) {
            final amount = i < receivable.rate.length
                ? receivable.rate[i]
                : 0.0;
            if (amount > 0) {
              final isPaid = i < receivable.isPaid.length
                  ? receivable.isPaid[i]
                  : false;
              validLoans.add({...loan, 'amount': amount, 'isPaid': isPaid});
            }
            break;
          }
        }
      }
    }

    // Sort: unpaid first, then by date
    validLoans.sort((a, b) {
      final aPaid = a['isPaid'] ?? false;
      final bPaid = b['isPaid'] ?? false;
      if (aPaid && !bPaid) return 1;
      if (!aPaid && bPaid) return -1;
      return (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime);
    });

    return validLoans;
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
      await _removeUserFromLoan(loan);
    }
  }

  Future<void> _markAsPaid(Map<String, dynamic> loan) async {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();

    if (currentUserId != null) {
      final provider = Provider.of<ReceivableProvider>(context, listen: false);
      await provider.updatePaymentStatus(
        context: context,
        receivableId: loan['receivableId'] as String,
        userId: currentUserId,
      );
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
      final creatorIndex = 0; // Creator is always first

      if (userIndex != -1) {
        final isPaid = userIndex < receivable.isPaid.length
            ? receivable.isPaid[userIndex]
            : false;
        final isReceived = creatorIndex < receivable.isReceived.length
            ? receivable.isReceived[creatorIndex]
            : false;

        return {'isPaid': isPaid, 'isReceived': isReceived};
      }
    }

    return {'isPaid': false, 'isReceived': false};
  }
}
