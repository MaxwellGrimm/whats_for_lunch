import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';
import 'RestaurantView.dart';

class SpinPage extends StatelessWidget {
  const SpinPage({super.key});

  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('What\'s For Lunch'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Spin(pretend this is a wheele'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RestaurantView()),
            );
          },
        ),
      ),
    );
  }
}
