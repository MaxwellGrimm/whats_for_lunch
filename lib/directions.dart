import 'dart:async';
import 'package:flutter/material.dart';
import 'auth/secrets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapView extends StatefulWidget {
  static double startLat = 44.0;
  static double startLng = -88.0;
  static double endLat = 45.0;
  static double endLng = -88.0;
  static String startAddress = '';
  static String endAddress = '';
  const MapView(
      {required double startLat,
      required double startLng,
      required double endLat,
      required double endLng,
      required String startAddress,
      required String endAddress,
      Key? key})
      : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // created controller to display Google Maps
  Completer<GoogleMapController> _controller = Completer();
  //on below line we have set the camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(40, -88),
    zoom: 14,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};

  // list of locations to display polylines
  List<LatLng> latLen = [
    LatLng(MapView.startLat, MapView.startLng),
    LatLng(MapView.endLat, MapView.endLng),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // declared for loop for various locations
    _markers.add(
        // added markers
        Marker(
      markerId: MarkerId(0.toString()),
      position: latLen[0],
      infoWindow: InfoWindow(
        title: 'current location',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    _markers.add(Marker(
      markerId: MarkerId(1.toString()),
      position: latLen[1],
      infoWindow: InfoWindow(
        title: MapView.endAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    setState(() {
      _createPolylines(
          MapView.startLat, MapView.startLng, MapView.endLat, MapView.endLng);
    });
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBV9aerOFm5L8p6VYFvdoNLjpBjRO-HLek', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        latLen.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: latLen,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        // title of app
        title: Text("What\'s For Lunch"),
      ),
      body: Container(
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
            // on below line we have added polylines
            polylines: Set<Polyline>.of(polylines.values),
            // displayed google map
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}

// import 'dart:math' show cos, sqrt, asin;

// class MapView extends StatefulWidget {
//   static double startLat = 40.00;
//   static double startLng = -88.00;
//   static double endLat = 40.00;
//   static double endLng = -88.00;
//   static String startAddress = '';
//   static String endAddress = '';

//   MapView({
//     required double startLa,
//     required double startLo,
//     required double endLa,
//     required double endLo,
//     required String startAddy,
//     required String endAddy,
//   }) {
//     startLat = startLa;
//     startLng = startLo;
//     endLat = endLa;
//     endLng = endLo;
//     startAddress = startAddy;
//     endAddress = endAddy;
//   }
//   @override
//   _MapViewState createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   CameraPosition _initialLocation =
//       CameraPosition(target: LatLng(40.00, -88.00));
//   late GoogleMapController mapController;

//   late Position _currentPosition;
//   String _currentAddress = '';

//   final startAddressController = TextEditingController();
//   final destinationAddressController = TextEditingController();

//   final startAddressFocusNode = FocusNode();
//   final desrinationAddressFocusNode = FocusNode();

//   String _startAddress = MapView.startAddress;
//   String _destinationAddress = MapView.endAddress;
//   String? _placeDistance;

//   Set<Marker> markers = {};

//   late PolylinePoints polylinePoints;
//   Map<PolylineId, Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];

//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   // Method for retrieving the current location
//   _getCurrentLocation() async {
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) async {
//       setState(() {
//         _currentPosition = position;
//         print('CURRENT POS: $_currentPosition');
//         mapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(position.latitude, position.longitude),
//               zoom: 18.0,
//             ),
//           ),
//         );
//       });
//       await _getAddress();
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   // Method for retrieving the address
//   _getAddress() async {
//     try {
//       List<Placemark> p = await placemarkFromCoordinates(
//           _currentPosition.latitude, _currentPosition.longitude);

//       Placemark place = p[0];

//       setState(() {
//         _currentAddress =
//             "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
//         MapView.startAddress = _currentAddress;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   // Method for calculating the distance between two places
//   Future<bool> _calculateDistance() async {
//     try {
//       // Retrieving placemarks from addresses
//       List<Location> startPlacemark =
//           await locationFromAddress(MapView.startAddress);
//       List<Location> destinationPlacemark =
//           await locationFromAddress(MapView.endAddress);

//       // Use the retrieved coordinates of the current position,
//       // instead of the address if the start position is user's
//       // current position, as it results in better accuracy.
//       double startLatitude = MapView.startAddress == _currentAddress
//           ? _currentPosition.latitude
//           : startPlacemark[0].latitude;

//       MapView.startLat = startLatitude;

//       double startLongitude = MapView.startAddress == _currentAddress
//           ? _currentPosition.longitude
//           : startPlacemark[0].longitude;

//       MapView.startLng = startLongitude;

//       double destinationLatitude = destinationPlacemark[0].latitude;
//       MapView.endLat = destinationLatitude;
//       double destinationLongitude = destinationPlacemark[0].longitude;
//       MapView.endLng = destinationLongitude;

//       String startCoordinatesString = '($startLatitude, $startLongitude)';
//       String destinationCoordinatesString =
//           '($destinationLatitude, $destinationLongitude)';

//       // Start Location Marker
//       Marker startMarker = Marker(
//         markerId: MarkerId(startCoordinatesString),
//         position: LatLng(startLatitude, startLongitude),
//         infoWindow: InfoWindow(
//           title: 'Start $startCoordinatesString',
//           snippet: MapView.startAddress,
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       );

//       // Destination Location Marker
//       Marker destinationMarker = Marker(
//         markerId: MarkerId(destinationCoordinatesString),
//         position: LatLng(destinationLatitude, destinationLongitude),
//         infoWindow: InfoWindow(
//           title: 'Destination $destinationCoordinatesString',
//           snippet: _destinationAddress,
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       );

//       // Adding the markers to the list
//       markers.add(startMarker);
//       markers.add(destinationMarker);

//       print(
//         'START COORDINATES: ($startLatitude, $startLongitude)',
//       );
//       print(
//         'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
//       );

//       // Calculating to check that the position relative
//       // to the frame, and pan & zoom the camera accordingly.
//       double miny = (startLatitude <= destinationLatitude)
//           ? startLatitude
//           : destinationLatitude;
//       double minx = (startLongitude <= destinationLongitude)
//           ? startLongitude
//           : destinationLongitude;
//       double maxy = (startLatitude <= destinationLatitude)
//           ? destinationLatitude
//           : startLatitude;
//       double maxx = (startLongitude <= destinationLongitude)
//           ? destinationLongitude
//           : startLongitude;

//       double southWestLatitude = miny;
//       double southWestLongitude = minx;

//       double northEastLatitude = maxy;
//       double northEastLongitude = maxx;

//       // Accommodate the two locations within the
//       // camera view of the map
//       mapController.animateCamera(
//         CameraUpdate.newLatLngBounds(
//           LatLngBounds(
//             northeast: LatLng(northEastLatitude, northEastLongitude),
//             southwest: LatLng(southWestLatitude, southWestLongitude),
//           ),
//           100.0,
//         ),
//       );

//       // Calculating the distance between the start and the end positions
//       // with a straight path, without considering any route
//       // double distanceInMeters = await Geolocator.bearingBetween(
//       //   startLatitude,
//       //   startLongitude,
//       //   destinationLatitude,
//       //   destinationLongitude,
//       // );

//       await _createPolylines(startLatitude, startLongitude, destinationLatitude,
//           destinationLongitude);

//       double totalDistance = 0.0;

//       // Calculating the total distance by adding the distance
//       // between small segments
//       for (int i = 0; i < polylineCoordinates.length - 1; i++) {
//         totalDistance += _coordinateDistance(
//           polylineCoordinates[i].latitude,
//           polylineCoordinates[i].longitude,
//           polylineCoordinates[i + 1].latitude,
//           polylineCoordinates[i + 1].longitude,
//         );
//       }

//       setState(() {
//         _placeDistance = totalDistance.toStringAsFixed(2);
//         print('DISTANCE: $_placeDistance km');
//       });

//       return true;
//     } catch (e) {
//       print(e);
//     }
//     return false;
//   }

//   // Formula for calculating distance between two coordinates
//   // https://stackoverflow.com/a/54138876/11910277
//   double _coordinateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   // Create the polylines for showing the route between two places
//   _createPolylines(
//     double startLatitude,
//     double startLongitude,
//     double destinationLatitude,
//     double destinationLongitude,
//   ) async {
//     polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       'AIzaSyBV9aerOFm5L8p6VYFvdoNLjpBjRO-HLek', // Google Maps API Key
//       PointLatLng(startLatitude, startLongitude),
//       PointLatLng(destinationLatitude, destinationLongitude),
//       travelMode: TravelMode.transit,
//     );

//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }

//     PolylineId id = PolylineId('poly');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.red,
//       points: polylineCoordinates,
//       width: 3,
//     );
//     polylines[id] = polyline;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _createPolylines(
//         MapView.startLat, MapView.startLng, MapView.endLat, MapView.endLng);
//     _getCurrentLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Container(
//       height: height,
//       width: width,
//       child: Scaffold(
//         key: _scaffoldKey,
//         body: Stack(
//           children: <Widget>[
//             // Map View
//             GoogleMap(
//               markers: Set<Marker>.from(markers),
//               initialCameraPosition: _initialLocation,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               mapType: MapType.normal,
//               zoomGesturesEnabled: true,
//               zoomControlsEnabled: false,
//               polylines: Set<Polyline>.of(polylines.values),
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//             ),
//             // Show zoom buttons
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     ClipOval(
//                       child: Material(
//                         color: Colors.blue.shade100, // button color
//                         child: InkWell(
//                           splashColor: Colors.blue, // inkwell color
//                           child: SizedBox(
//                             width: 50,
//                             height: 50,
//                             child: Icon(Icons.add),
//                           ),
//                           onTap: () {
//                             mapController.animateCamera(
//                               CameraUpdate.zoomIn(),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ClipOval(
//                       child: Material(
//                         color: Colors.blue.shade100, // button color
//                         child: InkWell(
//                           splashColor: Colors.blue, // inkwell color
//                           child: SizedBox(
//                             width: 50,
//                             height: 50,
//                             child: Icon(Icons.remove),
//                           ),
//                           onTap: () {
//                             mapController.animateCamera(
//                               CameraUpdate.zoomOut(),
//                             );
//                           },
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             // Show the place input fields & button for
//             // showing the route
//             SafeArea(
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white70,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20.0),
//                       ),
//                     ),
//                     width: width * 0.9,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           const Text(
//                             'Places',
//                             style: TextStyle(fontSize: 20.0),
//                           ),
//                           const SizedBox(height: 10),
//                           SizedBox(height: 10),
//                           SizedBox(height: 10),
//                           Visibility(
//                             visible: _placeDistance == null ? false : true,
//                             child: Text(
//                               'DISTANCE: $_placeDistance km',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           ElevatedButton(
//                             onPressed: (_startAddress != '' &&
//                                     _destinationAddress != '')
//                                 ? () async {
//                                     startAddressFocusNode.unfocus();
//                                     desrinationAddressFocusNode.unfocus();
//                                     setState(() {
//                                       if (markers.isNotEmpty) markers.clear();
//                                       if (polylines.isNotEmpty)
//                                         polylines.clear();
//                                       if (polylineCoordinates.isNotEmpty)
//                                         polylineCoordinates.clear();
//                                       _placeDistance = null;
//                                     });

//                                     _calculateDistance().then((isCalculated) {
//                                       if (isCalculated) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                                 'Distance Calculated Sucessfully'),
//                                           ),
//                                         );
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                                 'Error Calculating Distance'),
//                                           ),
//                                         );
//                                       }
//                                     });
//                                   }
//                                 : null,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'Show Route'.toUpperCase(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20.0,
//                                 ),
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.red,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Show current location button
//             SafeArea(
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
//                   child: ClipOval(
//                     child: Material(
//                       color: Colors.orange.shade100, // button color
//                       child: InkWell(
//                         splashColor: Colors.orange, // inkwell color
//                         child: SizedBox(
//                           width: 56,
//                           height: 56,
//                           child: Icon(Icons.my_location),
//                         ),
//                         onTap: () {
//                           mapController.animateCamera(
//                             CameraUpdate.newCameraPosition(
//                               CameraPosition(
//                                 target: LatLng(
//                                   _currentPosition.latitude,
//                                   _currentPosition.longitude,
//                                 ),
//                                 zoom: 18.0,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
