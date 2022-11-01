import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';

class Memories extends StatelessWidget {
  const Memories({super.key});

  Widget build(BuildContext context) {
    ///will eventually not be ard coded and pulled from data
    List<String> memoriesListTemp = [
      'Great Food!',
      'Hard to find the enterance',
      'God Bless America',
      'The worst place I have ever eaten!',
      'This was okay',
      'I will never come back',
      'I did enjoy this quite a bit'
    ];
    double numStars = 3.5;

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Memories'),
        ),
        body: GridView.builder(
            itemCount: memoriesListTemp.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: .5,
            ),

            ///is just a card right now but would like images to be pulled from data
            itemBuilder: (context, index) => Card(
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
                            "Memory: $index ${memoriesListTemp[index]}"),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///will apply the correct amount of stars currently is not pulled from db
                            for (int i = 0; i < numStars.ceil(); i++) ...<Icon>{
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
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    ///will eventurally have the picture, rating, date, location shown in pop up
                                    children: [
                                      Text(
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Rajdhani',
                                              color: Colors.blue),
                                          "Memory: $index ${memoriesListTemp[index]}"),
                                      const Text(
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Rajdhani',
                                              color: Colors.blue),
                                          "Memory from: 10-10-2010"),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ///will apply the correct amount of stars currently is not pulled from db
                                          for (int i = 0;
                                              i < numStars.ceil();
                                              i++) ...<Icon>{
                                            const Icon(Icons.star,
                                                color: Colors.yellow, size: 30),
                                          }
                                        ],
                                      )
                                    ])
                              ],
                            ),
                          );
                        })),
                  ),
                )));
  }
}
