import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: const Center(
       child: Text('Give me your SSN'),
      ),
    );
  }
}