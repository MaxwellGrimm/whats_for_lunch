import 'package:flutter/material.dart';
class Restaurant {
  String name = '';
  String? address;
  String? reviews;
  double? stars;
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
}
