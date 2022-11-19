// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
import 'restaurant_view.dart';
import 'sign_in_page.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:flutter_animated_icons/useanimations.dart';
import 'package:lottie/lottie.dart';

enum MenuItem { signIn, signOut }

// ignore: must_be_immutable
class SpinPage extends StatefulWidget {
  SpinPage({super.key});

  @override
  State<SpinPage> createState() => _SpinPageState();
}

class _SpinPageState extends State<SpinPage>
    with SingleTickerProviderStateMixin {
  //needed to use a BehaviorSubject<int> because we needed the .value method
  final wheelController = BehaviorSubject<int>();

  //These are the names of the restaurants that *will* be pulled by an api
  List<String> fortuneItems = [
    'McDonalds',
    'Dairy Queen',
    'Boba',
    'Mammas Noodles',
    'Pizza Hut'
  ];

  late AnimationController _controller;

  @override
  void initState() {
    // Initializing our controller
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 800,
      ),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    // Disposing controller
    // when its not needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('What\'s For Lunch')),
          actions: [
            if (mainModel.getCurrentUserName() == 'User Name')
              PopupMenuButton<MenuItem>(
                  //this figures out which navigation they are going to
                  onSelected: (value) {
                    if (value == MenuItem.signIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SignInPage()), //navigating to the My Memories page
                      );
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: MenuItem.signIn,
                          child: Text('Sign In'),
                        ),
                      ]),
            if (mainModel.getCurrentUserName() != 'User Name')
              PopupMenuButton<MenuItem>(
                  //this figures out which navigation they are going to
                  onSelected: (value) {
                    if (value == MenuItem.signOut) {
                      mainModel.userSignedOut();
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: MenuItem.signOut,
                          child: Text('Sign Out'),
                        ),
                      ]),
          ]),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: IconButton(
                splashRadius: 50,
                iconSize: 100,
                onPressed: () {
                  if (_controller.status == AnimationStatus.dismissed) {
                    _controller.reset();
                    _controller.animateTo(0.6);
                  } else {
                    _controller.reverse();
                  }
                },
                icon: Lottie.asset(Icons8.drag_left, controller: _controller),
              ),
              /*child: Text('Swipe to Spin',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rajdhani')),*/
            ),
            if (mainModel.getCurrentUserName() != 'User Name')
              Text('Signed In As: ${mainModel.getCurrentUserName()}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rajdhani')),
            FittedBox(
              child: FortuneBar(
                  styleStrategy: const UniformStyleStrategy(
                    color: Color.fromARGB(80, 253, 115, 91),
                    borderColor: Colors.red,
                    borderWidth: 3,
                  ),
                  visibleItemCount: 1,
                  indicators: [],
                  height: 400,
                  fullWidth: true,
                  // physics: CircularPanPhysics(
                  //   duration: const Duration(seconds: 0),
                  //   curve: Curves.decelerate,
                  // ),
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
                                restaurantName: fortuneItems[
                                    (wheelController.value == 0)
                                        ? fortuneItems.length - 1
                                        : wheelController.value - 1])),
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
                      FortuneItem(
                          style: const FortuneItemStyle(
                              borderWidth: 3,
                              borderColor: Colors.red,
                              color: Color.fromARGB(80, 251, 142, 161)),
                          child: Text(fortuneItems[i],
                              style: const TextStyle(
                                  fontFamily: 'Rajdhani', fontSize: 30))),
                    },
                  ]),
            ),
          ]),
    );
  }
}
