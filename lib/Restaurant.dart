// ignore_for_file: file_names

// ignore: unused_import
import 'package:flutter/material.dart';

// ignore: slash_for_doc_comments
/**
Name:Maxwell Grimm 
Date:12/14/2022
Description:This is the class for a restaurant that is used primarily in the 
main model
Bugs: none that I know of
Reflection: This was created when I first made the app and I think it was a good
abstraction I wish we could have implemented things faster so we could have 
more time to fix bugs and make more features
*/
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
