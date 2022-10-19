import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';

class Memories extends StatelessWidget {
  const Memories({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memories'),
      ),
      body: const Center(
        child: Text('I remeber'),
      ),
    );
  }
}