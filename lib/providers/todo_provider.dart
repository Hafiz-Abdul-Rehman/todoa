import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../firebase_operations/todo_operations.dart';
import '../models/todo.dart';
class TodoProvider with ChangeNotifier{


  void uploadTodo({required String title, required String description, required String priority, required String date, required String time, required bool isComplete,})async{
    TodoOperations operations = TodoOperations();
    await operations.createTodo(
      Todo(
        docId: Uuid().v4(),
        taskTitle: title,
        taskDescription: description,
        taskPriority: priority,
        taskDate: date,
        taskTime: time,
        isCompleted: false
      ),
    );
  }

  void updateTodo({required String docId, required String title, required String description, required String priority, required String date, required String time, required bool isComplete})async{
    TodoOperations operations = TodoOperations();
    await operations.updatingTodo(
      Todo(
        docId: docId,
        taskTitle: title,
        taskDescription: description,
        taskPriority: priority,
        taskDate: date,
        taskTime: time,
        isCompleted: isComplete
      ),
    );
  }

  void deleteTodo({required String docId})async{
    TodoOperations operations = TodoOperations();
    await operations.delTodo(docId);
  }
}