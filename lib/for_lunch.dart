//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/restaurant.dart';
import 'main_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
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
  String radius = "3000";

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  ///lat and lon values hard coded for now.

  // double latitude = 44.034294;
  // double longitude = -88.547745;

  ///for textfields not implemented
  final radiusTEC = TextEditingController();

  ///listview
  List<Restaurant> roles = [];

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);

    ///gets nearby places.
    getNearbyPlaces(radius) async {
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

      setState(() {
        var i = result.length - 1;
        while (i > 0) {
          var temp = Restaurant(
              name: values['results'][i]['name'],
              lat: values['results'][i]['geometry']['location']['lat'],
              lng: values['results'][i]['geometry']['location']['lng']);
          roles.add(temp);
          i--;
        }
      });
      mainModel.addRestaurant(roles);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Whats For Lunch'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              getNearbyPlaces(radiusTEC.text);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),

            ///text field for radius with hint text sense this one is not obvious what the user needs to fill out
            child: TextFormField(
                controller: radiusTEC,
                decoration: const InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Radius: ',
                    hintText: 'i.e: 4 m')),
          ),
          const Padding(
            ///text
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
          ),
          Card(
            child: Container(
              color: Colors.black12,
              height: 30,
              child: const Center(
                child: Text(
                    'Instructions: Scroll through to remove Restaurants you do not want in the spin'),
              ),
            ),
          ),
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
                color: Colors.blue,
                thickness: 2,
              );
            },
          )),
        ],
      ),
    );
  }
}
