import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/for_lunch.dart';
import 'main_model.dart';

class Memories extends StatelessWidget {
  Memories({super.key});

  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    var db = mainModel.getDatabase();
    CollectionReference userMemories = db.collection('memories');

    ///will eventually not be ard coded and pulled from data
    // List<String> memoriesListTemp = [
    //   'Great Food!',
    //   'Hard to find the enterance',
    //   'God Bless America',
    //   'The worst place I have ever eaten!',
    //   'This was okay',
    //   'I will never come back',
    //   'I did enjoy this quite a bit'
    // ];
    // double numStars = 3.5;

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
              stream: userMemories.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
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
                        childAspectRatio: .5,
                      ),

                      ///is just a card right now but would like images to be pulled from data
                      itemBuilder: (context, index) {
                        var thisMemory = currMemory[index];
                        return Card(
                          color: Colors.blue,
                          child: InkResponse(
                            ///will be just an image eventually, once tapping image you then get more info
                            child: Center(
                                child: Column(
                              children: [
                                Text(
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Rajdhani',
                                        color: Colors.white),
                                    thisMemory[index].restaruant),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ///will apply the correct amount of stars currently is not pulled from db
                                    for (int i = 0;
                                        i < thisMemory[index].rating.ceil();
                                        i++) ...<Icon>{
                                      const Icon(Icons.star,
                                          color: Colors.yellow, size: 30),
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
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Rajdhani',
                                                      color: Colors.blue),
                                                  thisMemory[index].restaruant),
                                              Text(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Rajdhani',
                                                      color: Colors.blue),
                                                  thisMemory[index].date),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ///will apply the correct amount of stars currently is not pulled from db
                                                  for (int i = 0;
                                                      i <
                                                          thisMemory[index]
                                                              .rating
                                                              .ceil();
                                                      i++) ...<Icon>{
                                                    const Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 30),
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
