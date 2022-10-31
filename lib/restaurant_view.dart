import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class RestaurantView extends StatelessWidget {
  String restaurantName;
  double numStars = 3.5;
  double fracStars = .5;
  RestaurantView({super.key, this.restaurantName = ''});

  int reviewsIndex = 0;
  List<String> reviewNames = [
    'Mary Loo',
    'Jane Doe',
    'Ronald Regan',
    'Karen McKaren'
  ];
  List<String> reviews = [
    'Great Food!',
    'Hard to find the enterance',
    'God Bless America',
    'The worst place I have ever eaten!'
  ];

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(44.034294, -88.547745);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurantName),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.height - 80) / 2.ceil(),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 13.0,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height - 80) / 2.ceil(),
                  color: Colors.white,
                  child: Column(children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Address',
                            style: TextStyle(
                                fontFamily: 'Rajdhani', fontSize: 30))),
                    const Align(
                        alignment: Alignment.center,
                        child: Text('2038 Main St. Oshkosh WI, 54901',
                            style: TextStyle(
                                fontFamily: 'Rajdhani', fontSize: 26))),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Reviews',
                            style: TextStyle(
                                fontFamily: 'Rajdhani', fontSize: 30))),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${numStars.ceil()} Stars',
                                style: const TextStyle(
                                    fontFamily: 'Rajdhani', fontSize: 30)),
                            for (int i = 0; i < numStars.ceil(); i++) ...<Icon>{
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 30),
                            }
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
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ]),
        ));
  }
}
