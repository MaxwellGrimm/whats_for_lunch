//import 'dart:html';
// ignore_for_file: depend_on_referenced_packages, unused_import, use_build_context_synchronously

// ignore: slash_for_doc_comments
/**
Name:Scott Weber, Michael, Maxwell Grimm 
Date:12/14/2022
Description:This is the page where you search for the restaurants arround your
current location. 
Bugs: You have to push the search button a few times for it to get the api 
results. I am not sure why.
Reflection: 
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/restaurant.dart';
import 'main_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import 'nearby_response.dart';

class ForLunch extends StatefulWidget {
  const ForLunch({super.key});

  @override
  State<ForLunch> createState() => _ForLunchState();
}

class _ForLunchState extends State<ForLunch> {
  double lat = 0.00;
  double lng = 0.00;
  Position? _currentPosition;
  String? error;

//this handles all options for device and app location access
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  ///for the google places.
  String apiKey = "AIzaSyBV9aerOFm5L8p6VYFvdoNLjpBjRO-HLek";

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  List<Restaurant> roles = [];

  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);

    ///gets nearby places.
    getNearbyPlaces(radius) async {
      radius = radius * 1000;
      _getCurrentPosition();
      double? latitude = _currentPosition?.latitude;
      double? longitude = _currentPosition?.longitude;
      mainModel.setUserCurrentLat(latitude);
      mainModel.setUserCurrentLng(longitude);
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=restaurant&key=$apiKey');
      var response = await http.get(url);
      final values = jsonDecode(response.body);
      final List result = values['results'];
      //print(result);
      //print(values['results'][0]['geometry']['location']['lat']);

//this adds the restaurant to the main model list
      var i = result.length - 1;
      while (i > 0) {
        var temp = Restaurant(
            name: values['results'][i]['name'],
            lat: values['results'][i]['geometry']['location']['lat'],
            lng: values['results'][i]['geometry']['location']['lng']);
        roles.add(temp);
        i--;
      }
      mainModel.addRestaurant(roles);
      mainModel.setAreRestaurantsPopulated('');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('What\'s For Lunch'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              getNearbyPlaces(_currentSliderValue);
            },
          )
        ],
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 20, 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Radius:",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontFamily: 'Rajdhani')))),
          Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 5.0),

              ///text field for radius with hint text sense this one is not obvious what the user needs to fill out
              child: Slider(
                value: _currentSliderValue,
                max: 6,
                divisions: 6,
                label: '${_currentSliderValue.round()} km',
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              )),
          const Padding(
            ///text
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
          ),
          Card(
            child: Container(
              color: Colors.black12,
              height: 50,
              child: const Center(
                child: Text(
                    'Instructions: Set the radius and hit the search icon. Then scroll through and remove any restaurants you don\'t want in the spin.'),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Text(mainModel.getAreRestaurantsPopulated(),
                  style: const TextStyle(fontSize: 20))),
          Expanded(

              ///listView
              child: ListView.separated(
            itemCount: mainModel.restaurantsNear.length,

            itemBuilder: (BuildContext context, int index) {
              return ListTile(

                  ///setting the title subtitle and trailing
                  title: Text(mainModel.restaurantsNear[index].name),
                  trailing: IconButton(
                    onPressed: () {
                      ///remove
                      mainModel.removeAt(index);
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete),
                  ));
            },

            ///for the divider between each element
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.red,
                thickness: 1,
              );
            },
          )),
        ],
      ),
    );
  }
}
