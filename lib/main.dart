// ignore_for_file: prefer_const_constructors, unnecessary_new

/*
*Names: Max Grimm, Scott Webber, Xee    , Micheal Meisenburg
*Description: This is the code for the basic bottom tabbed navigation.
*Bugs: None yet
*Date: 10/19/2022
*Version: 1.0.0
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SpinPage.dart';
import 'RestaurantView.dart';
import 'UserProfile.dart';
import 'Memories.dart';
import 'MainModel.dart';
import 'ForLunch.dart';

void main() {
  runApp(ChangeNotifierProvider(
      child: const WhatsForLunch(), create: (context) => MainModel()));
}

class WhatsForLunch extends StatelessWidget {
  const WhatsForLunch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s For Lunch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<NavigationModel>(
        child: Navigation(),
        create: (context) => NavigationModel(),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Navigation extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var currentTab = [
    Consumer<MainModel>(builder: (context, mainmodel, child) {
      return ForLunch();
    }),
    Consumer<MainModel>(builder: (context, mainmodel, child) {
      return SpinPage();
    }),
    Consumer<MainModel>(builder: (context, mainmodel, child) {
      return const UserProfile();
    }),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NavigationModel>(context);
    return Scaffold(
      body: currentTab[provider.getCurrentIndex()],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.getCurrentIndex(),
        onTap: (index) {
          provider.setCurrentIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Spin',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}

class NavigationModel with ChangeNotifier {
  int _currentIndex = 1;

  int getCurrentIndex() {
    return _currentIndex;
  }

  setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
