import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todoa/constants/app_text_styles.dart';
import 'package:todoa/providers/auth_provider.dart';
import 'package:todoa/screens/home_screen.dart';
import 'package:todoa/screens/sign_up_screen.dart';
import 'package:todoa/widgets/custom_text_field.dart';
import 'package:todoa/widgets/round_button.dart';
import 'package:todoa/widgets/sized_box_ex.dart';

import '../constants/colors.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  AuthProvider authMethods = AuthProvider();

  void loginUser() async {

    final prov = Provider.of<AuthProvider>(context, listen: false);
    // prov.setLoading(true);
    String result = await prov.loginUser(email: emailController.text, password: passwordController.text,);
      // prov.setLoading(false);
    if (result == 'success'){
      // prov.setLoading(false);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, PageTransition(child: const HomeScreen(), type: PageTransitionType.rightToLeft),
      );
        // ignore: use_build_context_synchronously
        Utils.showFlushBar(context, "Logged in successfully.", const Icon(Icons.done_all_rounded, color: AppColors.whiteColor,), AppColors.blueBlack);

    }else{
      // prov.setLoading(false);
      // ignore: use_build_context_synchronously
      Utils.showFlushBar(context, result, const Icon(Icons.error, color: AppColors.whiteColor,),);
    }
      // prov.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
      // systemNavigationBarColor: AppColors.transparent,
    ));
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: const Image(
                height: 110,
                width: 110,
                image: AssetImage(
                  "assets/images/Todoa-App.jpg",
                ),
              ),
            ),
            30.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Card(
                elevation: 10,
                shadowColor: AppColors.darkPrimaryColor,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.offWhite,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      15.ph,
                      Text("ToDoa", style: AppTextStyles.sgBoldStyle.copyWith(
                        fontSize: 30,
                        color: AppColors.blueBlack
                      ),),
                      20.ph,

                      // Email Text Field
                      CustomTextField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          hint: "Enter email address",
                          isObscure: false,
                        onSubmitted: (value){
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          // emailFocusNode.requestFocus(passwordFocusNode);
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      13.ph,

                      // Password Text Field
                      Consumer<AuthProvider>(
                        builder: (context, value, child) {
                          return CustomTextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            hint: "Enter Password",
                            trail: IconButton(
                              onPressed: () {
                                value.setObscure();
                              },
                              icon:
                              Icon(Icons.visibility,
                                color: AppColors.blueBlack.withOpacity(0.8),),),
                            isObscure: value.isObscure,
                            onSubmitted: (value){
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.text,
                          );
                        },
                      ),
                      30.ph,
                      // 22
                      // Button for some action

                      Consumer<AuthProvider>(
                        builder: (context, provider, child){
                          return
                            RoundButton(
                              loading: provider.isLoading,
                              onTapped: () {
                                loginUser();
                                provider.setLoading(false);
                              },
                              wChild: Text("Login", style: AppTextStyles.sgBoldStyle.copyWith(
                                  color: AppColors.whiteColor, fontSize: 20),),
                            );
                        },
                      ),
                      // 10.ph,

                      //Extra Information!
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?", style: AppTextStyles.sgRegStyle.copyWith(
                                color: AppColors.blueBlack,
                                fontSize: 15,
                            ),),
                            TextButton(onPressed: (){
                              Navigator.push(context, PageTransition(
                                  child: const SignupScreen(), type: PageTransitionType.rightToLeft,
                              ),);
                            }, child: Text("Sign up", style: AppTextStyles.sgBoldStyle.copyWith(
                                color: AppColors.primaryColor, fontSize: 16),),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // 50.ph,
            // Container(
            //   color: AppColors.whiteColor,
            //   child: Lottie.asset("assets/animations/LoadingOne.json",
            //       height: 100, width: 100,
            //     fit: BoxFit.cover
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}



