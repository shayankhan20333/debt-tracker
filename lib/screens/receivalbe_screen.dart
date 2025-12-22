import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/screens/inner%20screens/receivable_detail_screen.dart';
import 'package:depth_tracker/screens/form/recievable_form_screen.dart';
import 'package:depth_tracker/services/assets_manager.dart';
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

        // Only process if user has an amount in this receivable
        if (amount > 0 && !settled) {
          if (userData.containsKey(userName)) {
            userData[userName]!['totalAmount'] += amount;
            (userData[userName]!['receivableIds'] as List<String>).add(
              receivable.receivableId ?? '',
            );
          } else {
            userData[userName] = {
              'totalAmount': amount,
              'receivableIds': [receivable.receivableId ?? ''],
              'userImagePath': user?.userImagePath,
            };
          }
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
          final users = userData.keys.toList();

          if (receivableProvider.getReceivables.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(title: "No Receivables Available"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RecievableFormScreen.roatName,
                    );
                  },
                  child: const Text("Add Receivable"),
                ),
              ],
            );
          }

          if (users.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(title: "No Receivables Available"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RecievableFormScreen.roatName,
                    );
                  },
                  child: const Text("Add Receivable"),
                ),
              ],
            );
          }

          // Sort users by total amount (highest first)
          users.sort((a, b) {
            final aAmount = userData[a]!['totalAmount'] as double;
            final bAmount = userData[b]!['totalAmount'] as double;
            return bAmount.compareTo(aAmount); // Higher amounts first
          });

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userName = users[index];
              final totalAmount = userData[userName]!['totalAmount'];
              final receivableIds =
                  userData[userName]!['receivableIds'] as List<String>;
              final userImagePath =
                  (userData[userName]!['userImagePath'] as String?) ?? '';
              return customeListTile(
                size,
                userName,
                totalAmount,
                receivableIds,
                userImagePath,
              );
            },
          );
        },
      ),
    );
  }

  Widget customeListTile(
    Size size,
    String userName,
    double totalAmount,
    List<String> receivableIds,
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
                );
              },
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
                    fit: BoxFit.fitWidth,
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
        title: TitleText(title: userName),
        subtitle: SubtitleText(title: "Rs: $totalAmount"),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
