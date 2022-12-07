// ignore_for_file: prefer_const_constructors, unnecessary_new, unused_import

/*
*Names: Max Grimm, Scott Webber, Xee    , Micheal Meisenburg
*Description: This is the main file for Whats For Lunch. Right now we just have
  the basic elements of our GUI. There will be more refining and changes as we
  continue to move forward.
*Bugs: None yet
*Date: 10/19/2022
*Version: 1.0.0
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'spin_page.dart';
import 'restaurant_view.dart';
import 'Memories.dart';
import 'main_model.dart';
import 'my_profile_widget.dart';
import 'for_lunch.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      child: const WhatsForLunch(), create: (context) => MainModel()));
}

///Description: This is the main widget that is a consumer of the NavigationModel
class WhatsForLunch extends StatelessWidget {
  const WhatsForLunch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s For Lunch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
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

///Sets the files that will be the main tabs for navigation
class _NavigationState extends State<Navigation> {
  var currentTab = [
    Consumer<MainModel>(builder: (context, mainmodel, child) {
      return ForLunch();
    }),
    Consumer<MainModel>(builder: (context, mainmodel, child) {
      return SpinPage();
    }),
    Consumer<MainModel>(builder: (context, mainmodel, child) {
      return MyProfileWidget();
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
            icon: new Icon(Icons.cyclone),
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

///This is the model that assists with the tabbed navigation
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
