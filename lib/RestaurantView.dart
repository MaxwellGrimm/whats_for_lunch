import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';

class RestaurantView extends StatelessWidget {
  String restaurantName;
  RestaurantView({super.key, this.restaurantName = ''});

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurantName),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 300, child: Text(restaurantName)),
            ]));
  }
}
