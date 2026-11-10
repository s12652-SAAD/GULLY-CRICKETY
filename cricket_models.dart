enum ExtraType { none, wide, noBall, bye, legBye }

enum WicketType {
  bowled, caught, lbw, runOut, stumped, hitWicket,
  retiredOut, obstructingField, other
}

class Batter {
  final String id;
  final String name;
  int runs;
  int balls;
  int fours;
  int sixes;
  bool out;

  Batter({required this.id, required this.name, this.runs = 0,
    this.balls = 0, this.fours = 0, this.sixes = 0, this.out = false});

  double get strikeRate => balls == 0 ? 0 : runs * 100 / balls;
}

class Bowler {
  final String id;
  final String name;
  int legalBalls = 0;
  int runsConceded = 0;
  int wickets = 0;
  int wides = 0;
  int noBalls = 0;
  int maidens = 0;

  Bowler({required this.id, required this.name});

  String get overs => '${legalBalls ~/ 6}.${legalBalls % 6}';
  double get economy => legalBalls == 0 ? 0 : runsConceded * 6 / legalBalls;
}

class Delivery {
  final int sequence;
  final int batterRuns;
  final int totalRuns;
  final ExtraType extra;
  final int extraRuns;
  final bool legal;
  final bool wicket;
  final WicketType? wicketType;
  final String strikerId;
  final String bowlerId;
  final String? dismissedPlayerId;
  final int completedRuns;

  const Delivery({
    required this.sequence,
    required this.batterRuns,
    required this.totalRuns,
    required this.extra,
    required this.extraRuns,
    required this.legal,
    required this.wicket,
    required this.strikerId,
    required this.bowlerId,
    this.wicketType,
    this.dismissedPlayerId,
    this.completedRuns = 0,
  });

  Map<String, Object?> toMap(String matchId, int innings) => {
    'match_id': matchId,
    'innings': innings,
    'sequence': sequence,
    'batter_runs': batterRuns,
    'total_runs': totalRuns,
    'extra_type': extra.name,
    'extra_runs': extraRuns,
    'legal': legal ? 1 : 0,
    'wicket': wicket ? 1 : 0,
    'wicket_type': wicketType?.name,
    'striker_id': strikerId,
    'bowler_id': bowlerId,
    'dismissed_player_id': dismissedPlayerId,
    'completed_runs': completedRuns,
  };
}

class AwardCandidate {
  final String title;
  final String playerName;
  final String reason;
  final double score;

  const AwardCandidate(this.title, this.playerName, this.reason, this.score);
}
