import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';

///list of states
const List<String> list = [
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
  ///textfields
  TextEditingController Address = TextEditingController();
  TextEditingController Zip = TextEditingController();
  TextEditingController Radius = TextEditingController();

  ///drop down values
  String dropdownvalue = list.first;

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
            child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Address: ')),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
              child: DropdownButtonFormField<String>(
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                decoration: const InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'State'),
                value: dropdownvalue,
                onChanged: (String? value) {
                  setState(() {
                    dropdownvalue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
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
            child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Radius: ',
                    hintText: 'i.e: 4 mi')),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
              child: Text(
                  'Scroll through to remove Restaurants you do not want in the spin')),
          Expanded(

              ///listView
              child: ListView.separated(
            itemCount: roles.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(

                  ///setting the title subtitle and trailing
                  title: Text(roles[index].locations),
                  trailing: const Icon(Icons.delete));
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
