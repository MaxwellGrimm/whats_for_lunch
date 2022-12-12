// ignore_for_file: use_key_in_widget_constructors, unused_import, prefer_const_declarations, prefer_final_fields, prefer_initializing_formals

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/secrets.dart';
import 'main_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// ignore: slash_for_doc_comments
/**
Name:
Date:
Description:
Bugs: 
Reflection: 
*/
// ignore: must_be_immutable
class RestaurantView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables

  static String restaurantName = '';

  static double startLat = 44.001;

  static double startLng = -88.000;

  static double endLat = 44.040743157104785;

  static double endLng = -88.54306697845459;

  static double numStars = 4.5;

  RestaurantView({
    startLat,
    startLng,
    endLat,
    endLng,
    restaurantName,
  }) {
    RestaurantView.restaurantName = restaurantName;
    RestaurantView.startLat = startLat;
    RestaurantView.startLng = startLng;
    RestaurantView.endLat = endLat;
    RestaurantView.endLng = endLng;
  }

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  //These are the names of the reviews that will probably end up being in the
  List<String> reviewNames = [
    'Mary Loo',
    'Jane Doe',
    'Ronald Regan',
    'Karen McKaren'
  ];

  //These are the reviews related with the names that will probably end up
  List<String> reviews = [
    'Great Food!',
    'Hard to find the enterance',
    'God Bless America',
    'The worst place I have ever eaten!'
  ];

  //controller for a google map instance, will need to change the api to the
  Completer<GoogleMapController> _controller = Completer();
  final startLocation = LatLng(RestaurantView.endLat, RestaurantView.endLng);

  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(40.00, -88.00),
    zoom: 14,
  );
  //either the address given for the user or the users location
  //This will be filled in the with restaurants latitude and longitude
  // ignore: unused_field
  final LatLng _end = const LatLng(44.040743157104785, -88.54306697845459);

  final Set<Marker> _markers = {};

  List<LatLng> latLen = [
    LatLng(RestaurantView.startLat, RestaurantView.startLng),
    LatLng(RestaurantView.endLat, RestaurantView.endLng)
  ];

  // ignore: must_call_super, annotate_overrides
  void initState() {
    _markers.add(Marker(
      markerId: const MarkerId('Start Location'),
      position: latLen[0],
      infoWindow: const InfoWindow(
        title: 'Current Location',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    _markers.add(Marker(
      markerId: const MarkerId('Restaurant Location'),
      position: latLen[1],
      infoWindow: const InfoWindow(
        title: 'Restaurant Location',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(RestaurantView.restaurantName),
          backgroundColor: Colors.red,
          toolbarHeight: 40,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  //cuts page in half taking the app bar into account
                  height: (MediaQuery.of(context).size.height - 80) / 2.ceil(),
                  //waits for the maps creation and then makes a controller for it
                  child: SafeArea(
                    child: GoogleMap(
                      //given camera position
                      initialCameraPosition: _kGoogle,
                      // on below line we have given map type
                      mapType: MapType.normal,
                      // specified set of markers below
                      markers: _markers,
                      // on below line we have enabled location
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      // on below line we have enabled compass location
                      compassEnabled: true,
                      // displayed google map
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        controller.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(target: startLocation, zoom: 16)));
                      },
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  //uses the other half without the map
                  height: 130,
                  color: const Color.fromARGB(100, 54, 47, 47),
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              'Tap the marker then choose Direction/Maps for directions to the restaurant.',
                              style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 20,
                                  color: Colors.white))),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Reviews',
                              style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 26,
                                  color: Colors.white))),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${RestaurantView.numStars.ceil()} Stars',
                                style: const TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                            for (int i = 0;
                                i < RestaurantView.numStars.ceil();
                                i++) ...<Icon>{
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 20,
                              ),
                            },
                          ]),
                    ),
                  ]),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: reviews.length,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text('${reviewNames[index]}: '),
                        trailing: Text(reviews[index]),
                        tileColor: const Color.fromARGB(80, 200, 200, 200),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(20, 30))),
                        selectedTileColor:
                            const Color.fromARGB(255, 246, 157, 150),
                        selected: false,
                      );
                    },
                  ),
                ),
              ]),
        ));
  }
}
