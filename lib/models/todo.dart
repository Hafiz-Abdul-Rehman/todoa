// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String docId;
  final String taskTitle;
  final String taskDescription;
  final String taskPriority;
  final String taskDate;
  final String taskTime;
  final bool isCompleted;

  Todo(
      {
      required this.docId,
      required this.taskTitle,
      required this.taskDescription,
      required this.taskDate,
      required this.taskPriority,
      required this.taskTime,
      required this.isCompleted
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'taskPriority': taskPriority,
      'taskDate': taskDate,
      'taskTime': taskTime,
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      docId: map['documentId'] as String,
      taskTitle: map['taskTitle'] as String,
      taskDescription: map['taskDescription'] as String,
      taskPriority: map['taskPriority'] as String,
      taskDate: map['taskDate'] as String,
      taskTime: map['taskTime'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }
  factory Todo.fromSnap(DocumentSnapshot<Map<String, dynamic>> document) {
    return Todo(
      docId: document.id,
      taskTitle: document["taskTitle"],
      taskDescription: document["taskDescription"],
      taskPriority: document['taskPriority'],
      taskDate: document["taskDate"],
      taskTime: document["taskTime"],
      isCompleted: document["isCompleted"]
    );
  }
}
