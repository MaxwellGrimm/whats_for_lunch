// ignore_for_file: use_key_in_widget_constructors, unused_import, prefer_const_declarations, prefer_final_fields, prefer_initializing_formals

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
Name:Maxwell Grimm
Date:12/14/2022
Description:This is a page loaded to represent a restaurant. It loads a map 
based off of the lat and lng grabbed by the api. It also grabs the name, and
if possible grabs the stars. The bottom shows the reviews that others have
posted on the app about that restaurant. The reviews are posted in a list view.
If you tap on the marker of the restaurant you can then get the directions from
your current location to the restaurant.
Bugs: The stars are not dynamic. For some reason not all of the api results have
a value for the number of stars. 
Reflection: This took a while to implement because we did not have the api 
results until very recently. 
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
    //adds a marker for the user and the restaurant 
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
    MainModel mainModel = Provider.of<MainModel>(context);
    var db = mainModel.getDatabase();

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
                            //this code displays the number of stars based on
                            //the num stars given
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
                //this code grabs the memories from the db based off of 
                //the restaurant name
                StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('memories')
                        .where('restaurant',
                            isEqualTo: RestaurantView.restaurantName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // ignore: avoid_print
                        print(snapshot.error);
                        return const Text("Error");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text("loading reviews");
                      }
                      List<QueryDocumentSnapshot> currMemory =
                          snapshot.data!.docs;
                      if (currMemory.isNotEmpty) {
                        return Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                var thisMemory = currMemory[index];
                                return ListTile(
                                  title: Text(thisMemory['comments']),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: currMemory.length),
                        );
                      } else {
                        //this will be displayed if the query returns empty
                        //just some text so the user isn't confused
                        return const Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                    'Seems like no one has posted a text review for this restaurant on our app yet!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Rajdhani'))));
                      }
                    })
              ]),
        ));
  }
}
