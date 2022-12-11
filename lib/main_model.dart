import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'num_restaurants_model.dart';
import 'restaurant.dart';

class MainModel extends ChangeNotifier {
  MainModel();

  List<Restaurant> restaurantsNear = [];
  final List<NumRestaurant> _restaruant = [];

  double? userCurrentLat = 44.0;
  double? userCurrentLng = -88.0;

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

  double? getUserCurrentLat() => userCurrentLat;

  void setUserCurrentLat(double? lat) {
    userCurrentLat = lat;
  }

  double? getUserCurrentLng() => userCurrentLng;

  void setUserCurrentLng(double? lng) {
    userCurrentLng = lng;
  }

  void removeAt(int index) {
    restaurantsNear.removeAt(index);
    notifyListeners();
  }

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

  bool addNumRestaruant({required NumRestaurant restaruant}) {
    try {
      _restaruant.add(restaruant);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool getRestaruant({required String restaurantName}) {
    bool restaurantExist = false;
    _restaruant.forEach((restaurant) {
      if (restaurant.getName() == restaurantName) {
        restaurantExist = true;
      }
    });
    return restaurantExist;
  }

  int updateNumPicked({required String restaurantName}) {
    int num = 1;
    bool restaurantExist = true;
    // ignore: unrelated_type_equality_checks
    if (getRestaruant(restaurantName: restaurantName) == restaurantExist) {
      _restaruant.forEach((restaurant) {
        if (restaurant.getName() == restaurantName) {
          num = restaurant.getNumPicked() + 1;
          restaurant.setNumPicked(num: num);
        }
      });
    }
    notifyListeners();
    return num;
  }

  int numRestaurant() {
    return _restaruant.length;
  }

  int getNumPickedRestaurant({required int at}) {
    NumRestaurant restaurant = _restaruant[at];
    return restaurant.getNumPicked();
  }

  String getNameRestaurant({required int at}) {
    NumRestaurant restaurant = _restaruant[at];
    return restaurant.getName();
  }
}
