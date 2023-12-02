import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todoa/constants/app_text_styles.dart';
import 'package:todoa/providers/auth_provider.dart';
import 'package:todoa/screens/home_screen.dart';
import 'package:todoa/screens/login_screen.dart';
import 'package:todoa/utils/utils.dart';
import 'package:todoa/widgets/custom_text_field.dart';
import 'package:todoa/widgets/sized_box_ex.dart';
import '../constants/colors.dart';
import '../widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();

  final usernameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final bioFocusNode = FocusNode();

  XFile? pImage;
  Uint8List? _image;

  void selectImage(ImageSource source) async {
    Uint8List? img = await pickImage(source);
    setState(() {
      _image = img;
    });
  }

  void signUp() async {
    AuthProvider authP = Provider.of<AuthProvider>(context, listen: false);

    if (_image == null) {
      authP.setLoading(true);
      // ignore: use_build_context_synchronously
      Utils.showFlushBar(context, "Please Pick an Image!",
          const Icon(Icons.error, color: AppColors.whiteColor), Colors.red);
      authP.setLoading(false);
    }

    String resul = await authP.signUpUser(
      username: usernameController.text,
      bio: bioController.text,
      email: emailController.text,
      password: passwordController.text,
      file: _image!,
      createdAt: DateTime.now(),
    );
    if (kDebugMode) {
      print(resul);
    }

    if (resul != "success") {
      // ignore: use_build_context_synchronously
      Utils.showFlushBar(context, resul,
          const Icon(Icons.error, color: AppColors.whiteColor), Colors.red);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(PageTransition(
          child: const HomeScreen(), type: PageTransitionType.rightToLeft));
      // // ignore: use_build_context_synchronously
      // Utils.showFlushBar(
      //     context,
      //     "Account created successfully.",
      //     const Icon(Icons.check, color: AppColors.whiteColor),
      //     AppColors.blueBlack);
      //
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    usernameFocusNode.dispose();
    bioFocusNode.dispose();
    super.dispose();
  }

  pickImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: imageSource);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      // ignore: use_build_context_synchronously
      Utils.showFlushBar(
          context,
          "No Image selected!",
          const Icon(
            Icons.error_rounded,
            color: AppColors.whiteColor,
          ),
          AppColors.redColor);
      if (kDebugMode) {
        print("No Image Selected!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.darkPrimaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    // onTap: uploadImageAndSaveToFirestore,
                    onTap: () {
                      showPickImageOptionsDialog(context);
                    },
                    child: SizedBox(
                      height: 110,
                      width: 110,
                      child: Stack(
                        children: [
                          _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.memory(
                                    _image!,
                                    fit: BoxFit.cover,
                                    height: 110,
                                    width: 110,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.asset(
                                    "assets/images/Todoa-App.jpg",
                                    fit: BoxFit.cover,
                                    height: 110,
                                    width: 110,
                                  ),
                                ),
                          Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _image != null
                                  ? Colors.transparent
                                  : Colors.black87.withOpacity(0.23),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              10.ph,
                              Opacity(
                                  opacity: _image != null ? 0 : 1,
                                  child: const Center(
                                      child: Icon(
                                    Icons.add_a_photo_rounded,
                                    color: AppColors.whiteColor,
                                  ))),
                              10.ph,
                              Opacity(
                                opacity: _image != null ? 0 : 1,
                                child: Center(
                                  child: Text(
                                    "Upload\nPhoto",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.sgBoldStyle.copyWith(
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                20.ph,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Card(
                    elevation: 15,
                    shadowColor: AppColors.darkPrimaryColor,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.offWhite,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "ToDoa",
                            style: AppTextStyles.sgBoldStyle.copyWith(
                                fontSize: 30, color: AppColors.blueBlack),
                          ),
                          15.ph,
                          CustomTextField(
                            controller: usernameController,
                            focusNode: usernameFocusNode,
                            hint: "Enter username",
                            isObscure: false,
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(emailFocusNode);
                              // emailFocusNode.requestFocus(passwordFocusNode);
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          13.ph,
                          CustomTextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            hint: "Enter email address",
                            isObscure: false,
                            onSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(passwordFocusNode);
                              // emailFocusNode.requestFocus(passwordFocusNode);
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          13.ph,

                          Consumer<AuthProvider>(
                            builder: (context, value, child) {
                              return CustomTextField(
                                controller: passwordController,
                                focusNode: passwordFocusNode,
                                hint: "Enter Password",
                                isObscure: value.isObscure,
                                trail: IconButton(
                                  onPressed: () {
                                    value.setObscure();
                                  },
                                  icon: Icon(
                                    value.isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off_rounded,
                                    color: AppColors.blueBlack.withOpacity(0.8),
                                  ),
                                ),
                                // Icon(Icons.visibility_off_rounded, color: AppColors.blueBlack,)),
                                onSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(bioFocusNode);
                                },
                                keyboardType: TextInputType.text,
                              );
                            },
                          ),
                          13.ph,
                          CustomTextField(
                            controller: bioController,
                            focusNode: bioFocusNode,
                            hint: "About you (Worker etc...)",
                            isObscure: false,
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                              // Provider.of<LoginProvider>(context, listen: false).signUp(context, _image!);
                              // emailFocusNode.requestFocus(passwordFocusNode);
                            },
                            keyboardType: TextInputType.text,
                          ),

                          30.ph,
                          // Button for Signing up the user
                          Consumer<AuthProvider>(
                            builder: (context, provider, child) {
                              return RoundButton(
                                loading: provider.isLoading,
                                onTapped: () {
                                  signUp();
                                },
                                wChild: Text(
                                  "Sign up",
                                  style: AppTextStyles.sgBoldStyle.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 20),
                                ),
                              );
                            },
                          ),
                          // Some more stuff!
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: AppTextStyles.sgRegStyle.copyWith(
                                  color: AppColors.blueBlack,
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: const LoginScreen(),
                                          type:
                                              PageTransitionType.leftToRight));
                                },
                                child: Text(
                                  "Login",
                                  style: AppTextStyles.sgBoldStyle.copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          )
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

  showPickImageOptionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            surfaceTintColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.whiteColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            title: Text(
              "Pick from",
              style: AppTextStyles.sgBoldStyle
                  .copyWith(color: AppColors.blueBlack),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 0,
                  color: AppColors.ddOffWhite.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      "Camera",
                      style: AppTextStyles.sgRegStyle.copyWith(
                          color: AppColors.blueBlack.withOpacity(0.85)),
                    ),
                    leading: Icon(
                      CupertinoIcons.camera_fill,
                      color: AppColors.blueBlack.withOpacity(0.85),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      selectImage(ImageSource.camera);
                    },
                  ),
                ),
                Card(
                  elevation: 0,
                  color: AppColors.ddOffWhite.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      "Gallery",
                      style: AppTextStyles.sgRegStyle.copyWith(
                          color: AppColors.blueBlack.withOpacity(0.85)),
                    ),
                    leading: Icon(
                      CupertinoIcons.photo_fill,
                      color: AppColors.blueBlack.withOpacity(0.85),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      selectImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
