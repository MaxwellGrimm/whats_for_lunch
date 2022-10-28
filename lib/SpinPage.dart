import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';
import 'RestaurantView.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class SpinPage extends StatelessWidget {
  SpinPage({super.key});
  final StreamController<int> wheeleController = StreamController<int>();

  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('What\'s For Lunch')),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Spin The Wheel',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rajdhani')),
            SizedBox(
              height: 300,
              child: FortuneWheel(
                physics: CircularPanPhysics(
                  duration: const Duration(seconds: 0),
                  curve: Curves.decelerate,
                ),
                onFling: () {
                  wheeleController.add(Random().nextInt(10));
                  Timer(const Duration(seconds: 6), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RestaurantView()),
                    );
                  });
                },
                selected: wheeleController.stream,
                items: const [
                  FortuneItem(child: Text('McDonalds')),
                  FortuneItem(child: Text('Dairy Queen')),
                  FortuneItem(child: Text('Pizza Hut')),
                  FortuneItem(child: Text('Burger King')),
                  FortuneItem(child: Text('@Pizza')),
                  FortuneItem(child: Text('Olive Garden')),
                  FortuneItem(child: Text('Jimmy Johns')),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text('Spin(pretend this is a wheele'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RestaurantView()),
                );
              },
            ),
          ]),
    );
  }
}
