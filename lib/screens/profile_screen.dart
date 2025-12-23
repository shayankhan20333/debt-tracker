import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/screens/Auth/login_screen.dart';
import 'package:depth_tracker/services/assets_manager.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/my_app_Bar.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? currentUser;
  bool isLoading = true;
  String? errorMessage;
  String? _lastLoadedUserId;
  bool _isFetchingProfile = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadCurrentUser(User firebaseUser) async {
    setState(() {
      _isFetchingProfile = true;
      isLoading = true;
      errorMessage = null;
    });
    try {
      final userService = UserService();
      var user = await userService.fetchUserById(firebaseUser.uid);
      user ??= await userService.ensureUserProfile(firebaseUser);

      if (!mounted) return;

      if (user == null) {
        setState(() {
          errorMessage = "Profile not found. Please try again.";
          currentUser = null;
          isLoading = false;
        });
        return;
      }

      final resolvedUser = user;
      setState(() {
        _lastLoadedUserId = firebaseUser.uid;
        currentUser = {
          'userName': resolvedUser.userName.isNotEmpty
              ? resolvedUser.userName
              : 'Unknown User',
          'userEmail': resolvedUser.userEmail.isNotEmpty
              ? resolvedUser.userEmail
              : 'No Email',
          'userContact': resolvedUser.userContact.isNotEmpty
              ? resolvedUser.userContact
              : 'No Contact',
          'userImagePath': resolvedUser.userImagePath,
        };
        isLoading = false;
        _isFetchingProfile = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Failed to load profile. Please try again.";
        isLoading = false;
        _isFetchingProfile = false;
        currentUser = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Profile", hasTitleInCenter: true),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final authUser = snapshot.data;
          if (authUser == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleText(title: "Please sign in to view your profile."),
                    const SizedBox(height: 8),
                    SubtitleText(
                      title: "No authenticated user found.",
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            );
          }

          if (_lastLoadedUserId != authUser.uid && !_isFetchingProfile) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              loadCurrentUser(authUser);
            });
          }

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleText(title: "Profile unavailable"),
                    SizedBox(height: 8),
                    SubtitleText(
                      title: errorMessage ?? 'Something went wrong',
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => loadCurrentUser(authUser),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _profileHeader(),
                const SizedBox(height: 16),
                _accountSection(),
                const SizedBox(height: 16),
                _settingsSection(),
                const SizedBox(height: 16),
                _aboutSection(),
                const SizedBox(height: 20),
                _logoutButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _profileHeader() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.9),
            theme.colorScheme.secondary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: currentUser?['userImagePath']?.isNotEmpty == true
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
              ),
              const SizedBox(height: 12),
              TitleText(
                title: currentUser?['userName'] ?? 'Unknown User',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              SubtitleText(
                title: currentUser?['userEmail'] ?? 'No Email',
                color: Colors.white70,
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified_user, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    SubtitleText(
                      title: "Signed in",
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accountSection() {
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
          TitleText(title: "Account", fontSize: 18),
          const SizedBox(height: 12),
          _infoTile(
            icon: Icons.email_outlined,
            label: "Email",
            value: currentUser?['userEmail'] ?? 'No Email',
          ),
          _infoTile(
            icon: Icons.phone_outlined,
            label: "Contact",
            value: currentUser?['userContact'] ?? 'Not set',
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleText(
                  title: label,
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                const SizedBox(height: 4),
                TitleText(title: value, fontSize: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsSection() {
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
          TitleText(title: "Data & Preferences", fontSize: 18),
          const SizedBox(height: 10),
          _actionTile(
            icon: Icons.refresh,
            label: "Refresh data",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Data refresh coming soon")),
              );
            },
          ),
          _actionTile(
            icon: Icons.cleaning_services_outlined,
            label: "Clear local cache",
            onTap: () async {
              await UserService().clearLocalCache();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Local cache cleared")),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
      title: TitleText(title: label, fontSize: 15),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[500]),
      onTap: onTap,
    );
  }

  Widget _aboutSection() {
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
          TitleText(title: "About", fontSize: 18),
          const SizedBox(height: 10),
          _infoTile(
            icon: Icons.apps,
            label: "App",
            value: "Debt Tracker",
          ),
          _infoTile(
            icon: Icons.info_outline,
            label: "Version",
            value: "1.0.0",
          ),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: TitleText(title: "Logout"),
              content: const SubtitleText(
                title: "Are you sure you want to logout?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
          if (confirmed != true) return;
          final authService = FirebaseAuthService();
          await UserService().clearLocalCache();
          await authService.signOut();
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
