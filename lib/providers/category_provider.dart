import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier{
  String _priority = "Normal";
  String get priority => _priority;

  void setCategory(priority){
    _priority = priority;
    notifyListeners();
  }
}