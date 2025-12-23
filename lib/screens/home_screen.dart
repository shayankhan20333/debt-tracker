import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() {
    final receivableProvider = Provider.of<ReceivableProvider>(
      context,
      listen: false,
    );
    receivableProvider.getAllReceivables(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final receivableProvider = Provider.of<ReceivableProvider>(
      context,
      listen: true,
    );
    final DashboardStats? stats =
        _calculateStats(receivableProvider.getReceivables);

    return RefreshIndicator(
      onRefresh: () async {
        loadData();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (stats == null || stats.receivables.isEmpty)
              ? _emptyState()
              : Column(
                  key: ValueKey(stats.lastUpdated),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heroHeader(stats),
                    SizedBox(height: 16),
                    _kpiGrid(stats),
                    SizedBox(height: 16),
                    _progressSection(stats),
                    SizedBox(height: 16),
                    _recentActivitySection(stats),
                    SizedBox(height: 12),
                    SubtitleText(
                      title: "Last updated: ${stats.lastUpdated.toLocal()}",
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  DashboardStats? _calculateStats(List<IsarReceivable> receivables) {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();

    if (currentUserId == null) return null;

    final Map<String, IsarReceivable> deduped = {
      for (final r in receivables)
        if (r.receivableId != null)
          r.receivableId!: r
        else
          r.id.toString(): r
    };

    double receivablesOutstanding = 0;
    double loansOutstanding = 0;
    double settledAmount = 0;
    int settledCount = 0;
    int settledAsCreator = 0;
    int settledAsDebtor = 0;
    final Set<String> peopleOweYou = {};
    final Set<String> youOwePeople = {};
    final List<ActivityItem> recent = [];

    for (var receivable in deduped.values) {
      if (receivable.participants.isEmpty) continue;

      final creatorId = receivable.participants.first;
      final isCreator = creatorId == currentUserId;
      final createdAt = receivable.createdAt ?? DateTime.now();

      if (isCreator) {
        for (int i = 1; i < receivable.participants.length; i++) {
          final amount = i < receivable.rate.length ? receivable.rate[i] : 0.0;
          final paid = i < receivable.isPaid.length
              ? receivable.isPaid[i]
              : false;
          final received = i < receivable.isReceived.length
              ? receivable.isReceived[i]
              : false;
          final settled = paid && received;
          if (!settled && amount > 0) {
            receivablesOutstanding += amount;
            peopleOweYou.add(receivable.participants[i]);
          } else if (settled && amount > 0) {
            settledAmount += amount;
            settledCount += 1;
            settledAsCreator += 1;
          }
          recent.add(
            ActivityItem(
              title: "Debtor: ${receivable.participants[i]}",
              subtitle: "Created ${createdAt.toLocal()}",
              amount: amount,
              settled: settled,
              status: settled ? "Settled" : "Outstanding",
              debtorId: receivable.participants[i],
            ),
          );
        }
      }

      final userIndex = receivable.participants.indexOf(currentUserId);
      if (userIndex > 0) {
        final double amount = userIndex < receivable.rate.length
            ? receivable.rate[userIndex]
            : 0.0;
        final paid = userIndex < receivable.isPaid.length
            ? receivable.isPaid[userIndex]
            : false;
        final received = userIndex < receivable.isReceived.length
            ? receivable.isReceived[userIndex]
            : false;
        final settled = paid && received;
        if (!settled && amount > 0) {
          loansOutstanding += amount;
          youOwePeople.add(creatorId);
        } else if (settled && amount > 0) {
          settledAmount += amount;
          settledCount += 1;
          settledAsDebtor += 1;
        }
        recent.add(
          ActivityItem(
            title: "Lender: $creatorId",
            subtitle: "Created ${createdAt.toLocal()}",
            amount: amount,
            settled: settled,
            status: settled ? "Settled" : "Outstanding",
            lenderId: creatorId,
            debtorId: userIndex > 0 ? receivable.participants[userIndex] : null,
          ),
        );
      }
    }

    recent.sort(
      (a, b) => b.amount.compareTo(a.amount),
    );

    return DashboardStats(
      receivables: deduped.values.toList(),
      receivablesOutstanding: receivablesOutstanding,
      loansOutstanding: loansOutstanding,
      netOutstanding: receivablesOutstanding - loansOutstanding,
      peopleOweYouCount: peopleOweYou.length,
      youOwePeopleCount: youOwePeople.length,
      settledCount: settledCount,
      settledAmount: settledAmount,
      settledAsCreator: settledAsCreator,
      settledAsDebtor: settledAsDebtor,
      recentActivity: recent.take(10).toList(),
      lastUpdated: DateTime.now(),
    );
  }

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          SubtitleText(title: title, fontSize: 12),
          SizedBox(height: 4),
          TitleText(title: value, fontSize: 18, fontWeight: FontWeight.bold),
          if (subtitle != null) ...[
            SizedBox(height: 4),
            SubtitleText(title: subtitle, fontSize: 11),
          ],
        ],
      ),
    );
  }

  Widget miniStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          SizedBox(height: 6),
          SubtitleText(title: title, fontSize: 10, color: Colors.white70),
          SizedBox(height: 2),
          TitleText(
            title: value,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _activityTitle(ActivityItem item) {
    final targetId = item.lenderId ?? item.debtorId;
    if (targetId == null) {
      return TitleText(title: item.title, fontSize: 14);
    }
    final labelPrefix = item.lenderId != null ? "Lender" : "Debtor";
    return FutureBuilder<String>(
      future: _getUserName(targetId),
      builder: (context, snapshot) {
        final name = snapshot.data ?? targetId;
        return TitleText(title: "$labelPrefix: $name", fontSize: 14);
      },
    );
  }

  Future<String> _getUserName(String userId) async {
    final user = await UserService().fetchUserById(userId);
    return user?.userName ?? userId;
  }

  Widget _heroHeader(DashboardStats stats) {
    final colors = [
      Theme.of(context).colorScheme.primary.withOpacity(0.85),
      Theme.of(context).colorScheme.secondary.withOpacity(0.75),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Opacity(
              opacity: 0.15,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                title: "Dashboard",
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 4),
              SubtitleText(
                title: "Overview of your balance",
                color: Colors.white70,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.update, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      SubtitleText(
                        title:
                            "Updated ${TimeOfDay.fromDateTime(stats.lastUpdated).format(context)}",
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kpiGrid(DashboardStats stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;
        final items = [
          _KpiData(
            label: "Receivables",
            value: stats.receivablesOutstanding,
            hint: "From ${stats.peopleOweYouCount} people",
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          _KpiData(
            label: "Loans",
            value: stats.loansOutstanding,
            hint: "To ${stats.youOwePeopleCount} people",
            icon: Icons.trending_down,
            color: Colors.red,
          ),
          _KpiData(
            label: "Net Balance",
            value: stats.netOutstanding,
            hint: stats.netOutstanding >= 0 ? "You are ahead" : "You owe more",
            icon: stats.netOutstanding >= 0
                ? Icons.account_balance_wallet
                : Icons.warning,
            color: stats.netOutstanding >= 0 ? Colors.blue : Colors.orange,
          ),
          _KpiData(
            label: "Settled",
            value: stats.settledAmount,
            hint: "${stats.settledCount} items",
            icon: Icons.check_circle,
            color: Colors.teal,
          ),
        ];

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isNarrow ? 1 : 2,
            mainAxisExtent: 110,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _AnimatedStatCard(data: item);
          },
        );
      },
    );
  }

  Widget _progressSection(DashboardStats stats) {
    final receivableTotal =
        stats.settledAmount + stats.receivablesOutstanding;
    final loanTotal = stats.settledAmount + stats.loansOutstanding;
    final receivableRatio = receivableTotal == 0
        ? 0.0
        : (stats.settledAmount / receivableTotal).clamp(0.0, 1.0);
    final loanRatio = loanTotal == 0
        ? 0.0
        : (stats.settledAmount / loanTotal).clamp(0.0, 1.0);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Progress", fontSize: 18),
            const SizedBox(height: 12),
            _progressRow(
              label: "Receivables collected",
              ratio: receivableRatio,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            _progressRow(
              label: "Loans repaid",
              ratio: loanRatio,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressRow({
    required String label,
    required double ratio,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubtitleText(title: label, fontSize: 12, color: Colors.white70),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _recentActivitySection(DashboardStats stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(title: "Recent Activity", fontSize: 18),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.recentActivity.length.clamp(0, 10),
            separatorBuilder: (_, __) => const Divider(
              color: Color.fromARGB(60, 255, 255, 255),
              height: 12,
            ),
            itemBuilder: (context, index) {
              final item = stats.recentActivity[index];
              final statusColor =
                  item.settled ? Colors.green : Colors.orangeAccent;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  child: Text(
                    (item.title.isNotEmpty ? item.title[0] : '?')
                        .toUpperCase(),
                  ),
                ),
                title: _activityTitle(item),
                subtitle: SubtitleText(
                  title: item.subtitle,
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleText(
                      title: "Rs ${item.amount.toStringAsFixed(0)}",
                      fontSize: 14,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.5)),
                      ),
                      child: SubtitleText(
                        title: item.status,
                        fontSize: 11,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.assessment_outlined, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 12),
            TitleText(title: "No data yet", fontSize: 20),
            const SizedBox(height: 8),
            SubtitleText(
              title: "Add a receivable or refresh to get started.",
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/RecievableFormScreen',
                    );
                  },
                  child: const Text("Add Receivable"),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: loadData,
                  child: const Text("Refresh"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardStats {
  final List<IsarReceivable> receivables;
  final double receivablesOutstanding;
  final double loansOutstanding;
  final double netOutstanding;
  final int peopleOweYouCount;
  final int youOwePeopleCount;
  final int settledCount;
  final double settledAmount;
  final int settledAsCreator;
  final int settledAsDebtor;
  final List<ActivityItem> recentActivity;
  final DateTime lastUpdated;

  DashboardStats({
    required this.receivables,
    required this.receivablesOutstanding,
    required this.loansOutstanding,
    required this.netOutstanding,
    required this.peopleOweYouCount,
    required this.youOwePeopleCount,
    required this.settledCount,
    required this.settledAmount,
    required this.settledAsCreator,
    required this.settledAsDebtor,
    required this.recentActivity,
    required this.lastUpdated,
  });
}

class ActivityItem {
  final String title;
  final String subtitle;
  final double amount;
  final bool settled;
  final String status;
  final String? lenderId;
  final String? debtorId;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.settled,
    required this.status,
    this.lenderId,
    this.debtorId,
  });
}

class _KpiData {
  final String label;
  final double value;
  final String hint;
  final IconData icon;
  final Color color;

  _KpiData({
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
    required this.color,
  });
}

class _AnimatedStatCard extends StatefulWidget {
  final _KpiData data;

  const _AnimatedStatCard({required this.data});

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> {
  double _oldValue = 0;

  @override
  void didUpdateWidget(covariant _AnimatedStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldValue = oldWidget.data.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.data.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: widget.data.color.withOpacity(0.25)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.data.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.data.icon, color: widget.data.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleText(
                    title: widget.data.label,
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: _oldValue, end: widget.data.value),
                    duration: const Duration(milliseconds: 200),
                    builder: (context, value, _) => TitleText(
                      title: "Rs ${value.toStringAsFixed(0)}",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SubtitleText(
                    title: widget.data.hint,
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
