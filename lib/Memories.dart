// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:whats_for_lunch/for_lunch.dart';
import 'main_model.dart';

class Memories extends StatelessWidget {
  const Memories({super.key});

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    var db = mainModel.getDatabase();
    //CollectionReference userMemories = db.collection('memories');



    final restaurantsTEC = TextEditingController();
    final ratingTEC = TextEditingController();
    final commentsTEC = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Memories'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Add Memory"),
                            content: Stack(
                              fit: StackFit.loose,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                        controller: restaurantsTEC,
                                        decoration: const InputDecoration(
                                          labelText: 'Restaurants',
                                          icon: Icon(Icons.restaurant),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: ratingTEC,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Rating',
                                          icon: Icon(Icons.star),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: commentsTEC,
                                        decoration: const InputDecoration(
                                          labelText: 'Comments',
                                          icon: Icon(Icons.message),
                                        ),
                                      ),
                                      ElevatedButton(
                                          child: const Text("Submit"),
                                          onPressed: () {
                                            _addMemory(
                                                db,
                                                restaurantsTEC.text,
                                                int.parse(ratingTEC.text),
                                                commentsTEC.text,
                                                mainModel.userId,
                                                mainModel.userName);
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      });
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('memories').where('userID', isEqualTo: mainModel.userId).snapshots(), //get only user memories 
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // ignore: avoid_print
                  print(snapshot.error);
                  return const Text("Error");
                } else if (snapshot.connectionState == 
                    ConnectionState.waiting) {
                  return const Text("loading");
                }
                List<QueryDocumentSnapshot> currMemory = snapshot.data!.docs;
                //var dbQuery = db.collection('memories').where('userID' == mainModel.userId);
                return Expanded(
                  child: GridView.builder(
                      itemCount: currMemory.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 1,
                      ),

                      ///is just a card right now but would like images to be pulled from data
                      itemBuilder: (context, index) {
                        var thisMemory = currMemory[index];
                        return Card(
                          color: Colors.redAccent,
                          child: InkResponse(
                            ///will be just an image eventually, once tapping image you then get more info
                            child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  thisMemory['restaurant'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Rajdhani',
                                        color: Colors.white),
                                    ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0;
                                        i < thisMemory['rating'].ceil();
                                        i++) ...<Icon>{
                                      const Icon(Icons.star,
                                          color: Colors.yellow, size: 10),
                                    }
                                  ],
                                )
                              ],
                            )),
                            onTap: () => showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    content: Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,

                                            ///will eventurally have the picture, rating, date, location shown in pop up
                                            children: [
                                              Text(
                                                thisMemory['restaurant'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Rajdhani',
                                                      color: Colors.blue),
                                                  ),
                                              Text(
                                                // ignore: prefer_interpolation_to_compose_strings
                                                "Comments: " + thisMemory['comments'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Rajdhani',
                                                      color: Colors.blue),
                                                  ),
                                                  Text(
                                                "Memory From: ${thisMemory['date'].toDate()}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Rajdhani',
                                                      color: Colors.blue),
                                                  ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          thisMemory['rating']
                                                              
                                                              .ceil();
                                                      i++) ...<Icon>{
                                                    const Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 10),
                                                  }
                                                ],
                                              )
                                            ])
                                      ],
                                    ),
                                  );
                                })),
                          ),
                        );
                      }),
                );
              },
            )
          ],
        ));
  }

  Future<void> _addMemory(var db, var restaurant, var rating, var comments,
      var userID, var userName) {
    return db.collection('memories').add({
      'comments': comments,
      "date": DateTime.now(),
      "rating": rating,
      "restaurant": restaurant,
      'userID': userID
    });
  }
}
