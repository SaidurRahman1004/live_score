import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_score/models/score_model.dart';

class DbServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Fetch data from firebase
  Stream<List<FootballMatch>> getFootballMatchData() {
    return _firestore
        .collection('football')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return FootballMatch.fromJson(doc.id, doc.data());
          }).toList(),
        );
  }

  //add data
  Future<void> addFootballMatchData(FootballMatch footballMatch) async {
    await _firestore.collection('football').add(footballMatch.toJson());
  }

  //Update data
  Future<void> updateFootballMatchData(FootballMatch footballMatch) async{
    await _firestore.collection('football').doc(footballMatch.id).update(footballMatch.toJson());
  }


  //dellet data
  Future<void> deleteFootballMatchData(String docId) async {
    await _firestore.collection('football').doc(docId).delete();
  }
}
