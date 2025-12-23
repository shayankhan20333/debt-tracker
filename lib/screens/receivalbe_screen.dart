import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/screens/inner%20screens/receivable_detail_screen.dart';
import 'package:depth_tracker/screens/form/recievable_form_screen.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivalbeScreen extends StatefulWidget {
  const ReceivalbeScreen({super.key});

  @override
  State<ReceivalbeScreen> createState() => _ReceivalbeScreenState();
}

class _ReceivalbeScreenState extends State<ReceivalbeScreen> {
  String _searchQuery = '';
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final receivableProvider = Provider.of<ReceivableProvider>(
        context,
        listen: false,
      );
      receivableProvider.startListening();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() {
    getAllReceivalbes();
  }

  Future<Map<String, Map<String, dynamic>>> getAllUserTotals(
    List<IsarReceivable> receivables,
  ) async {
    final userService = UserService();
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();
    Map<String, Map<String, dynamic>> userData = {};

    for (var receivable in receivables) {
      // Only process receivables where current user is the creator (first participant)
      if (receivable.participants.isEmpty ||
          receivable.participants[0] != currentUserId) {
        continue;
      }

      for (int i = 1; i < receivable.participants.length; i++) {
        final userId = receivable.participants[i];

        final user = await userService.fetchUserById(userId);
        final userName = user?.userName ?? 'Unknown User';
        final amount = i < receivable.rate.length ? receivable.rate[i] : 0.0;
        final isReceived = i < receivable.isReceived.length
            ? receivable.isReceived[i]
            : false;
        final isPaid =
            i < receivable.isPaid.length ? receivable.isPaid[i] : false;
        final settled = isPaid && isReceived;

        if (amount > 0) {
          final entry = userData.putIfAbsent(userName, () {
            return {
              'userId': userId,
              'outstanding': 0.0,
              'settled': 0.0,
              'receivableIds': <String>[],
              'userImagePath': user?.userImagePath,
            };
          });

          if (settled) {
            entry['settled'] = (entry['settled'] as double) + amount;
          } else {
            entry['outstanding'] = (entry['outstanding'] as double) + amount;
          }
          (entry['receivableIds'] as List<String>)
              .add(receivable.receivableId ?? '');
          entry['userImagePath'] = user?.userImagePath;
        }
      }
    }

    return userData;
  }

  void getAllReceivalbes() {
    final receivableProvider = Provider.of<ReceivableProvider>(
      context,
      listen: false,
    );
    receivableProvider.getAllReceivables(context: context);
  }

  void refreshReceivables() {
    setState(() {
      getAllReceivalbes();
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
        refreshReceivables();
      },
      child: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: getAllUserTotals(receivableProvider.getReceivables),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: TitleText(title: "Error loading data"));
          }

          final userData = snapshot.data ?? {};
          final users = userData.keys
              .where(
                (name) =>
                    name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

          // Sort users by outstanding amount (highest first), then total
          users.sort((a, b) {
            final aOutstanding = userData[a]!['outstanding'] as double? ?? 0.0;
            final bOutstanding = userData[b]!['outstanding'] as double? ?? 0.0;
            final aTotal = aOutstanding +
                (userData[a]!['settled'] as double? ?? 0.0);
            final bTotal = bOutstanding +
                (userData[b]!['settled'] as double? ?? 0.0);
            if (aOutstanding == 0 && bOutstanding == 0) {
              return bTotal.compareTo(aTotal);
            }
            return bOutstanding.compareTo(aOutstanding);
          });

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: [
              _summaryHeader(
                totalAmount: userData.values.fold<double>(
                  0,
                  (p, e) =>
                      p +
                      ((e['outstanding'] as double? ?? 0) +
                          (e['settled'] as double? ?? 0)),
                ),
                count: users.length,
              ),
              const SizedBox(height: 12),
              _filters(),
              const SizedBox(height: 12),
              _searchBar(),
              const SizedBox(height: 12),
              ...(() {
                final filteredUsers = users.where((userName) {
                  final outstanding =
                      userData[userName]!['outstanding'] as double? ?? 0.0;
                  final settled =
                      userData[userName]!['settled'] as double? ?? 0.0;
                  final hasSettled = settled > 0;
                  final hasOutstanding = outstanding > 0;
                  if (_filter == 'settled' && !hasSettled) return false;
                  if (_filter == 'outstanding' && !hasOutstanding) return false;
                  return true;
                }).toList();

                if (filteredUsers.isEmpty) {
                  return [
                    _filterEmptyState(),
                  ];
                }

                return filteredUsers.map((userName) {
                  final outstanding =
                      userData[userName]!['outstanding'] as double? ?? 0.0;
                final settled =
                    userData[userName]!['settled'] as double? ?? 0.0;
                final receivableIds =
                    userData[userName]!['receivableIds'] as List<String>;
                final userImagePath =
                    (userData[userName]!['userImagePath'] as String?) ?? '';
                final debtorId = userData[userName]!['userId'] as String?;
                final hasSettled = settled > 0;
                final hasOutstanding = outstanding > 0;
                if (_filter == 'settled' && !hasSettled) {
                  return const SizedBox();
                }
                if (_filter == 'outstanding' && !hasOutstanding) {
                  return const SizedBox();
                }
                final displayAmount = _filter == 'settled'
                    ? settled
                    : _filter == 'outstanding'
                        ? outstanding
                        : (hasOutstanding ? outstanding : settled);
                final forceSettled =
                    _filter == 'settled' || (!hasOutstanding && hasSettled);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: customeListTile(
                    size,
                    userName,
                    displayAmount,
                    receivableIds,
                    userImagePath,
                    settledAmount: settled,
                    debtorId: debtorId,
                    forceSettled: forceSettled,
                  ),
                );
              }).toList();
              }()),
            ],
          );
        },
      ),
    );
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
                  title: "Receivables",
                  color: Colors.white,
                  fontSize: 18,
                ),
                const SizedBox(height: 6),
                SubtitleText(
                  title: "Outstanding from $count people",
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
        hintText: "Search by name",
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

  Widget customeListTile(
    Size size,
    String userName,
    double totalAmount,
    List<String> receivableIds,
    String userImagePath, {
    double settledAmount = 0,
    String? debtorId,
    bool forceSettled = false,
  }) {
    final hasOutstanding = totalAmount > 0;
    final hasSettled = settledAmount > 0;
    final isSettledView =
        forceSettled || _filter == 'settled' || (!hasOutstanding && hasSettled);
    final statusColor = isSettledView ? Colors.green : Colors.orangeAccent;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        final receivableProvider = Provider.of<ReceivableProvider>(
          context,
          listen: false,
        );
        List<IsarReceivable> userReceivables = receivableProvider
            .getReceivables
            .where((receivable) {
              return receivableIds.contains(receivable.receivableId ?? '');
            })
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ReceivableDetailScreen(
                receivables: userReceivables,
                userName: userName,
                debtorId: debtorId,
                initialFilter: _filter,
              );
            },
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
                  ? Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?')
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(title: userName, fontSize: 16),
                  const SizedBox(height: 4),
                  SubtitleText(
                    title: "${receivableIds.length} records",
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
                    title: isSettledView ? "Settled" : "Pending",
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
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.filter_alt_off, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          TitleText(title: "No receivables for this filter"),
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
