import 'package:get/get.dart';
import 'package:live_score/models/score_model.dart';

import '../services/db_services.dart';

class MatchController extends GetxController {
  final DbServices _dbServices = DbServices();
  var matchList = <FootballMatch>[].obs;
  @override
  void onInit(){
    super.onInit();
    _dbServices.getFootballMatchData().listen(
            (matchData){
          matchList.value = matchData;
        }
    );
  }

  //addmatch
  Future<void> addMatch(FootballMatch match) async {
    await _dbServices.addFootballMatchData(match);
  }

  //update match
  Future<void> updateMatch(FootballMatch match) async {
    await _dbServices.updateFootballMatchData(match);
  }
  //delete match
  void deleteMatch(String docId){
    _dbServices.deleteFootballMatchData(docId);

  }




}