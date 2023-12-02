import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoa/constants/app_text_styles.dart';
import 'package:todoa/providers/todo_provider.dart';

import '../constants/colors.dart';

class Utils {
  static showFlushBar(BuildContext context, String message,
      [Icon? icon, Color? color, bool? isTop]) {
    // ignore: avoid_single_cascade_in_expression_statements
    return Flushbar(
      isDismissible: true,
      forwardAnimationCurve: Curves.ease,
      padding: isTop != null && isTop == true
          ? const EdgeInsets.symmetric(horizontal: 15, vertical: 30)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      flushbarPosition: isTop != null && isTop == true
          ? FlushbarPosition.TOP
          : FlushbarPosition.BOTTOM,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 3),
      backgroundColor: color ?? AppColors.blueBlack,
      margin: const EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(8),
      icon: icon ??
          const Icon(
            Icons.error_rounded,
            color: AppColors.whiteColor,
          ),
      messageText: Text(
        message,
        style: AppTextStyles.sgRegStyle.copyWith(
          color: AppColors.whiteColor,
          fontSize: 16,
        ),
      ),
    )..show(context);
  }

  static onDelPressed(
      {required BuildContext context,
      required String title,
      required String desc,
      required String documentID}) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(title, style: AppTextStyles.sfBoldStyle.copyWith()),
          ),
          content: Text(
            desc,
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
                child: const Text(
                  "Yes",
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  todoProvider.deleteTodo(docId: documentID);
                  Navigator.pop(context);
                  showFlushBar(
                      context,
                      "Task Deleted",
                      const Icon(
                        CupertinoIcons.delete_solid,
                        color: AppColors.whiteColor,
                      ),
                      Colors.red.shade400,
                      true);
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
                child: const Text(
                  "No",
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
