import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'restaurant.dart';

class MainModel extends ChangeNotifier {
  MainModel();

  List<Restaurant> resturantsNear = [];

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

  getDatabase(){
    return db;
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

  // void userSignedOut() {
  //   this.signedIn = false;
  //   this.userName = 'User Name';
  //   this.userId = 'User ID';
  //   notifyListeners();
  // }

  Future<void> userSignedOut() async {
    await FirebaseAuth.instance.signOut();
    this.signedIn = false;
    this.userName = 'User Name';
    this.userId = 'User ID';
    notifyListeners();
  }
}
