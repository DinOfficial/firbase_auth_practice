class MatchModel {
  final String team1Name;
  final String team2Name;
  final int team1Score;
  final int team2Score;
  final bool isRunning;
  final String winnerTeam;

  MatchModel({
    required this.team1Name,
    required this.team2Name,
    required this.team1Score,
    required this.team2Score,
    required this.isRunning,
    required this.winnerTeam,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      team1Name: json['team1Name'],
      team2Name: json['team2Name'],
      team1Score: json['team1Score'],
      team2Score: json['team2Score'],
      isRunning: json['isRunning'],
      winnerTeam: json['winnerTeam'],
    );
  }
}
