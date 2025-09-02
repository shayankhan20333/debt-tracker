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

          if (lenders.isEmpty) {
            return Center(child: TitleText(title: "No Loans Available"));
          }

          // Sort lenders by total amount (highest first)
          lenders.sort((a, b) {
            final aAmount = lenderData[a]!['totalAmount'] as double;
            final bAmount = lenderData[b]!['totalAmount'] as double;
            return bAmount.compareTo(aAmount);
          });

          return ListView.builder(
            itemCount: lenders.length,
            itemBuilder: (context, index) {
              final lenderName = lenders[index];
              final totalAmount = lenderData[lenderName]!['totalAmount'];
              final loans =
                  lenderData[lenderName]!['loans']
                      as List<Map<String, dynamic>>;
              final userImagePath =
                  lenderData[lenderName]!['userImagePath'] as String;
              return customListTile(
                size,
                lenderName,
                totalAmount,
                loans,
                userImagePath,
              );
            },
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

        // Check if current user is in participants (but not the first one - creator)
        bool isCurrentUserParticipant = false;
        int currentUserIndex = -1;

        for (int i = 0; i < receivable.participants.length; i++) {
          if (receivable.participants[i] == currentUserId) {
            isCurrentUserParticipant = true;
            currentUserIndex = i;
            break;
          }
        }

        // If current user is not a participant, skip
        if (!isCurrentUserParticipant) continue;

        // If current user is the first participant (creator), skip - they don't owe money to themselves
        if (currentUserIndex == 0) {
          continue;
        }

        // Current user owes money - find who they owe to (the creator - first participant)
        final creatorId = receivable.participants[0];
        final creatorUser = await userService.fetchUserById(creatorId);
        final creatorName = creatorUser?.userName ?? 'Unknown';

        // Get the amount current user owes
        final amountOwed = currentUserIndex < receivable.rate.length
            ? receivable.rate[currentUserIndex]
            : 0.0;

        if (amountOwed > 0) {
          if (lenderData.containsKey(creatorName)) {
            lenderData[creatorName]!['totalAmount'] =
                (lenderData[creatorName]!['totalAmount'] as double) +
                amountOwed;
            (lenderData[creatorName]!['loans'] as List<Map<String, dynamic>>)
                .add(<String, dynamic>{
                  'receivableId': receivable.receivableId,
                  'description': receivable.description,
                  'amount': amountOwed,
                  'method': receivable.method,
                  'createdAt': receivable.createdAt,
                  'isPaid': currentUserIndex < receivable.isPaid.length
                      ? receivable.isPaid[currentUserIndex]
                      : false,
                });
          } else {
            lenderData[creatorName] = <String, dynamic>{
              'totalAmount': amountOwed,
              'userImagePath': creatorUser?.userImagePath,
              'loans': <Map<String, dynamic>>[
                <String, dynamic>{
                  'receivableId': receivable.receivableId,
                  'description': receivable.description,
                  'amount': amountOwed,
                  'method': receivable.method,
                  'createdAt': receivable.createdAt,
                  'isPaid': currentUserIndex < receivable.isPaid.length
                      ? receivable.isPaid[currentUserIndex]
                      : false,
                },
              ],
            };
          }
        }
      }

      return lenderData;
    } catch (e) {
      return {};
    }
  }

  Widget customListTile(
    Size size,
    String lenderName,
    double totalAmount,
    List<Map<String, dynamic>> loans,
    String userImagePath,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(82, 71, 71, 71),
        border: Border.all(width: 0.5, color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoanDetailScreen(loans: loans, lenderName: lenderName),
            ),
          );
        },
        leading: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: userImagePath.isNotEmpty
                ? Image.network(
                    userImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AssetsManager.emptySearch,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(AssetsManager.emptySearch, fit: BoxFit.cover),
          ),
        ),
        title: TitleText(title: lenderName),
        subtitle: SubtitleText(title: "Rs: ${totalAmount.roundToDouble()}"),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
