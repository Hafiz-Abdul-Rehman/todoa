import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoa/constants/colors.dart';
import 'package:todoa/screens/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // late AnimationController _controller ;
  bool alreadyUsed = false;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    alreadyUsed = prefs.getBool("alreadyUsed") ?? false;
    print("Fetching...");
  }

  @override
  void initState() {
    // getData();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: IntroductionScreen(),
              type: PageTransitionType.rightToLeft));
      //
      // if(alreadyUsed == true){
      //   Navigator.pushReplacement(context, PageTransition(child: LoginScreen(), type: PageTransitionType.rightToLeft));
      // }else{
      //   Navigator.pushReplacement(context, PageTransition(child: IntroductionScreen(), type: PageTransitionType.rightToLeft));
      // }
      //   Navigator.pushReplacement(
      //     context, PageTransition(
      //     child: LoginScreen(),
      //       type: PageTransitionType.rightToLeft,
      //       duration: Duration(seconds: 0.7.toInt())
      //   ),
      // );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primaryColor,
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
            Center(
              child: Lottie.asset(
                "assets/animations/todoaicons.json",
                height: 200,
                width: 200,
                repeat: false,
                // frameRate: FrameRate(20)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
