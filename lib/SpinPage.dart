// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';
import 'RestaurantView.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class SpinPage extends StatelessWidget {
  SpinPage({super.key});

  final wheelController = BehaviorSubject<int>();

  List<String> fortuneItems = [
    'McDonalds',
    'Dairy Queen',
    'Boba',
    'Mammas Noodles',
    'Pizza Hut'
  ];

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
                    wheelController.add(Random().nextInt(fortuneItems.length));
                    Timer(const Duration(seconds: 6), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantView(
                                restaurantName:
                                    fortuneItems[wheelController.value])),
                      );
                    });
                  },
                  animateFirst: false,
                  selected: wheelController.stream,
                  items: [
                    for (int i = 0;
                        i < fortuneItems.length;
                        i++) ...<FortuneItem>{
                      FortuneItem(child: Text(fortuneItems[i])),
                    },
                  ]),
            ),
          ]),
    );
  }
}
