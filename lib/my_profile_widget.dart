import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/num_restaurants_model.dart';
import 'package:whats_for_lunch/sign_in_page.dart';
import 'main_model.dart';
import 'memories.dart';
import 'change_password_widget.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MenuItem { myMemories, signOut, signIn }

class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({super.key});

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  /* final List<NumRestaruant> restaruant = [
    //will need to make a model and pass it through
    NumRestaruant(name: 'Arbys', numPicked: 46),
    NumRestaruant(name: 'Pizza Hut', numPicked: 12),
    NumRestaruant(name: 'McDonalds', numPicked: 2),
    NumRestaruant(name: 'Panda Express', numPicked: 8),
    NumRestaruant(name: 'Culvers', numPicked: 14),
  ];*/

  LocationData?
      locationData; //stores location that user have shared with the app

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (mainModel.getCurrentUserName() == 'User Name')
            PopupMenuButton<MenuItem>(
                //this figures out which navigation they are going to
                onSelected: (value) {
                  if (value == MenuItem.signIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: MenuItem.signIn,
                        child: Text('Sign In'),
                      ),
                    ]),
          if (mainModel.getCurrentUserName() != 'User Name')
            PopupMenuButton<MenuItem>(
                //this figures out which navigation they are going to
                onSelected: (value) {
                  if (value == MenuItem.myMemories) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Memories()), //navigating to the My Memories page
                    );
                  } else if (value == MenuItem.signOut) {
                    mainModel.userSignedOut();
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: MenuItem.myMemories,
                        child: Text('My Memories'),
                      ),
                      const PopupMenuItem(
                          value: MenuItem.signOut, child: Text('Sign out')),
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
                Text(mainModel.getCurrentUserName().toString())
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('Password:    '), Text('********')],
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
                    '800 Algoma Blvd, Oshkosh, WI 54901') // this will be replaced with the actual user's address
              ], //locationData.toString() - this should replace this address but since we are connected to the emulator
              //it doesnt retrieve the location... I feel that if we had a physical phone it would grab the location
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 55.0),
            child: Text('Recently Selected:'),
          ),
          Expanded(
              flex: 10,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('NumRestaurantPicked')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text('No data yet'));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error!'));
                    } else {
                      return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => ListTile(
                                    title: Text(
                                      snapshot.data!.docs[index]
                                          ['restaurantName'],
                                    ), //Text('Oreos'),
                                    subtitle: Text(snapshot
                                        .data!.docs[index]['numPicked']
                                        .toString()),
                                  )));
                    }
                  }) /*ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: restaruant.length,
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
              )*/
              )
        ],
      ),
    );
  }

//lets the customer share their location
//this information will find nearest restaurants around customer
//asks user if they are willing to share thier location with the app
  Future<bool> allowLocation() async {
    Location location = Location();
    bool serviceEnabled;

    serviceEnabled =
        await location.serviceEnabled(); //if user wants to enable location
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService(); //will request service
      if (!serviceEnabled) {
        debugPrint('Location Denied once');
      }
    }

    locationData = await location.getLocation(); //retrieves location from user
    return true;
  }

//the customer will not be sharing their location
  bool disallowLocation() {
    return false;
  }
}
