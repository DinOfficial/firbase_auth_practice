import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:getx/match_model.dart';

class MatchProvider extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final List<MatchModel> _list = [];

  // Future<QuerySnapshot<Map<String, dynamic>>> getMatch() async {
  //   final result = await firebaseFirestore.collection('football').get();
  //   return result;
  // }

  List<MatchModel> get list => _list;

  Future<void> getMatches() async {
    _list.clear();
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
        .collection('football')
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      _list.add(MatchModel.fromJson(doc.data()));
    }
    notifyListeners();
  }

}
