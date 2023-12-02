import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todoa/screens/home_screen.dart';
import 'package:todoa/screens/login_screen.dart';
import 'package:todoa/utils/notification_services.dart';
import 'package:todoa/widgets/round_button.dart';
import 'package:todoa/widgets/sized_box_ex.dart';

import '../constants/app_text_styles.dart';
import '../constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;
  var userData = {};
  String userTodoLength = '';

  String email = '';

  Future<void> getUserData() async {
    setState(() {
      loading = true;
    });
    var _snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userData = _snap.data()!;
    var snap = await FirebaseFirestore.instance
        .collection("todos")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userTodo");
    userTodoLength = snap.snapshots().length.toString();

    email = userData['email'].substring(0, 4);

    setState(() {
      loading = false;
    });
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    getUserData().then((value) => debugPrint("Data Received!"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String email = userData["email"];
    // List<String> emailParts = email.split('');
    // String sEmail =
    //     emailParts[0] + emailParts[1] + emailParts[2] + emailParts[3];
    if (loading == true) {
      // showLoadingDialog();
      return const Center(
          child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ));
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: AppColors.transparent,
                child: Column(
                  children: [
                    30.ph,
                    Container(
                      height: MediaQuery.of(context).size.width * 0.36,
                      width: MediaQuery.of(context).size.width * 0.36,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.blueBlack,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            userData["profilePhotoUrl"].toString()),
                      ),
                    ),
                    10.ph,
                    Text(
                      userData['username'].toString(),
                      style: AppTextStyles.sgBoldStyle
                          .copyWith(fontSize: 24, color: AppColors.blueBlack),
                    ),
                    Text(
                      userData['bio'].toString(),
                      style: AppTextStyles.sfRegStyle.copyWith(
                          fontSize: 18,
                          color: AppColors.blueBlack,
                          letterSpacing: 1.5,
                          height: 0.9),
                    ),
                    30.ph,
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("todos")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("userTodo")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                              height: 70,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "No Data Found!",
                                style: AppTextStyles.sgBoldStyle.copyWith(
                                    fontSize: 24, color: AppColors.blueBlack),
                              ));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SpinKitThreeBounce(
                              color: AppColors.blueBlack,
                            ),
                          );
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return const Center(
                            child: Text("Some Error Occured!"),
                          );
                        } else {
                          final List<QueryDocumentSnapshot> documents =
                              snapshot.data!.docs;
                          int completedTasks = documents
                              .where((doc) => doc["isCompleted"] == true)
                              .length;
                          int incompleteTasks = documents
                              .where((doc) => doc["isCompleted"] == false)
                              .length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.ddOffWhite,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: AppTextStyles.sgBoldStyle
                                              .copyWith(
                                                  color: AppColors.blueBlack,
                                                  fontSize: 20),
                                        ),
                                        Text(
                                          "Todos",
                                          style: AppTextStyles.sfRegStyle
                                              .copyWith(
                                                  color: AppColors.blueBlack,
                                                  fontSize: 16,
                                                  letterSpacing: 1),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  height: 32,
                                  width: 4.5,
                                  decoration: BoxDecoration(
                                    color: AppColors.dTOffWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: AppColors.ddOffWhite,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          completedTasks.toString(),
                                          style: AppTextStyles.sgBoldStyle
                                              .copyWith(
                                                  color: AppColors.blueBlack,
                                                  fontSize: 20),
                                        ),
                                        Text(
                                          "Comp.",
                                          style: AppTextStyles.sfRegStyle
                                              .copyWith(
                                                  color: AppColors.blueBlack,
                                                  fontSize: 16,
                                                  letterSpacing: 1),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  height: 32,
                                  width: 4.5,
                                  decoration: BoxDecoration(
                                    color: AppColors.dTOffWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.ddOffWhite,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          incompleteTasks.toString(),
                                          style: AppTextStyles.sgBoldStyle
                                              .copyWith(
                                                  color: AppColors.blueBlack,
                                                  fontSize: 20),
                                        ),
                                        Text(
                                          "InComp.",
                                          style: AppTextStyles.sfRegStyle
                                              .copyWith(
                                                  color: AppColors.blueBlack,
                                                  fontSize: 16,
                                                  letterSpacing: 1),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    30.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "User Info",
                          style: AppTextStyles.sgBoldStyle.copyWith(
                            fontSize: 21,
                            color: AppColors.blueBlack,
                          ),
                        ),
                      ),
                    ),
                    10.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.ddOffWhite,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Email:",
                              style: AppTextStyles.sgBoldStyle.copyWith(
                                  fontSize: 19, color: AppColors.blueBlack),
                            ),
                            const Spacer(),
                            Text(
                              "$email***@gmail.com",
                              maxLines: 1,
                              style: AppTextStyles.sgRegStyle.copyWith(
                                  fontSize: 19, color: AppColors.blueBlack),
                            )
                          ],
                        ),
                      ),
                    ),
                    20.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.ddOffWhite,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Member Since:",
                              style: AppTextStyles.sgBoldStyle.copyWith(
                                  fontSize: 19, color: AppColors.blueBlack),
                            ),
                            const Spacer(),
                            // IconButton(
                            //   onPressed: () {
                            //     AppSettings.openNotificationSettings();
                            //     // AppSettings.openAppSettings(
                            //     //     type: AppSettingsType.notification);
                            //   },
                            //   icon: Icon(
                            //     Icons.notification_add_outlined,
                            //     color: AppColors.blueBlack,
                            //   ),
                            // ),
                            Text(
                              DateFormat.yMMMd()
                                  .format(userData!['createdAt'].toDate())
                                  .toString(),
                              maxLines: 1,
                              style: AppTextStyles.sgRegStyle.copyWith(
                                  fontSize: 19, color: AppColors.blueBlack),
                            )
                          ],
                        ),
                      ),
                    ),
                    //Todo this is second Section
                    30.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Actions",
                          style: AppTextStyles.sgBoldStyle.copyWith(
                            fontSize: 21,
                            color: AppColors.blueBlack,
                          ),
                        ),
                      ),
                    ),
                    10.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.ddOffWhite,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Rate us!",
                              style: AppTextStyles.sgBoldStyle.copyWith(
                                  fontSize: 19, color: AppColors.blueBlack),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.ddOffWhite,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Help & Support",
                              style: AppTextStyles.sgBoldStyle.copyWith(
                                  fontSize: 19, color: AppColors.blueBlack),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        splashColor: AppColors.primaryColor,
                        overlayColor: MaterialStateProperty.all<Color>(AppColors.whiteColor),
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          // NotificationServices().scheduleNotification(
                          //   0, // Unique ID for the notification
                          //   'Task Reminder',
                          //   'Your task is due now!',
                          //   DateTime.now().add(Duration(seconds: 10)), // Replace with your task's alarm time
                          // );
                          await FirebaseAuth.instance.signOut().then(
                                (value) =>
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                ),
                          );
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        },
                        child: Container(
                          height: 80,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.ddOffWhite,
                          ),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Logout",
                                style: AppTextStyles.sgBoldStyle.copyWith(
                                  fontSize: 20,
                                  color: AppColors.blueBlack,
                                ),
                              ),
                              10.pw,
                              const Icon(Icons.logout_rounded,
                                  color: AppColors.blueBlack)
                            ],
                          ),
                        ),
                      ),
                    ),

                    50.ph,
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 50),
                    //   child: MaterialButton(
                    //     elevation: 0,
                    //     color: AppColors.transparent,
                    //     shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.blueBlack.withOpacity(0.1)), borderRadius: BorderRadius.circular(15)),
                    //     // style: ElevatedButton.styleFrom(
                    //     //   side: BorderSide(color: AppColors.blueBlack.withOpacity(0.1))
                    //     // ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(20.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             "Logout",
                    //             style: AppTextStyles.sgBoldStyle.copyWith(
                    //               fontSize: 20,
                    //               color: AppColors.blueBlack,
                    //             ),
                    //           ),
                    //           10.pw,
                    //           const Icon(Icons.logout_rounded,
                    //               color: AppColors.blueBlack)
                    //         ],
                    //       ),
                    //     ),
                    //     onPressed: () async {
                    //       await FirebaseAuth.instance.signOut().then(
                    //             (value) =>
                    //                 Navigator.of(context).pushReplacement(
                    //               MaterialPageRoute(
                    //                 builder: (context) => const LoginScreen(),
                    //               ),
                    //             ),
                    //           );
                    //     },
                    //   ),
                    // ),
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
