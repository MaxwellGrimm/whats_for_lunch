import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:whats_for_lunch/num_restaurants_model.dart';
import 'package:whats_for_lunch/sign_in_page.dart';
import 'main_model.dart';
import 'memories.dart';
import 'change_password_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: slash_for_doc_comments
/**
Name: Xee Lo
Date: Decemeber 13, 2021
Description: displays users information like username and address, 
also asks for permission for user's location
this is where users could also change their password
they also navigate to Memories from here 
Bugs: N/a 
Reflection: learned how to display info and ask for location
*/
enum MenuItem { myMemories, signOut, signIn }

class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({super.key});

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  String? _currentAddress; //stores the current address that is readable
  Position?
      _currentPosition; //stores the position of the user in latitude and longtitude

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    var db = mainModel.getDatabase();
    // ignore: unused_local_variable
    CollectionReference numRestaurantDB = db.collection('NumResturantPicked');
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (mainModel.getCurrentUserName() ==
              'User Name') //if the username is not signed in
            PopupMenuButton<MenuItem>(
                //they have the option to sign in
                onSelected: (value) {
                  if (value == MenuItem.signIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: MenuItem.signIn,
                        child: Text('Sign In'),
                      ),
                    ]),
          if (mainModel.getCurrentUserName() !=
              'User Name') //if the user is signed in
            PopupMenuButton<MenuItem>(
                //this figures out which navigation they are going to
                onSelected: (value) {
                  if (value == MenuItem.myMemories) {
                    //they have the option to go to memories or sign out of the application
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              // ignore: prefer_const_constructors
                              Memories()), //navigating to the My Memories page
                    );
                  } else if (value == MenuItem.signOut) {
                    mainModel.userSignedOut();
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        //navigates to memories
                        value: MenuItem.myMemories,
                        child: Text('My Memories'),
                      ),
                      const PopupMenuItem(
                          //signout
                          value: MenuItem.signOut,
                          child: Text('Sign out')),
                    ]),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //displays the username of the user
                const Text('Username:    '),
                Text(mainModel.getCurrentUserName().toString())
              ],
            ),
          ),
          Padding(
            //displays the password
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [Text('Password:    '), Text('********')],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) => //this takes you to the Change Passoword Page
                                  ChangePasswordWidget()), //needs to pass in the model for information --user information--
                    );
                  }, //displays the change password
                  child: const Text(
                    'change password?',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
          Row(
            //displays location and asks if you allow it
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('   Allow Location:    '),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _getCurrentPosition(mainModel);
                  },
                  child: const Text('ALLOW'),
                ),
              ),
            ],
          ),
          Padding(
            //displays home address
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Home Address:    '),
                Text(mainModel.getUserAddress() ?? "")
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 55.0),
            child: Text('Recently Selected:'),
          ),
          Expanded(
              child: ListView.builder(
                  //displays the restaurant name and the number of times it was picked
                  itemCount: mainModel.numRestaurant(),
                  itemBuilder: (context, index) => ListTile(
                        title: Text(
                          mainModel.getNameRestaurant(at: index),
                        ),
                        subtitle: Text(mainModel
                            .getNumPickedRestaurant(at: index)
                            .toString()),
                      )))
        ],
      ),
    );
  }

//lets the customer share their location
//this information will find nearest restaurants around customer
//asks user if they are willing to share thier location with the app
  Future<bool> allowLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //this popups the snackbar to tell the user to enable their location for the app
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

//gets current position of the user
  //required MainModel mainModel - the main model storing all the data
  Future<void> _getCurrentPosition(MainModel mainModel) async {
    final hasPermission = await allowLocation();

    if (!hasPermission)
      return; //returns the given position the user is at and calls that _getAddressFromLatLng to convert it into a readable address
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!, mainModel);
    }).catchError((e) {
      debugPrint(e);
    });
  }

//gets the address from the current position
  //required MainModel mainModel - the main model storing all the data
  //required Position position - the current position of the user in longtitude and latitude
  Future<void> _getAddressFromLatLng(
      Position position, MainModel mainModel) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = // grabs the address and stores it into currentAddress
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });

    mainModel.setUserAddress(
        address:
            _currentAddress); //calls the mainModel class setUserAddress to the current address and stores it there
  }
}
