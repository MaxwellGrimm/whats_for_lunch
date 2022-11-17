import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/num_restaurants_model.dart';
import 'main_model.dart';
import 'memories.dart';
import 'change_password_widget.dart';

enum MenuItem { myMemories, signOut }

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
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          PopupMenuButton<MenuItem>(
              //this figures out which navigation they are going to
              onSelected: (value) {
                if (value == MenuItem.myMemories) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Memories()), //navigating to the My Memories page
                  );
                } else if (value == MenuItem.signOut) {
                  //needs to log out here
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: MenuItem.myMemories,
                      child: Text('My Memories'),
                    ),
                    const PopupMenuItem(
                        value: MenuItem.signOut, child: Text('Log out')),
                  ]),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Username:    '),
                Text(mainModel
                    .getCurrentUserName()
                    .toString()) //this will be replaced with the actual user's username
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Password:    '),
                Text(
                    '********') //this will be replaced with the actual user's password
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) => //this takes you to the Change Passoword Page
                                  ChangePasswordWidget()), //needs to pass in the model for information --user information--
                    );
                  },
                  child: const Text(
                    'change password?',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Allow Location:    '),
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
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Home Address:    '),
                Text(
                    '800 Algoma Blvd, Oshkosh, WI 54901') //this will be replaced with the actual user's address
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 55.0),
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
