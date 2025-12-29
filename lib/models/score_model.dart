class FootballMatch {
  String? id;
  final String team1Name;
  final String team2Name;
  final int team1Score;
  final int team2Score;
  final bool isRunning;
  final String winnerTeam;

  FootballMatch({
    this.id,
    required this.team1Name,
    required this.team2Name,
    required this.team1Score,
    required this.team2Score,
    required this.isRunning,
    required this.winnerTeam,

  });

  //sent data to firebase
  Map<String,dynamic> toJson(){
    return{
      'id': id,
      'team1_name': team1Name,
      'team2_name': team2Name,
      'team1_score': team1Score,
      'team2_score': team2Score,
      'is_running': isRunning,
      'winner_team': winnerTeam,
    };
  }

  //receive data from firebase
  factory FootballMatch.fromJson(Map<String,dynamic> jsonData){
    return FootballMatch(
      id: jsonData['id'],
      team1Name: jsonData['team1_name'],
      team2Name: jsonData['team2_name'],
      team1Score: jsonData['team1_score'],
      team2Score: jsonData['team2_score'],
      isRunning: jsonData['is_running'],
      winnerTeam: jsonData['winner_team'],
    );
  }

}