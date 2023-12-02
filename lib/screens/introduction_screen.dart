import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todoa/screens/login_screen.dart';
import '../constants/app_text_styles.dart';
import '../constants/colors.dart';
import '../models/introduction_model.dart';

class IntroductionScreen extends StatefulWidget{

  IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int cIndex = 0;
  PageController pController = PageController();

  @override
  void initState() {
    pController = PageController(initialPage: 0,);
    super.initState();
  }

  @override
  void dispose() {
    pController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
      // systemNavigationBarColor: AppColors.transparent,
    ));
    return Scaffold(
      // backgroundColor: AppColors,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: const PageScrollPhysics(),
              controller: pController,
              onPageChanged: (int index){
                setState(() {
                  cIndex = index;
                });
              },
              itemCount: contents.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Center(
                            child: SizedBox(
                        height: cIndex == 0 ? 180 : 270,
                        width: cIndex == 0 ? 180 : 270,
                        child: ClipRRect(
                            borderRadius: cIndex == 0 ? BorderRadius.circular(30) : BorderRadius.circular(10),
                              child: cIndex == 0 ? Image.asset(contents[index].image,
                                height: 180,
                                width: 180,) : Image.asset(contents[index].image,height: 270,
                                width: 270,)
                        ),
                      ),
                          )),
                      const SizedBox(height: 15,),
                      Text(contents[index].title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.sgBoldStyle.copyWith(fontSize: 30, color: AppColors.blueBlack),),
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0,).copyWith(bottom: 30),
                        child: Text(
                          contents[index].description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.sgRegStyle.copyWith(fontSize: 20, color: AppColors.blueBlack.withOpacity(0.7)),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25).copyWith(bottom: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(contents.length, (index) => buildDotContainer(index, context),)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: FloatingActionButton.extended(
                    splashColor: AppColors.whiteColor.withOpacity(0.2),
                    backgroundColor: AppColors.primaryColor,
                      onPressed: (){
                        if(cIndex == contents.length-1){
                          Navigator.pushReplacement(context, PageTransition(child:LoginScreen(), type: PageTransitionType.bottomToTop));
                        }else{
                          pController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                        }
                      },

                      label: cIndex != contents.length-1 ? Row(
                        children: [
                          Text( "Next", style: AppTextStyles.sgRegStyle.copyWith(fontSize: 18, color: AppColors.whiteColor),),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_forward, color: AppColors.whiteColor,)
                        ],
                      ) : Row(
                        children: [
                          Text( "Continue", style: AppTextStyles.sgRegStyle.copyWith(fontSize: 18, color: AppColors.whiteColor),),
                          SizedBox(width: 10,),
                          Icon(CupertinoIcons.arrow_right_to_line, color: AppColors.whiteColor,)
                        ],
                      ),
                      // icon: cIndex != contents.length-1 ? const Icon(Icons.arrow_forward, color: AppColors.whiteColor,):
                      // const Icon(CupertinoIcons.arrow_right_to_line, color: AppColors.whiteColor,)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildDotContainer(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: cIndex == index ? 25 : 15,
        // width: cIndex == index ? 20 : 10,
        width: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}


class UiButton extends StatefulWidget {
  const UiButton({super.key});
  _UiButtonState createState() => _UiButtonState();
}

class _UiButtonState extends State<UiButton> {
  double _buttonWidth = 100.0;
  double _buttonHeight = 50.0;
  bool _isPressed = false;


  void _updateButtonSize() {
    setState(() {
      _buttonWidth = 90.0;
      _buttonHeight = 45.0;
    });
  }

  void _resetButtonSize() {
    setState(() {
      _buttonWidth = 100.0;
      _buttonHeight = 50.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Resposive Button"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      _isPressed = true;
                    });
                    _updateButtonSize();
                  },
                  onTapUp: (details) {
                    setState(() {
                      _isPressed = false;
                    });
                    _resetButtonSize();
                  },
                  onTapCancel: () {
                    setState(() {
                      _isPressed = false;
                    });
                    _resetButtonSize();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isPressed ? _buttonWidth : 100.0,
                    height: _isPressed ? _buttonHeight : 50.0,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'Press and Hold',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
