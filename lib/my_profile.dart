import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/restaruants_model.dart';
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Username:'),
              Text(
                  'user_name') //this will be replaced with the actual user's username
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Password:'),
              Text(
                  '********') //this will be replaced with the actual user's password
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Allow Location:'),
              ElevatedButton(
                onPressed: null,
                child: Text('yes'),
              ), //buttons will need to be active
              ElevatedButton(onPressed: null, child: Text('no'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Home Address:'),
              Text(
                  '123 address st, Oshkosh, WI 54901') //this will be replaced with the actual user's address
            ],
          ),
          Expanded(
              flex: 10,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: restaruant
                      .length, //should not be hard coded, will need to be changed
                  itemBuilder: ((context, index) {
                    return ListTile(
                        title: Text(restaruant[index]
                            .name!), //this will need to call the getRestauant({required int at})
                        subtitle: Text(restaruant[index].numPicked!.toString()),
                        tileColor: const Color.fromARGB(255, 255, 255, 255));
                  }))),
        ],
      ),
    );
  }
}
