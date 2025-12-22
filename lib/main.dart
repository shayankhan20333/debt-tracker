import 'package:depth_tracker/constant/theme_style.dart';
import 'package:depth_tracker/providers/loan_provider.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/providers/user_provider.dart';
import 'package:depth_tracker/root_screen.dart';
import 'package:depth_tracker/screens/Auth/forgot_password.dart';
import 'package:depth_tracker/screens/Auth/login_screen.dart';
import 'package:depth_tracker/screens/Auth/register_screen.dart';
import 'package:depth_tracker/screens/form/recievable_form_screen.dart';
import 'package:depth_tracker/screens/profile_screen.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// nano file
// command
// nano ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android/build.gradle
// changes
// compileSdkVersion 36
//     namespace "dev.isar.isar_flutter_libs"

// command
// nano ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android/src/main/AndroidManifest.xml

// <manifest xmlns:android="http://schemas.android.com/apk/res/android"
//     package="dev.isar.isar_flutter_libs">
// remove this line
// package="dev.isar.isar_flutter_libs"

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) : _initFuture = UserService().initlizeDataBase();

  final Future<void> _initFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        } else if (asyncSnapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SelectableText(asyncSnapshot.error.toString()),
                ),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) {
                return UserProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return ReceivableProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return LoanProvider();
              },
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Qaraz Tracker",
            theme: ThemeStyle.themeData(context: context),
            home: const _AuthGate(),
            routes: {
              LoginScreen.routeName: (context) => const LoginScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              ForgotPassword.routeName: (context) => const ForgotPassword(),
              RootScreen.routeName: (context) => const RootScreen(),
              RecievableFormScreen.roatName: (context) =>
                  const RecievableFormScreen(),
              ProfileScreen.routeName: (context) => const ProfileScreen(),
            },
          ),
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  Future<void> _ensureProfile(User firebaseUser) async {
    await UserService().ensureUserProfile(firebaseUser);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder(
          future: _ensureProfile(user),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (profileSnapshot.hasError) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SelectableText(profileSnapshot.error.toString()),
                  ),
                ),
              );
            }
            return const RootScreen();
          },
        );
      },
    );
  }
}
