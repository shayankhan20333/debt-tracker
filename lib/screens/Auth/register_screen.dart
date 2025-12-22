import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/constant/validator.dart';
import 'package:depth_tracker/model/user_model.dart';
import 'package:depth_tracker/root_screen.dart';
import 'package:depth_tracker/screens/loading_manager.dart';
import 'package:depth_tracker/services/user_services.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:shimmer/shimmer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String routeName = '/RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordRepeatController;

  late FocusNode _emailFocusNode;
  late FocusNode _contactFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _passwordRepeatFocusNode;

  late GlobalKey<FormState> _formkey;

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already in use. Try logging in.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'weak-password':
        return 'Password must be at least 8 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Sign up failed. Please try again.';
    }
  }

  bool _obscurePasswordFirst = false;
  bool _obscurePasswordSecond = false;

  XFile? _imagePicked;

  bool isLoading = false;

  late FirebaseAuth auth;

  String? imageURL;

  late UserService userService;
  late FirebaseAuthService firebaseAuthUser;

  @override
  void initState() {
    super.initState();

    auth = FirebaseAuth.instance;

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordRepeatController = TextEditingController();

    _emailFocusNode = FocusNode();
    _contactFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordRepeatFocusNode = FocusNode();

    _formkey = GlobalKey<FormState>();

    _obscurePasswordFirst = false;
    _obscurePasswordSecond = false;

    userService = UserService();

    firebaseAuthUser = FirebaseAuthService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();

    _emailFocusNode.dispose();
    _contactFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordRepeatFocusNode.dispose();

    super.dispose();
  }

  Future<void> _loginFunction() async {
    if (isLoading) return;
    final bool isvalid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_imagePicked == null) {
      _showSnack("Please upload a picture", isError: true);
      return;
    }

    if (isvalid) {
      try {
        setState(() {
          isLoading = true;
        });

        await firebaseAuthUser.createNewUserWithEmailandPassword(
          _emailController.text,
          _passwordController.text,
        );

        timeDilation = 1;

        final User? user = auth.currentUser;
        final userID = user!.uid;

        // this is the path to the folder
        final ref = FirebaseStorage.instance
            .ref()
            .child("UserImages")
            .child("$userID.jpg");

        //from here put the image to the ref path
        await ref.putFile(File(_imagePicked!.path));

        //image url
        imageURL = await ref.getDownloadURL();

        await userService.createUser(
          UserModel(
            userId: userID,
            userName: _nameController.text,
            userEmail: _emailController.text.toLowerCase(),
            userContact: _contactController.text,
            userImagePath: imageURL!,
            createdAt: firestore.Timestamp.now(),
          ),
        );

        await Fluttertoast.showToast(
          msg: "Account has been created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RootScreen.routeName,
          (route) => false,
        );
      } on FirebaseAuthException catch (error) {
        _showSnack(_mapAuthError(error.code), isError: true);
      } on FirebaseException catch (error) {
        _showSnack(error.message.toString(), isError: true);
      } on IsarError catch (error) {
        _showSnack(error.message.toString(), isError: true);
      } catch (error) {
        _showSnack(error.toString(), isError: true);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await showImagePickerDialog(
      context,
      () async {
        _imagePicked = await imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 20,
        );
        setState(() {});
      },
      () async {
        _imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      () {
        setState(() {
          _imagePicked = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.15,
          title: Shimmer.fromColors(
            period: Duration(seconds: 12),
            baseColor: Colors.purple,
            highlightColor: Colors.red,
            child: TitleText(
              title: "Debt Tracker",
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: LoadingManager(
          isLoading: isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 40,
                right: 20,
                left: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(title: "Welcome", fontWeight: FontWeight.bold),
                  SubtitleText(
                    title: "Sign up and Track who got your money",
                    fontSize: 16,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: size.width * 0.4,
                          height: size.height * 0.2,
                          child: imageContainer(_imagePicked, () async {
                            await localImagePicker();
                          }),
                        ),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hint: Text("John"),
                            prefixIcon: Icon(IconlyLight.profile),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_contactFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                        ),
                        TextFormField(
                          controller: _contactController,
                          textInputAction: TextInputAction.next,
                          focusNode: _contactFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "034-XXXXXXX-X",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_emailFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.contactValidator(value);
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Your@gmail.com",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePasswordFirst,
                          textInputAction: TextInputAction.next,
                          focusNode: _passwordFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hint: Text(
                              _obscurePasswordFirst ? "********" : "12345678",
                            ),
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.only(right: 10),
                              icon: Icon(
                                _obscurePasswordFirst
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePasswordFirst =
                                      !_obscurePasswordFirst;
                                });
                              },
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_passwordRepeatFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                        TextFormField(
                          controller: _passwordRepeatController,
                          obscureText: _obscurePasswordSecond,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordRepeatFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hint: Text("Repeat Password"),
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.only(right: 10),
                              icon: Icon(
                                _obscurePasswordSecond
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePasswordSecond =
                                      !_obscurePasswordSecond;
                                });
                              },
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await _loginFunction();
                          },
                          validator: (value) {
                            return MyValidators.repeatPasswordValidator(
                              value: value,
                              password: _passwordController.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    onPressed: isLoading
                        ? null
                        : () async {
                            await _loginFunction();
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    label: TitleText(title: "Singup"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageContainer(XFile? imagePath, Function function) {
    return Stack(
      children: [
        imagePath == null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 70, 70, 70),
                    ),
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
                  child: Image.file(File(imagePath.path), fit: BoxFit.fill),
                ),
              ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
            ),
            child: IconButton(
              onPressed: () {
                function();
              },
              icon: Icon(IconlyLight.plus, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> showImagePickerDialog(
    BuildContext context,
    Function cameraFunction,
    Function galleryFunction,
    Function removeFucntion,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: SubtitleText(title: "Choose option"),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                TextButton.icon(
                  iconAlignment: IconAlignment.start,
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(double.infinity, 10),
                    ),
                  ),
                  onPressed: () {
                    cameraFunction();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.camera, color: Colors.black),
                  label: SubtitleText(title: "Camera", color: Colors.black),
                ),
                TextButton.icon(
                  iconAlignment: IconAlignment.start,
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(double.infinity, 10),
                    ),
                  ),
                  onPressed: () {
                    galleryFunction();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.browse_gallery, color: Colors.black),
                  label: SubtitleText(title: "Gallery", color: Colors.black),
                ),
                TextButton.icon(
                  iconAlignment: IconAlignment.start,
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(double.infinity, 10),
                    ),
                  ),
                  onPressed: () {
                    removeFucntion();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.remove, color: Colors.black),
                  label: SubtitleText(title: "Remove", color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
