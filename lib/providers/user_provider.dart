import 'package:flutter/foundation.dart';
import 'package:todoa/providers/auth_provider.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  AuthProvider authProvider = AuthProvider();
  User get getUser => _user!;

  Future<void> refreshUser()async{
    User user = await authProvider.getDetails();
    _user = user;
    notifyListeners();
  }
}