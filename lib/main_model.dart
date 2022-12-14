import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'num_restaurants_model.dart';
import 'restaurant.dart';

// ignore: slash_for_doc_comments
/**
Name: Max Grimm, Xee Lo
Date:
Description:
-Stores and retrieves user's information such as UserName, UserId, and current readable address
-Stores, updates, and retrieves all the restaurants that was chosen to spin 
-Stores updates, and retrieves the user's longitude and latitude 
-Stores updates, and retrieves a string message that explains how to populate restaurants near you
-Stores updates, and retrieves all the number of restaurants the user has picked to spin. 
Bugs: 
Reflection: 
*/
class MainModel extends ChangeNotifier {
  MainModel();

  List<Restaurant> restaurantsNear =
      []; //stores the restaurants that are near you depending on the radius
  final List<NumRestaurant> _restaruant =
      []; //stores all the number of times the restaurant was picked when it spun

  double? userCurrentLat = 44.0;
  double? userCurrentLng = -88.0;
  String? userAddress; //the user's readable address

  var db = FirebaseFirestore.instance;

  bool signedIn = false;
  String? userName = 'User Name';
  String? userId = 'User ID';
  int radius = 1;
  String areRestaurantsPopulated =
      'Before you can spin you must hit the search to find restaurants near you!';

//sets the current user
//String? userName - the username
// String? userId - userID
  void setCurrentUser(String? userName, String? userId) {
    signedIn = true;
    this.userName = userName;
    this.userId = userId;
    notifyListeners();
  }

//retrieves the radius
// return - the radius
  int getRadius() {
    return radius;
  }

//sets the radius
//rad - the radius to be set
  void setRadius(rad) {
    radius = rad;
  }

//retrieves the string that holds the message
// returns - the message to be displayed
  String getAreRestaurantsPopulated() {
    return areRestaurantsPopulated;
  }

//sets the desired message
//String message - the message
  void setAreRestaurantsPopulated(String message) {
    areRestaurantsPopulated = message;
  }

//returns the database
  getDatabase() {
    return db;
  }

//adds the list of restaurants to the restaurantsNear list
  void addRestaurant(List<Restaurant> restaurant) {
    restaurantsNear = restaurant;
    notifyListeners();
  }

//retrieves the user's username
//returns - the user's username in a string
  String? getCurrentUserName() {
    return userName;
  }

//retrieves user's ID
//returns - the user's ID in a string
  String? getCurrentUserId() {
    return userId;
  }

//checks to see if the user is signed in
// returns - false or true
  bool isUserSignedIn() {
    return signedIn;
  }

//retrieves the user's latitude
//returns - double latitude
  double? getUserCurrentLat() => userCurrentLat;

//sets the user's current latitude
//double? lat - latitude value
  void setUserCurrentLat(double? lat) {
    userCurrentLat = lat;
  }

//retrieves the user's longitude
//returns - double longitude
  double? getUserCurrentLng() => userCurrentLng;

//sets the user's current longitude
//double? lng - longtitude value
  void setUserCurrentLng(double? lng) {
    userCurrentLng = lng;
  }

//removes the restaurant that was at the desired index
//int index - the desired index
  void removeAt(int index) {
    restaurantsNear.removeAt(index);
    notifyListeners();
  }

//signs the user out from firebase
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

//addes the restaurant to the list along with the number of times it was picked
//required NumRestaurant restaruant - the NumRestaurant object to be added to the list
//returns - true or false if it was added
  bool addNumRestaruant({required NumRestaurant restaruant}) {
    try {
      _restaruant.add(restaruant);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

//gets the restaurant that you want to find and returns true if exist or else false
//required String restaurantName - the name of the restaurant
//returns - true or false if it exists in the list
  bool getRestaruant({required String restaurantName}) {
    bool restaurantExist = false;
    // ignore: avoid_function_literals_in_foreach_calls
    _restaruant.forEach((restaurant) {
      //goes through the numRestaurant list to find the restaurant
      if (restaurant.getName() == restaurantName) {
        restaurantExist = true;
      }
    });
    return restaurantExist;
  }

//updates the number of times the restaurant was picked with the restaurant's name
//required String restaurantName - name of the restaurant to be updated
//returns - the number of times it was picked
  int updateNumPicked({required String restaurantName}) {
    int num = 1;
    bool restaurantExist = true;
    // ignore: unrelated_type_equality_checks
    if (getRestaruant(restaurantName: restaurantName) == restaurantExist) {
      // ignore: avoid_function_literals_in_foreach_calls
      _restaruant.forEach((restaurant) {
        //goes through the entire list to check the list and updates the number of times it was picked
        if (restaurant.getName() == restaurantName) {
          num = restaurant.getNumPicked() + 1;
          restaurant.setNumPicked(num: num);
        }
      });
    }
    notifyListeners();
    return num;
  }

//retrieves the length of the numRestaurant list
// returns - length of restaurant
  int numRestaurant() {
    return _restaruant.length;
  }

//retrieves the number of times the restaurant was picked with the specified index
// used for the listview to display it
//required int at - the index of that restaurant number to display
  int getNumPickedRestaurant({required int at}) {
    NumRestaurant restaurant = _restaruant[at];
    return restaurant.getNumPicked();
  }

//retrieves the name of the restaurant was picked with the specified index
// used for the listview to display it
//required int at - the index of that restaurant to display
  String getNameRestaurant({required int at}) {
    NumRestaurant restaurant = _restaruant[at];
    return restaurant.getName();
  }

//sets the user's user address
//required String? address - string of the desired restaurant to be found
  // ignore: body_might_complete_normally_nullable
  String? setUserAddress({required String? address}) {
    userAddress = address;
  }

//retrieves the user's readable address
//returns - userAddress or empty string
  String? getUserAddress() {
    return userAddress ?? "";
  }
}
