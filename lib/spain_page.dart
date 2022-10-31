// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
import 'restaurant_view.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class SpinPage extends StatelessWidget {
  SpinPage({super.key});

  //needed to use a BehaviorSubject<int> because we needed the .value method 
  //that the StreamController does not provide
  final wheelController = BehaviorSubject<int>();

  //These are the names of the restaurants that *will* be pulled by an api
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
                  //This sets what whill happen when the wheele is spun
                  onFling: () {
                    wheelController.add(Random().nextInt(fortuneItems.length));
                    //This delays the changing of screens long enough for the 
                    //wheel to finish spinning
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
                  //this uses a forloop to make the FortuneItems along with
                  //the array items
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
