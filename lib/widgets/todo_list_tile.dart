import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todoa/widgets/sized_box_ex.dart';

import '../constants/app_text_styles.dart';
import '../constants/colors.dart';

class TodoListTile extends StatefulWidget {
  final String todoTitle;
  final String todoDescription;
  final String todoDate;
  final String todoTime;
  final Color color;
  final String docId;
  bool isCompleted;
   final Function(BuildContext)? onEdit;
   final Function(BuildContext)? onDelete;

  TodoListTile({super.key, required this.todoTitle, required this.todoDescription, required this.todoDate, required this.todoTime, required this.color, required this.onEdit, required this.onDelete, required this.isCompleted, required this.docId});

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {

  int maxWords = 4; // Maximum number of words to display

  String limitDescription(String description) {
    List<String> words = description.split(' ');
    if (words.length <= maxWords) {
      return description; // Return the original description if it has fewer or equal words than the limit
    }
    List<String> limitedWords = words.sublist(0, maxWords);
    return limitedWords.join(' ') + '...'; // Combine limited words and add ellipsis
  }

  // bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 15.0, ).copyWith(bottom: 5, top: 5),
      child: Slidable(

        direction: Axis.horizontal,

        endActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: widget.onEdit,
              icon: FontAwesomeIcons.edit,
              backgroundColor: AppColors.transparent,
              foregroundColor: AppColors.primaryColor,
              label: "Edit",
            ),
            SlidableAction(
              onPressed: widget.onDelete,
              icon: CupertinoIcons.delete,
              backgroundColor: AppColors.transparent,
              foregroundColor: AppColors.redColor,
              label: "Delete",
            ),

          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: (){
            setState(() {
              FirebaseFirestore.instance.collection("todos").doc(FirebaseAuth.instance.currentUser!.uid).collection("userTodo").doc(widget.docId).update(
                  {
                    "isCompleted" : !widget.isCompleted,
                  });
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            height: 120,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.ddOffWhite.withOpacity(0.8), width: 1),
              borderRadius: BorderRadius.circular(20),
              color: AppColors.ddOffWhite.withOpacity(0.5),
            ),
            child: Row(
              children: [
                3.pw,
                Container(
                  height: double.infinity,
                  width: 5,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                20.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.todoTitle, style: AppTextStyles.sfBoldStyle.copyWith(fontSize: 20, color: AppColors.blueBlack, decoration: widget.isCompleted ? TextDecoration.lineThrough : TextDecoration.none),),
                    Text(limitDescription(widget.todoDescription),overflow: TextOverflow.ellipsis, style: AppTextStyles.sfRegStyle.copyWith(fontSize: 15, color: AppColors.blueBlack.withOpacity(0.7), decoration: widget.isCompleted ? TextDecoration.lineThrough : TextDecoration.none),),
                    Row(
                      children: [
                        Text(widget.todoTime, style: AppTextStyles.sfRegStyle.copyWith(fontSize: 15, color: AppColors.blueBlack.withOpacity(0.6)),),
                        Text("  -  ", style: AppTextStyles.sgBoldStyle.copyWith(fontSize: 15, color: AppColors.blueBlack.withOpacity(0.6)),),
                        Text(widget.todoDate, style: AppTextStyles.sfRegStyle.copyWith(fontSize: 15, color: AppColors.blueBlack.withOpacity(0.6)),),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Transform.scale(
                  scale: 1.5,
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: AppColors.dTOffWhite.withOpacity(0.5),
                    ),
                    child: Checkbox(

                        activeColor: AppColors.primaryColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // visualDensity: VisualDensity.,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        value: widget.isCompleted,
                        onChanged: (nValue){
                      setState(() {
                        FirebaseFirestore.instance.collection("todos").doc(FirebaseAuth.instance.currentUser!.uid).collection("userTodo").doc(widget.docId).update(
                            {
                              "isCompleted" : nValue
                            });
                        // widget.isCompleted = !widget.isCompleted;
                      });

                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
