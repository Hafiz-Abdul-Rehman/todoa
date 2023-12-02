import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todoa/constants/app_text_styles.dart';
import 'package:todoa/firebase_operations/todo_operations.dart';
import 'package:todoa/models/todo.dart';
import 'package:todoa/providers/category_provider.dart';
import 'package:todoa/providers/date_time_provider.dart';
import 'package:todoa/providers/todo_provider.dart';
import 'package:todoa/screens/home_screen.dart';
import 'package:todoa/utils/utils.dart';
import 'package:todoa/widgets/custom_text_field.dart';
import 'package:todoa/widgets/sized_box_ex.dart';

import '../constants/colors.dart';
import '../widgets/date_time_picker_widget.dart';
import '../widgets/radio_category_tile.dart';

class AddTodoScreen extends StatefulWidget {
  final String? documentID, title, desscription, priority, date, time;
  // final AsyncSnapshot<dynamic>? snap;
  const AddTodoScreen({super.key, this.documentID, this.title, this.desscription, this.priority, this.date, this.time});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();
  final descriptionController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  String priority = "";

  // void setData(){
  //   if(widget.title!=null && widget.desscription!=null && widget.priority!=null && widget.time!=null && widget.date!=null && widget.documentID!= null){
  //     titleController.text =
  //   }
  // }

  @override
  void initState() {
      print(widget.title);
      print(widget.desscription);
      print(widget.date);
      print(widget.time);
      print(widget.priority);
      print(widget.documentID.toString());


    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(
        context, listen: true);
    final dateTimeProvider = Provider.of<DateTimeProvider>(
        context, listen: true);
    final todoProvider = Provider.of<TodoProvider>(context, listen: true);


    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Add a Todo',
                      style: AppTextStyles.sgBoldStyle.copyWith(
                        fontSize: 26,
                        color: AppColors.blueBlack,
                      ),
                    ),
                  ],
                ),
                15.ph,
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'Title',
                    style: AppTextStyles.sfBoldStyle.copyWith(
                      fontSize: 22,
                      color: AppColors.blueBlack,
                    ),
                  ),
                ),
                5.ph,
                CustomTextField(
                  color: AppColors.ddOffWhite.withOpacity(0.6),
                  controller: titleController,
                  focusNode: titleFocusNode,
                  hint: "Add Task Name",
                  isObscure: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {},
                ),
                20.ph,
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'Description',
                    style: AppTextStyles.sfBoldStyle.copyWith(
                      fontSize: 22,
                      color: AppColors.blueBlack,
                    ),
                  ),
                ),
                5.ph,
                SecondCustomTextField(
                  maxLines: 3,
                  color: AppColors.ddOffWhite.withOpacity(0.6),
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  hint: "Description",
                  keyboardType: TextInputType.text,
                ),
                15.ph,
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'Priority',
                    style: AppTextStyles.sfBoldStyle.copyWith(
                      fontSize: 22,
                      color: AppColors.blueBlack,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: RadioCategoryTile(
                        onChanged: (value) {
                          categoryProvider.setCategory(value);
                          priority = value;
                          print(priority);
                        },
                        contentColor: AppColors.redColor.withOpacity(0.8),
                        groupVal: categoryProvider.priority,
                        val: "High",
                        title: "High",
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: RadioCategoryTile(
                        onChanged: (value) {
                          categoryProvider.setCategory(value);
                          priority = value;
                          print(priority);
                        },
                        contentColor: AppColors.orangeColor.withOpacity(0.8),
                        groupVal: categoryProvider.priority,
                        val: "Normal",
                        title: "Normal",
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: RadioCategoryTile(
                        onChanged: (value) {
                          categoryProvider.setCategory(value);
                          priority = value;
                          print(priority);
                        },
                        contentColor: AppColors.primaryColor.withOpacity(0.8),
                        groupVal: categoryProvider.priority,
                        val: "Low",
                        title: "Low",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<DateTimeProvider>(
                      builder: (context, value, child) {
                        return DateTimePickerWidget(
                          iTitle: value.date,
                          icon: CupertinoIcons.calendar,
                          uTitle: "Date",
                          onPressed: () async {
                            descriptionFocusNode.unfocus();
                            titleFocusNode.unfocus();
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (pickedDate != null) {
                              final formattedPickedDate = DateFormat.yMd();
                              value.setDate(formattedPickedDate
                                  .format(pickedDate)
                                  .toString());
                              debugPrint(formattedPickedDate
                                  .format(pickedDate)
                                  .toString());
                            } else {
                              debugPrint("Date is null.");
                            }
                          },
                        );
                      },
                    ),
                    15.pw,
                    Consumer<DateTimeProvider>(
                      builder: (context, value, child) {
                        return DateTimePickerWidget(
                          onPressed: () async {
                            descriptionFocusNode.unfocus();
                            titleFocusNode.unfocus();
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            value
                            // ignore: use_build_context_synchronously
                                .setTime(
                                pickedTime!.format(context).toString());
                            if (pickedTime != null) {
                              debugPrint(pickedTime.toString());
                            } else {
                              debugPrint("Time is null.");
                            }
                          },
                          iTitle: value.time,
                          icon: Icons.access_time_outlined,
                          uTitle: "Time",
                        );
                      },
                    ),
                  ],
                ),
                30.ph,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            backgroundColor: AppColors.whiteColor,
                            surfaceTintColor: AppColors.whiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: AppColors.primaryColor,
                                ))),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: const HomeScreen(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        },
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.sfBoldStyle.copyWith(
                            fontSize: 18,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    15.pw,
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: AppColors.primaryColor,
                                ))),
                        onPressed: () async  {
                          if (dateTimeProvider.date == 'dd:mm:yy' ||
                              dateTimeProvider.time == 'hh:mm' ||
                              titleController.text == "" ||
                              descriptionController.text == "") {
                            Utils.showFlushBar(
                                context, "Please fil all fields.", const Icon(
                              Icons.error_rounded,
                              color: AppColors.whiteColor,),
                                AppColors.redColor);
                          }else if (titleController.text.length >22) {
                            Utils.showFlushBar(
                                context, "Title can't be greater than 22 Characters!", const Icon(
                              Icons.error_rounded,
                              color: AppColors.whiteColor,),
                                AppColors.redColor);
                          } else {
                            todoProvider.uploadTodo(
                              title: titleController.text,
                              description: descriptionController.text,
                              priority: priority,
                              date: dateTimeProvider.date,
                              time: dateTimeProvider.time,
                              isComplete: false
                            );
                            titleFocusNode.unfocus();
                            descriptionFocusNode.unfocus();
                            titleController.clear();
                            descriptionController.clear();
                            dateTimeProvider.resetDateTime();
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: const HomeScreen(),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          }

                          debugPrint("Priority is set to $priority.");
                        },
                        child: Text(
                          'Create',
                          style: AppTextStyles.sfBoldStyle.copyWith(
                            fontSize: 18,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
