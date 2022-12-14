//import 'dart:js_util';

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_for_lunch/for_lunch.dart';

// ignore: slash_for_doc_comments
/**
Name: Xee Lo
Date: Decemeber 12, 2022
Description: This is where it stores the number of times the restaurant was picked
Bugs: N/A
Reflection: helps stores information
*/
class NumRestaurant {
  String? name; //name of restaurant
  int? numPicked; //number of times it was picked

//contructor for NumRestaurant
  NumRestaurant({this.name, this.numPicked});

//this returns the name of the restaurant
//returns - the name of restaurant
  String getName() {
    return name!;
  }

//returns the number of times it was picked
//returns - the number of times it was picked
  int getNumPicked() {
    return numPicked!;
  }

//sets the number of times the restaurant
//required int num - the number that needs to be updated
  void setNumPicked({required int num}) {
    numPicked = numPicked! + 1;
  }
}
