import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'restaurant.dart';

class MainModel extends ChangeNotifier {
  MainModel();

  List<Restaurant> restaurantsNear = [];

  double userCurrentLat = 44.0;
  double userCurrentLng = -88.0;

  var db = FirebaseFirestore.instance;

  bool signedIn = false;
  String? userName = 'User Name';
  String? userId = 'User ID';

  void setCurrentUser(String? userName, String? userId) {
    signedIn = true;
    this.userName = userName;
    this.userId = userId;
    notifyListeners();
  }

  getDatabase() {
    return db;
  }
  
  void addRestaurant(List<Restaurant> restaurant) {
    restaurantsNear = restaurant;
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

  double getUserCurrentLat() => userCurrentLat;

  double getUserCurrentLng() => userCurrentLng;

  // void userSignedOut() {
  //   this.signedIn = false;
  //   this.userName = 'User Name';
  //   this.userId = 'User ID';
  //   notifyListeners();
  // }

  Future<void> userSignedOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: unnecessary_this
    this.signedIn = false;
    // ignore: unnecessary_this
    this.userName = 'User Name';
    // ignore: unnecessary_this
    this.userId = 'User ID';
    notifyListeners();
  }
}
