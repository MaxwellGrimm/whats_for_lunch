//import 'dart:js_util';

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_for_lunch/for_lunch.dart';

//this class keeps track of how many times the user has picked a restaurant

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
