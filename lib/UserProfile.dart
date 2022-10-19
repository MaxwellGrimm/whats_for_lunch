import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';
import 'Memories.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('My Memories'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Memories()),
            );
          },
        ),
      ),
    );
  }
}
