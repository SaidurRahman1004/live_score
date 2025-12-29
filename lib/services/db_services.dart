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
            Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return FootballMatch.fromJson(data);
          }).toList(),
        );
  }

  //add data
  Future<void> addFootballMatchData(FootballMatch footballMatch) async {
    await _firestore.collection('football').add(footballMatch.toJson());
  }

  //dellet data
  Future<void> deleteFootballMatchData(String docId) async {
    await _firestore.collection('football').doc(docId).delete();
  }
}
