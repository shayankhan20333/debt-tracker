import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/screens/Auth/login_screen.dart';
import 'package:depth_tracker/services/assets_manager.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/my_app_Bar.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    try {
      final authService = FirebaseAuthService();
      final userService = UserService();
      final currentUserId = authService.getCurrentUserId();

      if (currentUserId != null) {
        final user = await userService.fetchUserById(currentUserId);
        setState(() {
          currentUser = {
            'userName': user?.userName ?? 'Unknown User',
            'userEmail': user?.userEmail ?? 'No Email',
            'userContact': user?.userContact ?? 'No Contact',
            'userImagePath': user?.userImagePath ?? '',
          };
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(title: "Profile", hasTitleDecoration: true),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[800]!, Colors.blue[900]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Profile Picture
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child:
                                currentUser?['userImagePath']?.isNotEmpty ==
                                    true
                                ? Image.network(
                                    currentUser!['userImagePath'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        AssetsManager.emptySearch,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    AssetsManager.emptySearch,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // User Name
                        TitleText(
                          title: currentUser?['userName'] ?? 'Unknown User',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),

                        // User Email
                        SubtitleText(
                          title: currentUser?['userEmail'] ?? 'No Email',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  profileOption(
                    icon: IconlyBroken.call,
                    title: "Contact",
                    subtitle: currentUser?['userContact'] ?? 'No Contact',
                    onTap: () {
                      // Navigate to edit contact
                    },
                  ),

                  profileOption(
                    icon: IconlyBroken.setting,
                    title: "Settings",
                    subtitle: "App preferences",
                    onTap: () {
                      // Navigate to settings
                    },
                  ),

                  profileOption(
                    icon: IconlyBroken.infoSquare,
                    title: "About",
                    subtitle: "App information",
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "Debt Tracker",
                        applicationVersion: "1.0.0",
                        applicationIcon: Icon(Icons.account_balance_wallet),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: TitleText(title: "Logout"),
                            content: SubtitleText(
                              title: "Are you sure you want to logout?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final authService = FirebaseAuthService();
                                  await authService.signOut();
                                  if (!mounted) return;
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    LoginScreen.routeName,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconlyBroken.logout),
                          SizedBox(width: 8),
                          TitleText(
                            title: "Logout",
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget profileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: TitleText(
          title: title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitle: SubtitleText(
          title: subtitle,
          fontSize: 14,
          color: Colors.grey[400],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
      ),
    );
  }
}
