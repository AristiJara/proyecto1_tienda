import 'package:flutter/material.dart';
import 'package:proyecto1_tienda/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser({required String email, required String role, required String token}) {
    _user = User(email: email, role: role, token: token);
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
  
  bool isAdmin() {
    return _user?.role == 'ADMIN';
  }
}