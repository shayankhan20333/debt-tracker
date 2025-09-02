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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([UserService().initlizeDataBase()]),
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
        final auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;

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
          child: Consumer(
            builder: (context, value, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Qaraz Tracker",
                theme: ThemeStyle.themeData(context: context),
                home: Scaffold(
                  body: user == null ? LoginScreen() : RootScreen(),
                ),
                routes: {
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  ForgotPassword.routeName: (context) => const ForgotPassword(),
                  RootScreen.routeName: (context) => const RootScreen(),
                  RecievableFormScreen.roatName: (context) =>
                      const RecievableFormScreen(),
                  ProfileScreen.routeName: (context) => const ProfileScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
