import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';

class RestaurantView extends StatelessWidget {
  const RestaurantView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
      ),
      body: const Center(
       child: Text('Resturant'),
      ),
    );
  }
}
