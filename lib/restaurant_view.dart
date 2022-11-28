import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'directions.dart';
import 'main_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';

// ignore: must_be_immutable
class RestaurantView extends StatelessWidget {
  String restaurantName;
  double numStars = 3.5;
  double fracStars = .5;
  RestaurantView({super.key, this.restaurantName = ''});

  //These are the names of the reviews that will probably end up being in the
  //google cloud database
  List<String> reviewNames = [
    'Mary Loo',
    'Jane Doe',
    'Ronald Regan',
    'Karen McKaren'
  ];

  //These are the reviews related with the names that will probably end up
  //being in the google cloud database
  List<String> reviews = [
    'Great Food!',
    'Hard to find the enterance',
    'God Bless America',
    'The worst place I have ever eaten!'
  ];

  //controller for a google map instance, will need to change the api to the
  //google directions
  late GoogleMapController mapController;

  //either the address given for the user or the users location
  final LatLng _start = const LatLng(44.001, -87.000);
  //This will be filled in the with restaurants latitude and longitude
  final LatLng _end = const LatLng(44.040743157104785, -88.54306697845459);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final String startAddress = '1010 Wright Street, Oshkosh WI';
  final String restaurantAddress = '1863 Jackson St, Oshkosh WI';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurantName),
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
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    onTap: (ma) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapView(
                                _start.latitude,
                                _start.longitude,
                                _end.latitude,
                                _end.longitude,
                                startAddress,
                                restaurantAddress)),
                      );
                    },
                    initialCameraPosition: CameraPosition(
                      target: _end,
                      zoom: 13.0,
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
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Address',
                              style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 26,
                                  color: Colors.white))),
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: Text('2038 Main St. Oshkosh WI, 54901',
                            style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 20,
                                color: Colors.white))),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Align(
                          alignment: Alignment.topLeft,
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
                            Text('${numStars.ceil()} Stars',
                                style: const TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                            for (int i = 0; i < numStars.ceil(); i++) ...<Icon>{
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
                        subtitle: Text(reviews[index]),
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
