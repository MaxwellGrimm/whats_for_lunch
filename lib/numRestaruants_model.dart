import 'package:flutter/material.dart';

class NumRestaruant {
  String? name;
  int? numPicked;

  NumRestaruant({this.name, this.numPicked});

  String getName() {
    return name!;
  }

  int getNumPicked() {
    return numPicked!;
  }
}

class RestaruantModel extends ChangeNotifier {
  final List<NumRestaruant> _restaruant = [];

  bool addCluan({required NumRestaruant restaruant}) {
    try {
      _restaruant.add(restaruant);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  NumRestaruant getRestaruant({required int at}) {
    NumRestaruant restaruant = _restaruant[at];
    return restaruant;
  }

  int numResturant() {
    return _restaruant.length;
  }
}
