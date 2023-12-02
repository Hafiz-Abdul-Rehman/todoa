import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoa/constants/app_text_styles.dart';
import 'package:todoa/screens/add_todo_screen.dart';
import 'package:todoa/screens/profile_screen.dart';
import 'package:todoa/screens/todos_list_screen.dart';
// import 'package:todoa/screens/profile_screen.dart';

import '../constants/colors.dart';
import '../utils/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  PageController pageController = PageController();
  int index = 0;
  Future<void> setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("alreadyUsed", true);
    print("Data updated");
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    setData();
    notificationServices.requestNotificationPermission();
    // notificationServices.isTokenRefresh();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      print("Device Token: $value");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      // onWillPop: () async {
      //   SystemNavigator.pop(animated: true);
      //   return true;
      // },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              index = page;
            });
          },
          children:  const [
            CategoryListScreen(),
            AddTodoScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: Container(
            width: double.infinity,
            height: 60,
            child: CustomNavigationBar(
              currentIndex: index,
              // isFloating: true,
              borderRadius: const Radius.circular(13),
              bubbleCurve: Curves.easeIn,
              strokeColor: AppColors.whiteColor,
              scaleCurve: Curves.easeOut,
              selectedColor: AppColors.whiteColor,
              unSelectedColor: AppColors.whiteColor.withOpacity(0.5),
              // unSelectedColor: AppColors.mDarkPrimaryColor.withOpacity(0.6),
              scaleFactor: 0.5,
              iconSize: 30.0,
              elevation: 0,
              onTap: (value) {
                index = value;
                pageController.jumpToPage(index);
              },
              backgroundColor: AppColors.primaryColor,
              // backgroundColor: Color(0xff040307),
              items: [
                CustomNavigationBarItem(
                  icon: const Icon(
                    FontAwesomeIcons.tasks,
                    size: 26,
                  ),
                  selectedIcon: const Icon(
                    FontAwesomeIcons.tasks,
                    size: 28,
                  ),
                ),
                // icon: const Icon(CupertinoIcons.list_bullet_below_rectangle)),
                CustomNavigationBarItem(
                  icon: const Icon(
                    FontAwesomeIcons.notesMedical,
                    size: 28,
                  ),
                  selectedIcon: const Icon(
                    FontAwesomeIcons.notesMedical,
                    size: 30,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    CupertinoIcons.person,
                    size: 32,
                  ),
                  selectedIcon: const Icon(
                    CupertinoIcons.person_fill,
                    size: 32,
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

// Future<bool> _onBackButtonPressed(BuildContext context) async {
//   bool exitApp = await showDialog(
//     barrierDismissible: true,
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         backgroundColor: AppColors.whiteColor,
//         actionsAlignment: MainAxisAlignment.center,
//         actionsPadding: EdgeInsets.only(bottom: 20),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         title: Center(
//           child: Text(
//             "Sure?",
//             style: AppColors.sg.copyWith(
//               fontSize: 22,
//             ),
//           ),
//         ),
//         content: Text(
//           "Are you Sure to exit the Noor e Quran?",
//           textAlign: TextAlign.center,
//           style: AppColors.whiteStyle.copyWith(
//             fontSize: 21,
//           ),
//         ),
//         actions: [
//           Container(
//             height: 50,
//             width: 130,
//             child: ElevatedButton(
//               style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all(AppColors.alertColor)),
//               child: Text(
//                 "Yes",
//                 style: TextStyle(
//                     color: AppColors.whiteColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//             ),
//           ),
//           Container(
//             height: 50,
//             width: 130,
//             child: ElevatedButton(
//               style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all(AppColors.primaryColor)),
//               child: Text(
//                 "No",
//                 style: TextStyle(
//                     color: AppColors.whiteColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//             ),
//           ),
//         ],
//       );
//     },
//   );
//   return exitApp;
// }

Future<bool> _onBackButtonPressed(BuildContext context) async {
  bool exitApp = await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.whiteColor,
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Center(
          child: Text("Sure?", style: AppTextStyles.sgBoldStyle.copyWith()),
        ),
        content: Text(
          "Are you Sure to exit the Todoa?",
          textAlign: TextAlign.center,
          style: AppTextStyles.sgRegStyle.copyWith(
            fontSize: 21,
          ),
        ),
        actions: [
          Container(
            height: 50,
            width: 130,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.redColor)),
              child: Text(
                "Yes",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
          Container(
            height: 50,
            width: 130,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.primaryColor)),
              child: Text(
                "No",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
        ],
      );
    },
  );
  return exitApp;
}
