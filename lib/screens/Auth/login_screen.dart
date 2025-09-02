import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/constant/validator.dart';
import 'package:depth_tracker/model/user_model.dart';
import 'package:depth_tracker/root_screen.dart';
import 'package:depth_tracker/screens/Auth/forgot_password.dart';
import 'package:depth_tracker/screens/Auth/register_screen.dart';
import 'package:depth_tracker/screens/loading_manager.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/app_name_text.dart';
import 'package:depth_tracker/widgets/my_app_function.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> _formkey;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  late FocusNode passwordNode;

  bool _obscurePassword = false;

  bool isLoading = false;

  late FirebaseAuthService firebaseUser;
  late UserService userService;

  late FirebaseAuth _auth;

  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    passwordNode = FocusNode();

    firebaseUser = FirebaseAuthService();
    userService = UserService();

    _auth = FirebaseAuth.instance;

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _formkey.currentState?.dispose();

    passwordNode.dispose();

    super.dispose();
  }

  Future<void> login() async {
    late bool isvalid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isvalid) {
      try {
        setState(() {
          isLoading = true;
        });

        //login the user with firebase email and password
        final userId = await firebaseUser.signInWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        //fetch the user data and save it in local database
        if (userId != null) {
          final userData = await userService.fetchUserById(userId);
          userService.createUser(userData!);
        }

        await Fluttertoast.showToast(msg: "Login Successful");
        GoogleSignIn().signOut();
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        await Navigator.pushNamedAndRemoveUntil(
          context,
          RootScreen.routeName,
          (route) => false,
        );
      } catch (error) {
        if (!mounted) return;
        await MyAppFunction.showErrorAndAlertDialog(
          context: context,
          description: "Account not found",
          fucntionBtnName: 'OK',
          function: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      }
    }
  }

  Future<void> _googleSignIn() async {
    try {
      final userInfo = await firebaseUser.signInWithGoogle();

      if (userInfo == "Login cancelled") {
        Fluttertoast.showToast(msg: userInfo);
      } else if (userInfo == "Google sign-in failed: Missing tokens") {
        _showError(userInfo);
      } else if (userInfo == "new user") {
        final User user = _auth.currentUser!;
        userService.createUser(
          UserModel(
            userId: user.uid,
            userName: user.displayName ?? "Unknown",
            userEmail: user.email ?? "Email Unknown",
            userContact: user.phoneNumber ?? "Contact Unknown",
            userImagePath: user.photoURL ?? "Unknown",
            createdAt: firestore.Timestamp.now(),
          ),
        );
      } else {
        await Fluttertoast.showToast(msg: "Login Successful");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RootScreen.routeName,
            (route) => false,
          );
        });
      }
    } on FirebaseAuthException catch (error) {
      _showError(error.message ?? "Unknown Firebase error");
    } catch (error) {
      _showError(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await MyAppFunction.showErrorAndAlertDialog(
        context: context,
        description: message,
        fucntionBtnName: 'OK',
        function: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppNameText(title: "Debt Tracker"),
        centerTitle: true,
        toolbarHeight: kToolbarHeight * 4,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                TitleText(title: "Welcome Back!", fontWeight: FontWeight.w600),
                SubtitleText(
                  title: "Let's get you logged in so you can start exploring",
                  fontSize: 16,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    spacing: 10,
                    children: [
                      TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hint: Text("Your@gmail.com"),
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(passwordNode);
                        },
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        focusNode: passwordNode,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          hint: Text(
                            _obscurePassword ? "********" : "12345678",
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          login();
                        },
                        validator: (value) {
                          return MyValidators.passwordValidator(value);
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ForgotPassword.routeName);
                    },
                    child: SubtitleText(
                      title: "Forgot Password?",
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    login();
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(double.infinity, 40),
                    ),
                    elevation: WidgetStatePropertyAll(5),
                  ),
                  child: TitleText(title: "Login"),
                ),

                Align(
                  alignment: Alignment.center,
                  child: TitleText(
                    title: "OR CONNECT USING",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await _googleSignIn();
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                            Size(double.infinity, 40),
                          ),
                          elevation: WidgetStatePropertyAll(1),
                        ),
                        icon: Icon(Ionicons.logo_google, color: Colors.red),
                        label: FittedBox(
                          child: SubtitleText(title: "Sign in with Google"),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RootScreen.routeName);
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(10, 40)),
                        elevation: WidgetStatePropertyAll(1),
                      ),
                      child: SubtitleText(title: "Guest?"),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 17),
                        children: [
                          TextSpan(
                            text: 'Don\'t hava an account? ',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 119, 119, 119),
                            ),
                          ),
                          TextSpan(
                            text: 'SignUp',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
