import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';
import 'Memories.dart';
import 'my_profile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: const Text('My Profile'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyProfileWidget()), //may need const again
                );
              },
            ), //My Profile button
            ElevatedButton(
              child: const Text('My Memories'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Memories()),
                );
              },
            ), //My Memories button
            ElevatedButton(
              child: const Text('Log Out'),
              onPressed: null,
              //),//this is the Center widget
            ),
          ], //children of column
        ),
      ),
    );
  }
}
