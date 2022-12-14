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
  String? name;
  int? numPicked;

  NumRestaurant({this.name, this.numPicked});

  String getName() {
    return name!;
  }

  int getNumPicked() {
    return numPicked!;
  }

  void setNumPicked({required int num}) {
    numPicked = numPicked! + 1;
  }
}
