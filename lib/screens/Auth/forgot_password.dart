import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/constant/validator.dart';
import 'package:depth_tracker/screens/Auth/login_screen.dart';
import 'package:depth_tracker/screens/loading_manager.dart';
import 'package:depth_tracker/services/assets_manager.dart';
import 'package:depth_tracker/widgets/app_name_text.dart';
import 'package:depth_tracker/widgets/my_app_function.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  static const routeName = '/ForgotPassword';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _emailController;

  late GlobalKey<FormState> _formkey;

  bool isLoading = false;

  late FirebaseAuthService firebaseUser;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();

    _formkey = GlobalKey<FormState>();

    firebaseUser = FirebaseAuthService();
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  Future<void> _resetFunction() async {
    late bool isvalid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isvalid) {
      try {
        await firebaseUser.sendPasswordReset(_emailController.text.trim());

        Fluttertoast.showToast(
          msg: "Email has been Sended,Check your MailBox",
          timeInSecForIosWeb: 5,
        );

        setState(() {
          isLoading = false;
        });

        if (!mounted) return;
        await Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routeName,
          (route) {
            return false;
          },
        );
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        MyAppFunction.showErrorAndAlertDialog(
          context: context,
          description: error.code.toString(),
          fucntionBtnName: "cancel",
          function: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } catch (error) {
        if (!mounted) return;
        MyAppFunction.showErrorAndAlertDialog(
          context: context,
          description: error.toString(),
          fucntionBtnName: "cancel",
          function: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: AppNameText(title: "Debt Tracker"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Image.asset(
                AssetsManager.forgotPassword,
                height: size.height * 0.4,
                width: size.width,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    TitleText(
                      title: "Forgot Password",
                      fontWeight: FontWeight.bold,
                    ),
                    SubtitleText(title: 'Please enter your email address'),
                    SizedBox(height: 10),
                    Form(
                      key: _formkey,
                      child: Column(
                        spacing: 20,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Your@gmail.com",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onFieldSubmitted: (value) async {
                              setState(() {
                                isLoading = true;
                              });
                              await _resetFunction();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            validator: (value) {
                              return MyValidators.emailValidator(value);
                            },
                          ),
                          ElevatedButton.icon(
                            icon: Icon(IconlyBold.send),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await _resetFunction();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                            label: TitleText(title: "Request link"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
