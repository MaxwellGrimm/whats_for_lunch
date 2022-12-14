// ignore_for_file: file_names

// ignore: unused_import
import 'package:flutter/material.dart';

// ignore: slash_for_doc_comments
/**
Name:
Date:
Description:
Bugs: 
Reflection: 
*/
class Restaurant {
  String name = '';
  String? address;
  String? reviews;
  double? stars = 0.0;
  double lat = 44.00;
  double lng = -88.00;
  Restaurant({
    required this.name,
    this.address,
    this.reviews,
    this.stars,
    required this.lat,
    required this.lng,
  });

  String getName() {
    return name;
  }

  double getLat() {
    return lat;
  }

  double getLng() {
    return lng;
  }

  double? getStar() {
    return stars;
  }
}
