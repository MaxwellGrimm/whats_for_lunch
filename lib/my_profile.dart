import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/numRestaruants_model.dart';
import 'MainModel.dart';

class MyProfileWidget extends StatefulWidget {
  MyProfileWidget({super.key});

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  final List<NumRestaruant> restaruant = [
    //will need to make a model and pass it through
    NumRestaruant(name: 'Arbys', numPicked: 46),
    NumRestaruant(name: 'Pizza Hut', numPicked: 12),
    NumRestaruant(name: 'McDonalds', numPicked: 2),
    NumRestaruant(name: 'Panda Express', numPicked: 8),
    NumRestaruant(name: 'Culvers', numPicked: 14),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Username:  ', textAlign: TextAlign.left),
                Text('user_name',
                    textAlign: TextAlign
                        .left) //this will be replaced with the actual user's username
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Password:  ', textAlign: TextAlign.left),
                Text('********',
                    textAlign: TextAlign
                        .left) //this will be replaced with the actual user's password
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Allow Location:  ', textAlign: TextAlign.left),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: allowLocation,
                    child: const Text('yes'),
                  ),
                ), //buttons will need to be active
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: disallowLocation, child: const Text('no')),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Home Address:  ', textAlign: TextAlign.left),
                Text('123 address st, Oshkosh, WI 54901',
                    textAlign: TextAlign
                        .left) //this will be replaced with the actual user's address
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text('Recently Selected:'),
          ),
          Expanded(
              flex: 10,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: restaruant
                    .length, //should not be hard coded, will need to be changed
                itemBuilder: ((context, index) {
                  return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${restaruant[index].name!}:      ',
                            textAlign: TextAlign.left,
                          ),
                          Text(restaruant[index].numPicked!.toString())
                        ],
                      ), //this will need to call the getRestauant({required int at})
                      //subtitle: Text(restaruant[index].numPicked!.toString()),
                      tileColor: const Color.fromARGB(255, 255, 255, 255));
                }),
              ))
        ],
      ),
    );
  }

//lets the customer share their location
//this information will find nearest restaurants around customer
  bool allowLocation() {
    return true;
  }

//the customer will not be sharing their location
  bool disallowLocation() {
    return false;
  }
}
