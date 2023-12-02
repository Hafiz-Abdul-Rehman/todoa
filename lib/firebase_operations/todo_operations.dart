import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoa/models/todo.dart';

class TodoOperations{

  // Creating a Todo
  createTodo(Todo model) {
  final todoCollection = FirebaseFirestore.instance.collection("todos").doc(FirebaseAuth.instance.currentUser!.uid).collection("userTodo").doc(model.docId);
    todoCollection.set(model.toMap());
    // todoCollection.set();
  }
  updatingTodo(Todo model) {
    final todoCollection = FirebaseFirestore.instance.collection("todos").doc(FirebaseAuth.instance.currentUser!.uid).collection("userTodo").doc(model.docId);
    todoCollection.update(model.toMap());
    // todoCollection.set();
  }

  delTodo(String documentId) {
    final todoCollection = FirebaseFirestore.instance.collection("todos").doc(FirebaseAuth.instance.currentUser!.uid).collection("userTodo").doc(documentId);
    todoCollection.delete();
    // todoCollection.set();
  }
}