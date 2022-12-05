//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import 'nearby_response.dart';

///list of states
const List<String> states = [
  "AK",
  "AL",
  "AR",
  "AS",
  "AZ",
  "CA",
  "CO",
  "CT",
  "DC",
  "DE",
  "FL",
  "GA",
  "GU",
  "HI",
  "IA",
  "ID",
  "IL",
  "IN",
  "KS",
  "KY",
  "LA",
  "MA",
  "MD",
  "ME",
  "MI",
  "MN",
  "MO",
  "MS",
  "MT",
  "NC",
  "ND",
  "NE",
  "NH",
  "NJ",
  "NM",
  "NV",
  "NY",
  "OH",
  "OK",
  "OR",
  "PA",
  "PR",
  "RI",
  "SC",
  "SD",
  "TN",
  "TX",
  "UT",
  "VA",
  "VI",
  "VT",
  "WA",
  "WI",
  "WV",
  "WY"
];

///listview
class restaurants {
  String locations;
  restaurants({required this.locations});
}

class ForLunch extends StatefulWidget {
  const ForLunch({super.key});

  @override
  State<ForLunch> createState() => _ForLunchState();
}

class _ForLunchState extends State<ForLunch> {

  ///for the google places.
  String apiKey = "AIzaSyBDc-kxnaAiAdfxARv4AFpkB5ankImFj0I";
  String radius = "3000";

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

   ///lat and lon values hard coded for now.
  double latitude = 31.5111093;
  double longitude = 74.279664;

  ///for textfields not implemented
  TextEditingController Address = TextEditingController();
  TextEditingController Zip = TextEditingController();
  TextEditingController Radius = TextEditingController();

  ///drop down values
  String dropdownvalue = states.first;

   ///gets nearby places.
   getNearbyPlaces() async {
     var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=restaurant&key=$apiKey');
    var response = await http.get(url);
    final values = jsonDecode(response.body);
    final List result = values['results'];
    print(result);
    // setState(() {});


  }

  

  ///listview
  List<restaurants> roles = [
    restaurants(locations: 'Culvers'),
    restaurants(locations: 'Mammas'),
    restaurants(locations: 'Nikos'),
    restaurants(locations: 'Panda Express'),
    restaurants(locations: 'Pizza Hut'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whats For Lunch'),   
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),

            ///text field for address
            child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Address: ')),
          ),
          Padding(

              ///drop down button as a form field
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
              child: DropdownButtonFormField<String>(
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                decoration: const InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'State'),

                ///setting the value for drop down
                value: dropdownvalue,

                ///putting list of states in drop down
                onChanged: (String? value) {
                  setState(() {
                    dropdownvalue = value!;
                  });
                },
                items: states.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),

            ///text field for zip
            child: TextField(
                decoration: InputDecoration(
              fillColor: Colors.black12,
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Zip: ',
            )),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),

            ///text field for radius with hint text sense this one is not obvious what the user needs to fill out
            child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Radius: ',
                    hintText: 'i.e: 4 mi')),
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
            itemCount: roles.length,

            itemBuilder: (BuildContext context, int index) {
              return ListTile(

                  ///setting the title subtitle and trailing
                  title: Text(roles[index].locations),
                  trailing: IconButton(
                    onPressed: () {
                      ///remove
                      roles.removeAt(index);
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
