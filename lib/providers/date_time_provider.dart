import "package:flutter/foundation.dart";

class DateTimeProvider with ChangeNotifier {
  String _date = "dd/mm/yy";
  String get date => _date;

  String _time = "hh:mm";
  String get time => _time;

  void setDate(date) {
    _date = date;
    notifyListeners();
  }

    void setTime(time) {
    _time = time;
    notifyListeners();
  }

  void resetDateTime(){
    _date = "dd/mm/yy";
    _time = "hh:mm";
    notifyListeners();
  }
}
