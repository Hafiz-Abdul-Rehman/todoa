import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todoa/constants/app_text_styles.dart';
import 'package:todoa/utils/utils.dart';
import 'package:todoa/widgets/sized_box_ex.dart';
import 'package:todoa/widgets/todo_list_tile.dart';
import 'package:todoa/widgets/update_bottom_sheet.dart';
import '../constants/colors.dart';
import 'login_screen.dart';

enum MenuOption { rate, settings }

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final searchTodoController = TextEditingController();
  final searchTodoNode = FocusNode();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    searchTodoController.dispose();
    searchTodoNode.dispose();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;
  var userData = {};

  void getUserData() async {
    setState(() {
      loading = true;
    });
    // ignore: no_leading_underscores_for_local_identifiers
    var _snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userData = _snap.data()!;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<dynamic> showLoadingDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // String fullName = "Hafiz Abdul Rehman";
    final snap = FirebaseFirestore.instance
        .collection("todos")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userTodo");

    // final todoProvider = Provider.of<TodoProvider>(context);

    String username = userData['username'].toString();
    List<String> nameParts = username.split(' ');
    String firstName = nameParts[0];

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
      // systemNavigationBarColor: AppColors.transparent,
    ));

    if (loading) {
      // showLoadingDialog();
      return const Center(
          child: SpinKitThreeBounce(
        color: AppColors.primaryColor,
      ));
    }
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        toolbarHeight: 70,
        // backgroundColor: AppColors.dOffWhite,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 15),
          child: GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (context){
                 return SimpleDialog(
                   insetPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.05),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                   contentPadding: EdgeInsets.all(5),
                   shadowColor:  AppColors. blueBlack,
                   children: [
                     Center(
                       child: Hero(
                         transitionOnUserGestures: true,
                         tag: "Imga",
                         child: Container(
                           height: MediaQuery.sizeOf(context).width * 0.9,
                           width: MediaQuery.sizeOf(context).width * 0.9,
                           decoration: BoxDecoration(

                               color: AppColors.darkPrimaryColor.withOpacity(0.4),
                               image: DecorationImage(
                                   image: NetworkImage(
                                     userData["profilePhotoUrl"].toString(),
                                   ),
                                   fit: BoxFit.cover)),
                           // child: Hero(
                           //   tag: "Imga",
                           //   child: Image(
                           //       image: NetworkImage(
                           //         userData["profilePhotoUrl"].toString(),
                           //       ),
                           //       fit: BoxFit.contain),
                           // ),
                         ),
                       ),
                     )
                   ],
                 );
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Hero(
                transitionOnUserGestures: true,
                tag: "Imga",
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: AppColors.darkPrimaryColor.withOpacity(0.4),
                      image: DecorationImage(
                          image: NetworkImage(
                            userData["profilePhotoUrl"].toString(),
                          ),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello,",
              style: AppTextStyles.sgRegStyle.copyWith(
                fontSize: 16,
                color: AppColors.blueBlack,
              ),
            ),
            Text(
              firstName,
              style: AppTextStyles.sgBoldStyle.copyWith(
                fontSize: 19,
                color: AppColors.blueBlack,
              ),
            ),
          ],
        ),

        // TODO: PopUp Menu Button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: PopupMenuButton<MenuOption>(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.ddOffWhite),
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              surfaceTintColor: AppColors.whiteColor,
              color: AppColors.whiteColor,
              icon: const Icon(
                EvaIcons.moreVertical,
                size: 28,
                color: AppColors.blueBlack,
              ),
              onSelected: (MenuOption result) {
                // Handle the selected menu option
                switch (result) {
                  case MenuOption.rate:
                    // Handle option 1
                    debugPrint("Option 1");
                    break;
                  case MenuOption.settings:
                    // Handle option 2
                    debugPrint("Option 2");
                    break;
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<MenuOption>>[
                PopupMenuItem<MenuOption>(
                  padding: const EdgeInsets.only(
                    right: 40,
                    left: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  value: MenuOption.rate,
                  child: Text(
                    'Rate us!',
                    style: AppTextStyles.sgRegStyle.copyWith(
                      color: AppColors.blueBlack,
                      fontSize: 17,
                    ),
                  ),
                ),
                PopupMenuItem<MenuOption>(
                  padding: const EdgeInsets.only(
                    right: 40,
                    left: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  value: MenuOption.settings,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut().then(
                          (value) => Navigator.of(context).pushReplacement(
                            PageTransition(
                              child: const LoginScreen(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          ),
                        );
                  },
                  child: Text(
                    'Log out',
                    style: AppTextStyles.sgRegStyle.copyWith(
                      color: AppColors.blueBlack,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO: Todoa Banner Widget, and Here was Expanded
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                .copyWith(bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primaryColor),
            child: SafeArea(
              child: Stack(
                children: [
                  const Positioned(
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: Image(
                      image: AssetImage("assets/images/Checklist-.png"),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: AppColors.darkPrimaryColor.withOpacity(0.0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  25.pw,
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      "assets/images/Todoa-App.jpg",
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                  10.pw,
                                  Text(
                                    "Todoa",
                                    style: AppTextStyles.sgBoldStyle.copyWith(
                                        fontSize: 29,
                                        color: AppColors.whiteColor),
                                  ),
                                ],
                              ),
                              15.pw,
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 27.0,
                          ),
                          child: Text(
                            "Welcome back! 🙂",
                            style: AppTextStyles.sfRegStyle.copyWith(
                              fontSize: 20,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //TODO: TaskCategories Widget, and Here was also Expanded
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              // color: AppColors.dOffWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      10.pw,
                      Text(
                        "Task Categories",
                        style: AppTextStyles.sgBoldStyle.copyWith(
                          fontSize: 25,
                          color: AppColors.blueBlack,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // TodoListTile

          //TODO: List of Todos!
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("todos")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("userTodo")
                .orderBy("taskDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        Color color;

                        switch (snapshot.data.docs[index]["taskPriority"]) {
                          case "High":
                            color = AppColors.redColor.withOpacity(0.8);
                            break;
                          case "Normal":
                            color = AppColors.orangeColor.withOpacity(0.8);
                            break;
                          case "Low":
                            color = AppColors.primaryColor.withOpacity(0.8);
                            break;
                          default:
                            color = AppColors.orangeColor.withOpacity(0.8);
                            break;
                        }
                        String desc = snapshot.data.docs[index]
                        ["taskDescription"];
                        // List<String> newdesc = desc.split('');
                        if(desc.length > 40){
                        desc = desc.substring(0, 40);
                        }
                        return TodoListTile(
                          isCompleted: snapshot.data.docs[index]["isCompleted"],
                          docId: snapshot.data.docs[index]["docId"],
                          color: color,
                          todoTitle: snapshot.data.docs[index]["taskTitle"],
                          todoDate: snapshot.data.docs[index]["taskDate"],
                          todoDescription: desc,
                          // todoDescription: snapshot.data.docs[index]
                          //     ["taskDescription"],
                          todoTime: snapshot.data.docs[index]["taskTime"],
                          onDelete: (context) {
                            debugPrint("Deleted Task");
                            Utils.onDelPressed(
                                context: context,
                                title: "Delete Task",
                                desc: "Are you sure to delete this task?",
                                documentID: snapshot.data.docs[index]["docId"]);
                          },
                          onEdit: (context) {
                            updateModalBottomSheet(
                              context: context,
                              snap: snap,
                              documentID: snapshot.data.docs[index]["docId"],
                              title: snapshot.data.docs[index]["taskTitle"],
                              desscription: snapshot.data.docs[index]
                                  ["taskDescription"],
                              date: snapshot.data.docs[index]["taskDate"],
                              time: snapshot.data.docs[index]["taskTime"],
                              tPriority: snapshot.data.docs[index]
                                  ["taskPriority"],
                              isComp: snapshot.data.docs[index]["isCompleted"],
                            );
                            // Navigator.push(context, PageTransition(
                            //   child: AddTodoScreen(
                            //     documentID: snapshot.data.docs[index]["docId"],
                            //     title: snapshot.data.docs[index]["taskTitle"],
                            //     desscription: snapshot.data.docs[index]["taskDescription"],
                            //     date: snapshot.data.docs[index]["taskDate"],
                            //     time: snapshot.data.docs[index]["taskTime"],
                            //     priority: snapshot.data.docs[index]["taskPriority"],
                            //   ),
                            //   type: PageTransitionType.bottomToTop,
                            // ));
                          },
                        );
                      },
                    ),
                  );
                } else if (!snapshot.hasData) {
                  // } else if (snapshot.data.docs.length == 0) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "No Todos Yet!",
                        style: TextStyle(
                          fontFamily: "SG Reg",
                          fontSize: 20,
                          color: AppColors.dTOffWhite,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "Some Error Occurred!",
                        style: TextStyle(
                          fontFamily: "SG Reg",
                          fontSize: 20,
                          color: AppColors.dTOffWhite,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "Some Other Error Occurred!",
                      style: TextStyle(
                        fontFamily: "SG Reg",
                        fontSize: 20,
                        color: AppColors.dTOffWhite,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
