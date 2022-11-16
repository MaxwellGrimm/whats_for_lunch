import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'restaurant.dart';

class MainModel extends ChangeNotifier {
  MainModel();

  List<Restaurant> resturantsNear = [];

  bool signedIn = false;
  String? userName = 'User Name';
  String? userId = 'User ID';

  void setCurrentUser(String? userName, String? userId) {
    signedIn = true;
    this.userName = userName;
    this.userId = userId;
    notifyListeners();
  }

  String? getCurrentUserName() {
    return userName;
  }

  String? getCurrentUserId() {
    return userId;
  }

  bool isUserSignedIn() {
    return signedIn;
  }

  void userSignedOut() {
    this.signedIn = false;
    this.userName = 'User Name';
    this.userId = 'User ID';
    notifyListeners();
  }
}
