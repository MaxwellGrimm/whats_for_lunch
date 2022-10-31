import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainModel.dart';

class Memories extends StatefulWidget {
  const Memories({super.key});

  @override
  State<Memories> createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Memories'),
        ),
        body: GridView.builder(
            itemCount: 100,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) => Card(
                  child: InkResponse(
                    child: Text("$index"),
                    onTap: ()=> print(index),
                  ),
                )));
  }
}
