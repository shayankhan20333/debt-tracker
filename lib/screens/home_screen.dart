import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
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

    return RefreshIndicator(
      onRefresh: () async {
        loadData();
      },
      child: FutureBuilder<Map<String, dynamic>>(
        future: calculateStats(receivableProvider.getReceivables),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: TitleText(title: "Error loading data"));
          }

          final stats = snapshot.data ?? {};

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(title: "Financial Overview", fontSize: 24),
                SizedBox(height: 20),

                // Main Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: statCard(
                        "Total Receivables",
                        "Rs ${stats['totalReceivables'] ?? 0}",
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: statCard(
                        "Total Loans",
                        "Rs ${stats['totalLoans'] ?? 0}",
                        Icons.trending_down,
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Net Balance
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: (stats['netBalance'] ?? 0) >= 0
                          ? [Colors.blue[800]!, Colors.blue[900]!]
                          : [Colors.red[400]!, Colors.red[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        (stats['netBalance'] ?? 0) >= 0
                            ? Icons.account_balance_wallet
                            : Icons.warning,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      TitleText(
                        title: "Net Balance",
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      SizedBox(height: 4),
                      TitleText(
                        title:
                            "Rs ${stats['netBalance'] == null ? 0.0 : (stats['netBalance'] as double).roundToDouble() ?? 0.0}",
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 4),
                      SubtitleText(
                        title: (stats['netBalance'] ?? 0) >= 0
                            ? "You're in profit!"
                            : "You owe money",
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Additional Stats
                TitleText(title: "Statistics", fontSize: 20),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: miniStatCard(
                        "People Owe You",
                        "${stats['peopleOweYou'] ?? 0}",
                        Icons.people,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: miniStatCard(
                        "You Owe People",
                        "${stats['youOwePeople'] ?? 0}",
                        Icons.person,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> calculateStats(
    List<IsarReceivable> receivables,
  ) async {
    final authService = FirebaseAuthService();
    final currentUserId = authService.getCurrentUserId();

    if (currentUserId == null) return {};

    double totalReceivables = 0;
    double totalLoans = 0;
    Set<String> peopleOweYou = {};
    Set<String> youOwePeople = {};

    for (var receivable in receivables) {
      if (receivable.participants.isEmpty) continue;

      // Check if current user is creator (receivable)
      if (receivable.participants[0] == currentUserId) {
        for (int i = 1; i < receivable.participants.length; i++) {
          final amount = i < receivable.rate.length ? receivable.rate[i] : 0.0;
          totalReceivables += amount;
          if (amount > 0) {
            peopleOweYou.add(receivable.participants[i]);
          }
        }
      }

      // Check if current user is participant (loan)
      for (int i = 1; i < receivable.participants.length; i++) {
        if (receivable.participants[i] == currentUserId) {
          final amount = i < receivable.rate.length ? receivable.rate[i] : 0.0;
          totalLoans += amount;
          if (amount > 0) {
            youOwePeople.add(receivable.participants[0]);
          }
          break;
        }
      }
    }

    return {
      'totalReceivables': totalReceivables,
      'totalLoans': totalLoans,
      'netBalance': totalReceivables - totalLoans,
      'peopleOweYou': peopleOweYou.length,
      'youOwePeople': youOwePeople.length,
    };
  }

  Widget statCard(String title, String value, IconData icon, Color color) {
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
}
