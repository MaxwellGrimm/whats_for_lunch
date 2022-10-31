import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'restaurant.dart';

class MainModel extends ChangeNotifier {
  MainModel();

  List<Restaurant> resturantsNear = [];
}
