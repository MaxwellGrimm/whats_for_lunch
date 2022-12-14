// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:whats_for_lunch/for_lunch.dart';
import 'main_model.dart';

// ignore: slash_for_doc_comments
/**
Name:Scott Webber
Date:12/14/2022
Description:This page allows for pulls and addition to the database. A user if
signed in can make a memory about a restaurant and save it to our database.
They can see all of their saved memories. They have the restaurant name, stars,
and comments about their experience.
Bugs: There are no bugs that we know of at this time.
Reflection: I think the styling of the memories went really well. I did find it
a lot harder than origionally anticipated to add user photos. We were using
firebase and there are ways to store images using the cloud. However, they had
maximum sizes for the images that could be saved and retrieved dynamically. A
person taking a picture with their camera greatly over exceeds the image size
that is allowed. 
*/
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
            //this is the add a memories button
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
                                      //text feild for inputing restaurant name
                                      TextFormField(
                                        controller: restaurantsTEC,
                                        decoration: const InputDecoration(
                                          labelText: 'Restaurants',
                                          icon: Icon(Icons.restaurant),
                                        ),
                                      ),
                                      //text field for inputing a rating
                                      TextFormField(
                                        controller: ratingTEC,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Rating',
                                          icon: Icon(Icons.star),
                                        ),
                                      ),
                                      //text form for entering comments
                                      TextFormField(
                                        controller: commentsTEC,
                                        decoration: const InputDecoration(
                                          labelText: 'Comments',
                                          icon: Icon(Icons.message),
                                        ),
                                      ),
                                      //the submit button that will add the memory
                                      ElevatedButton(
                                          child: const Text("Submit"),
                                          onPressed: () {
                                            //this will add the memory to the database under the userId which is saved in the main model
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
            //this is a display for all of the memories that are queried from firestore
            //they are queried based on userID which is unique so everyone has there own
            //set of personal memories
            StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection('memories')
                  .where('userID', isEqualTo: mainModel.userId)
                  .snapshots(), //get only user memories
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
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Rajdhani',
                                                    color: Colors.blue),
                                              ),
                                              Text(
                                                // ignore: prefer_interpolation_to_compose_strings
                                                "Comments: " +
                                                    thisMemory['comments'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Rajdhani',
                                                    color: Colors.blue),
                                              ),
                                              Text(
                                                "Memory From: ${thisMemory['date'].toDate()}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Rajdhani',
                                                    color: Colors.blue),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                //this displays the stars based on the rating saved in the database
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

//this method takes in the database instance, and all the values from the text fields at the top
//It then adds the memory to the database under the collection memories
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
