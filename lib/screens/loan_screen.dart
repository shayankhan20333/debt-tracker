import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/screens/inner%20screens/loan_detail_screen.dart';
import 'package:depth_tracker/services/assets_manager.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  String _searchQuery = '';
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllLoans();
    });
  }

  void getAllLoans() {
    final receivableProvider = Provider.of<ReceivableProvider>(
      context,
      listen: false,
    );
    receivableProvider.getAllReceivables(context: context);
  }

  void refreshLoans() {
    setState(() {
      getAllLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final receivableProvider = Provider.of<ReceivableProvider>(
      context,
      listen: true,
    );
    Size size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () async {
        refreshLoans();
      },
      child: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: getCurrentUserLoans(receivableProvider.getReceivables),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: TitleText(title: "Error loading loans"));
          }

          final lenderData = snapshot.data ?? {};
          final lenders = lenderData.keys.toList();

          // Sort lenders by outstanding amount (highest first)
          lenders.sort((a, b) {
            final aAmount = lenderData[a]!['outstandingAmount'] as double;
            final bAmount = lenderData[b]!['outstandingAmount'] as double;
            return bAmount.compareTo(aAmount);
          });

          final filteredLenders = lenders.where((lenderId) {
            final displayName =
                lenderData[lenderId]!['lenderName'] as String? ?? lenderId;
            final matchesSearch = displayName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
            final outstanding =
                (lenderData[lenderId]!['outstandingAmount'] as double? ?? 0);
            final settled =
                (lenderData[lenderId]!['settledAmount'] as double? ?? 0);
            final hasSettled = settled > 0;
            final hasOutstanding = outstanding > 0;
            if (_filter == 'settled' && !hasSettled) return false;
            if (_filter == 'outstanding' && !hasOutstanding) return false;
            return matchesSearch;
          }).toList();

          final totalOutstanding = lenderData.values.fold<double>(
            0,
            (prev, value) =>
                prev + ((value['outstandingAmount'] as double?) ?? 0.0),
          );

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: [
              _summaryHeader(
                totalAmount: totalOutstanding,
                count: lenders.length,
              ),
              const SizedBox(height: 12),
              _filters(),
              const SizedBox(height: 12),
              _searchBar(),
              const SizedBox(height: 12),
              if (filteredLenders.isEmpty)
                _filterEmptyState(),
              ...filteredLenders.map((lenderId) {
                final double totalOutstandingForLender =
                    (lenderData[lenderId]!['outstandingAmount'] as double?) ??
                        0.0;
                final double settledAmount =
                    (lenderData[lenderId]!['settledAmount'] as double?) ?? 0.0;
                final loans =
                    lenderData[lenderId]!['loans']
                        as List<Map<String, dynamic>>;
                final userImagePath =
                    (lenderData[lenderId]!['userImagePath'] as String?) ?? '';
                final lenderName =
                    lenderData[lenderId]!['lenderName'] as String? ?? lenderId;
                final hasSettled = settledAmount > 0;
                final hasOutstanding = totalOutstandingForLender > 0;
                if (_filter == 'settled' && !hasSettled) {
                  return const SizedBox.shrink();
                }
              if (_filter == 'outstanding' && !hasOutstanding) {
                  return const SizedBox.shrink();
                }
                final displayAmount =
                    _filter == 'settled' ? settledAmount : totalOutstandingForLender;
                final forceSettled =
                    _filter == 'settled' || (!hasOutstanding && hasSettled);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: customListTile(
                    size,
                    lenderName,
                    displayAmount,
                    loans,
                    userImagePath,
                    settledAmount: settledAmount,
                    forceSettled: forceSettled,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, Map<String, dynamic>>> getCurrentUserLoans(
    List<IsarReceivable> receivables,
  ) async {
    try {
      final authService = FirebaseAuthService();
      final userService = UserService();
      final currentUserId = authService.getCurrentUserId();

      if (currentUserId == null) return {};

      Map<String, Map<String, dynamic>> lenderData = {};

      for (var receivable in receivables) {
        if (receivable.participants.isEmpty) continue;

        final participants = receivable.participants;
        final debtorIndex = participants.indexOf(currentUserId);

        // Loans: current user must be a debtor (index > 0)
        if (debtorIndex <= 0) continue;

        // Ensure arrays are aligned
        if (receivable.rate.length <= debtorIndex ||
            receivable.isPaid.length <= debtorIndex ||
            receivable.isReceived.length <= debtorIndex) {
          continue;
        }

        final lenderId = participants[0];
        final creatorUser = await userService.fetchUserById(lenderId);
        final lenderName = creatorUser?.userName ?? lenderId;

        final amountOwed =
            (receivable.rate[debtorIndex] as num?)?.toDouble() ?? 0.0;
        final paid = receivable.isPaid[debtorIndex];
        final received = receivable.isReceived[debtorIndex];
        final settled = paid && received;

        final entry = lenderData.putIfAbsent(lenderId, () {
          return <String, dynamic>{
            'lenderName': lenderName,
            'userImagePath': creatorUser?.userImagePath,
            'loans': <Map<String, dynamic>>[],
            'outstandingAmount': 0.0,
            'settledAmount': 0.0,
          };
        });

        (entry['loans'] as List<Map<String, dynamic>>).add(<String, dynamic>{
          'receivableId': receivable.receivableId,
          'description': receivable.description,
          'amount': amountOwed,
          'method': receivable.method,
          'createdAt': receivable.createdAt ?? DateTime.now(),
          'isPaid': paid,
          'isReceived': received,
          'settled': settled,
          'lenderId': lenderId,
          'lenderName': lenderName,
        });

        if (settled) {
          entry['settledAmount'] =
              (entry['settledAmount'] as double) + amountOwed;
        } else {
          entry['outstandingAmount'] =
              (entry['outstandingAmount'] as double) + amountOwed;
        }
      }

      return lenderData;
    } catch (e) {
      return {};
    }
  }

  Widget _summaryHeader({required double totalAmount, required int count}) {
    final colors = [
      Theme.of(context).colorScheme.primary.withOpacity(0.85),
      Theme.of(context).colorScheme.secondary.withOpacity(0.65),
    ];
    return Container(
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  title: "Loans",
                  color: Colors.white,
                  fontSize: 18,
                ),
                const SizedBox(height: 6),
                SubtitleText(
                  title: "Outstanding to $count lenders",
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TitleText(
                  title: "Rs ${totalAmount.toStringAsFixed(0)}",
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.update, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      SubtitleText(
                        title: "Pull to refresh",
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    final filters = {
      'all': 'All',
      'outstanding': 'Outstanding',
      'settled': 'Settled',
    };
    return Wrap(
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
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search by lender",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (val) => setState(() {
        _searchQuery = val;
      }),
    );
  }

  Widget customListTile(
    Size size,
    String lenderName,
    double totalAmount,
    List<Map<String, dynamic>> loans,
    String userImagePath, {
    double settledAmount = 0,
    bool forceSettled = false,
  }) {
    final settled = forceSettled || (totalAmount <= 0 && settledAmount > 0);
    final statusColor = settled ? Colors.green : Colors.orangeAccent;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanDetailScreen(
              loans: loans,
              lenderName: lenderName,
              initialFilter: _filter,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[800],
              backgroundImage:
                  userImagePath.isNotEmpty ? NetworkImage(userImagePath) : null,
              child: userImagePath.isEmpty
                  ? Text(lenderName.isNotEmpty ? lenderName[0].toUpperCase() : '?')
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(title: lenderName, fontSize: 16),
                  const SizedBox(height: 4),
                  SubtitleText(
                    title: "${loans.length} records",
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                  if (settledAmount > 0)
                    SubtitleText(
                      title: "Settled: Rs ${settledAmount.toStringAsFixed(0)}",
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TitleText(
                  title: "Rs ${totalAmount.toStringAsFixed(0)}",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: SubtitleText(
                    title: settled ? "Settled" : "Pending",
                    fontSize: 11,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.filter_alt_off, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          TitleText(title: "No items for this filter"),
          const SizedBox(height: 6),
          SubtitleText(
            title: "Try switching filters or refreshing.",
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
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
}
