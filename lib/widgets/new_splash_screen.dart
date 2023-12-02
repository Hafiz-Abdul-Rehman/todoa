import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoa/constants/app_text_styles.dart';
import 'package:todoa/constants/colors.dart';
import 'package:todoa/screens/home_screen.dart';
import 'package:todoa/screens/login_screen.dart';
import 'package:todoa/widgets/sized_box_ex.dart';
import 'package:page_transition/page_transition.dart' as pageTransition;

import '../screens/introduction_screen.dart';

class MyCustomSplashScreen extends StatefulWidget {
  const MyCustomSplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyCustomSplashScreenState createState() => _MyCustomSplashScreenState();
}

class _MyCustomSplashScreenState extends State<MyCustomSplashScreen>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;
  bool alreadyUsed = false;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    alreadyUsed = prefs.getBool("alreadyUsed") ?? false;
    print("Fetching...");
  }

  @override
  void initState() {
    getData();
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 25).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(Duration( seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        _containerSize = 3;
        _containerOpacity = 1;
      });
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        //   Navigator.pushReplacement(
        //       context, pageTransition.PageTransition(
        //       child: IntroductionScreen(), type: pageTransition.PageTransitionType.bottomToTop,
        //   ),
        // );
        void navigateToNextScreen() {
          // Implement your navigation logic here
          // For example, use Navigator to push a new route
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      FirebaseAuth.instance.currentUser != null) {
                    if (snapshot.hasData) {
                      return HomeScreen();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "${snapshot.error}",
                        ),
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blueBlack,
                      ),
                    );
                  } else {
                    return LoginScreen();
                  }
                },
              );
            }),
          );
        }

        if (alreadyUsed != true) {
          Navigator.pushReplacement(
              context,
              pageTransition.PageTransition(
                  child: IntroductionScreen(),
                  type: pageTransition.PageTransitionType.rightToLeft));
        } else {
          navigateToNextScreen();
        }

        // isLogin();

        // Navigator.pushReplacement(context, PageTransition(LoginScreen()));
      });
    });
  }

  // void isLogin() {
  //   final auth = FirebaseAuth.instance;
  //   final user = auth.currentUser;

  //   if (user != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       pageTransition.PageTransition(
  //         child: HomeScreen(),
  //         type: pageTransition.PageTransitionType.bottomToTop,
  //       ),
  //     );
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       pageTransition.PageTransition(
  //         child: LoginScreen(),
  //         type: pageTransition.PageTransitionType.bottomToTop,
  //       ),
  //     );
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.primaryColor
            // gradient: LinearGradient(
            //   colors: [AppColors.primaryColor, AppColors.darkPrimaryColor],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // )
            ),
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: _height / _fontSize),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 1000),
                  opacity: _textOpacity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('ToDoa',
                          style: AppTextStyles.sgBoldStyle.copyWith(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            // fontSize: 25,
                            fontSize: animation1.value,
                          )),
                      10.ph
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                opacity: _containerOpacity,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: _width / _containerSize,
                    width: _width / _containerSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    // child: Image.asset('assets/images/file_name.png')
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image(
                          image: AssetImage("assets/images/Todoa-App.jpg"),
                          fit: BoxFit.cover,
                        ))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page, {required child})
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
            );
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                child: page,
                axisAlignment: 0,
              ),
            );
          },
        );
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          'YOUR APP\'S NAME',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
