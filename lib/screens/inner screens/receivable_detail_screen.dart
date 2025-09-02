import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/my_app_Bar.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivableDetailScreen extends StatefulWidget {
  final List<IsarReceivable> receivables;
  final String userName;

  const ReceivableDetailScreen({
    super.key,
    required this.receivables,
    required this.userName,
  });

  @override
  State<ReceivableDetailScreen> createState() => _ReceivableDetailScreenState();
}

class _ReceivableDetailScreenState extends State<ReceivableDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "${widget.userName}'s Receivables",
        hasTitleDecoration: true,
      ),
      body: Consumer<ReceivableProvider>(
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

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: sortedReceivables.length,
                itemBuilder: (context, index) {
                  return receivableCard(sortedReceivables[index]);
                },
              );
            },
          );
        },
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
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.grey[800]!, Colors.grey[900]!],
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
                  Icon(Icons.description, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: TitleText(
                      title: receivable.description ?? 'No Description',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.green, size: 18),
                  SizedBox(width: 8),
                  SubtitleText(title: formattedDateTime, fontSize: 14),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.currency_rupee, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  SubtitleText(
                    title: 'Rs $userAmount',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.payment, color: Colors.purple, size: 18),
                  SizedBox(width: 8),
                  SubtitleText(title: receivable.method ?? 'Unknown Method', fontSize: 14),
                ],
              ),
              SizedBox(height: 8),
              FutureBuilder<Map<String, bool>>(
                key: ValueKey(
                  '${receivable.receivableId ?? ''}_${receivable.isReceived}_${receivable.isPaid}',
                ),
                future: _getReceivableStatus(receivable),
                builder: (context, snapshot) {
                  final status =
                      snapshot.data ?? {'isReceived': false, 'isPaid': false};
                  return Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt, color: Colors.blue, size: 16),
                          SizedBox(width: 8),
                          SubtitleText(
                            title:
                                'You: ${status['isReceived']! ? 'Received' : 'Not Received'}',
                            fontSize: 14,
                            color: status['isReceived']!
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.payment, color: Colors.purple, size: 16),
                          SizedBox(width: 8),
                          SubtitleText(
                            title:
                                '${widget.userName}: ${status['isPaid']! ? 'Paid' : 'Not Paid'}',
                            fontSize: 14,
                            color: status['isPaid']!
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
                    onPressed: () => _deleteReceivable(receivable),
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
                  FutureBuilder<bool>(
                    key: ValueKey(
                      '${receivable.receivableId ?? ''}_${receivable.isReceived}',
                    ),
                    future: _getUserPaymentStatus(receivable),
                    builder: (context, snapshot) {
                      final isPaid = snapshot.data ?? false;
                      if (isPaid) return SizedBox.shrink();
                      return Row(
                        children: [
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _markAsPaid(receivable),
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

  Future<void> _deleteReceivable(IsarReceivable receivable) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove User'),
        content: Text('Remove ${widget.userName} from this receivable?'),
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
      await _removeUserFromReceivable(receivable);
    }
  }

  Future<void> _markAsPaid(IsarReceivable receivable) async {
    // The creator (current user) is marking as received
    final creatorUserId = receivable.participants.first;

    final provider = Provider.of<ReceivableProvider>(context, listen: false);
    await provider.updateReceivedStatus(
      context: context,
      receivableId: receivable.receivableId ?? '',
      userId: creatorUserId,
    );
  }

  Future<bool> _getUserPaymentStatus(IsarReceivable receivable) async {
    for (int i = 0; i < receivable.participants.length; i++) {
      final userId = receivable.participants[i];
      final userService = UserService();
      final user = await userService.fetchUserById(userId);
      if (user?.userName == widget.userName) {
        return i < receivable.isReceived.length
            ? receivable.isReceived[i]
            : false;
      }
    }
    return false;
  }

  Future<List<IsarReceivable>> _filterAndSortReceivables(
    List<IsarReceivable> receivables,
  ) async {
    final List<MapEntry<IsarReceivable, bool>> receivablesWithStatus = [];

    for (final receivable in receivables) {
      // Check if user is still a participant with an amount > 0
      final userAmount = await _getUserAmount(receivable);
      if (userAmount > 0) {
        final isPaid = await _getUserPaymentStatus(receivable);
        receivablesWithStatus.add(MapEntry(receivable, isPaid));
      }
    }

    receivablesWithStatus.sort((a, b) {
      // First sort by payment status (unpaid first)
      if (a.value && !b.value) return 1;
      if (!a.value && b.value) return -1;

      // Then sort by date/time (newest first)
      return (b.key.createdAt ?? DateTime.now()).compareTo(a.key.createdAt ?? DateTime.now());
    });

    return receivablesWithStatus.map((entry) => entry.key).toList();
  }

  Future<double> _getUserAmount(IsarReceivable receivable) async {
    for (int i = 0; i < receivable.participants.length; i++) {
      final userId = receivable.participants[i];
      final userService = UserService();
      final user = await userService.fetchUserById(userId);
      if (user?.userName == widget.userName) {
        return i < receivable.rate.length ? receivable.rate[i] : 0.0;
      }
    }
    return 0.0;
  }

  Future<void> _removeUserFromReceivable(IsarReceivable receivable) async {
    // Find the user index
    int userIndex = -1;
    for (int i = 0; i < receivable.participants.length; i++) {
      final userId = receivable.participants[i];
      final userService = UserService();
      final user = await userService.fetchUserById(userId);
      if (user?.userName == widget.userName) {
        userIndex = i;
        break;
      }
    }

    if (userIndex != -1) {
      if (!mounted) return;
      final provider = Provider.of<ReceivableProvider>(context, listen: false);
      await provider.removeUserFromReceivable(
        context: context,
        receivableId: receivable.receivableId ?? '',
        userIndex: userIndex,
      );
    }
  }

  Future<Map<String, bool>> _getReceivableStatus(
    IsarReceivable receivable,
  ) async {
    // Find current user (creator) index - should be 0
    final creatorIndex = 0;

    // Find the specific user index
    int userIndex = -1;
    for (int i = 0; i < receivable.participants.length; i++) {
      final userId = receivable.participants[i];
      final userService = UserService();
      final user = await userService.fetchUserById(userId);
      if (user?.userName == widget.userName) {
        userIndex = i;
        break;
      }
    }

    if (userIndex != -1) {
      final isReceived = creatorIndex < receivable.isReceived.length
          ? receivable.isReceived[creatorIndex]
          : false;
      final isPaid = userIndex < receivable.isPaid.length
          ? receivable.isPaid[userIndex]
          : false;

      return {'isReceived': isReceived, 'isPaid': isPaid};
    }

    return {'isReceived': false, 'isPaid': false};
  }
}
