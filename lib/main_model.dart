import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'restaurant.dart';

class MainModel extends ChangeNotifier {
  MainModel();

  List<Restaurant> resturantsNear = [];
  bool signedIn = false;
  String userName = '-1';
  String userId = '-1';

  void setCurrentUser(String userName, String userId) {
    this.signedIn = true;
    this.userName = userName;
    this.userId = userId;
    notifyListeners();
  }

  String getCurrentUserName() {
    return userName;
  }

  String getCurrentUserId() {
    return userId;
  }

  bool isUserSignedIn() {
    return signedIn;
  }
}

class currentUser {}
