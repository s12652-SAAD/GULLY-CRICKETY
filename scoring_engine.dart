import '../models/cricket_models.dart';

class InningsState {
  int runs = 0;
  int wickets = 0;
  int legalBalls = 0;
  int target;
  int maxOvers;
  int extras = 0;
  int nextSequence = 1;
  String strikerId;
  String nonStrikerId;
  String bowlerId;
  final Map<String, Batter> batters;
  final Map<String, Bowler> bowlers;
  final List<Delivery> deliveries = [];

  InningsState({
    required this.strikerId,
    required this.nonStrikerId,
    required this.bowlerId,
    required this.batters,
    required this.bowlers,
    this.target = 0,
    this.maxOvers = 6,
  });

  String get overs => '${legalBalls ~/ 6}.${legalBalls % 6}';
  bool get isComplete =>
      wickets >= batters.length - 1 ||
      legalBalls >= maxOvers * 6 ||
      (target > 0 && runs >= target);

  /// Records one delivery. For run-outs, pass dismissedPlayerId explicitly.
  /// Wide/no-ball do not consume a legal ball. Byes/leg-byes do.
  Delivery addDelivery({
    int batterRuns = 0,
    ExtraType extra = ExtraType.none,
    int extraRuns = 0,
    bool wicket = false,
    WicketType? wicketType,
    String? dismissedPlayerId,
    int completedRuns = 0,
  }) {
    if (isComplete) {
      throw StateError('This innings has finished.');
    }
    if (batterRuns < 0 || extraRuns < 0 || completedRuns < 0) {
      throw ArgumentError('Runs cannot be negative.');
    }
    if (wicket && wicketType == null) {
      throw ArgumentError('Select a dismissal type.');
    }

    final striker = batters[strikerId]!;
    final bowler = bowlers[bowlerId]!;
    final legal = extra != ExtraType.wide && extra != ExtraType.noBall;

    // Wides/no-balls include at least one penalty run.
    final penalty = extra == ExtraType.wide || extra == ExtraType.noBall
        ? (extraRuns < 1 ? 1 : extraRuns)
        : extraRuns;
    final total = batterRuns + penalty;

    runs += total;
    extras += penalty;
    bowler.runsConceded +=
        extra == ExtraType.bye || extra == ExtraType.legBye ? 0 : total;

    if (extra == ExtraType.wide) bowler.wides += penalty;
    if (extra == ExtraType.noBall) bowler.noBalls += 1;

    // Batter receives runs only from bat, not byes/leg-byes/wides.
    striker.runs += batterRuns;
    if (extra != ExtraType.wide) striker.balls += legal || extra == ExtraType.noBall ? 1 : 0;
    if (batterRuns == 4) striker.fours++;
    if (batterRuns == 6) striker.sixes++;

    if (legal) {
      legalBalls++;
      bowler.legalBalls++;
    }

    if (wicket) {
      wickets++;
      final outId = dismissedPlayerId ?? strikerId;
      if (wicketType != WicketType.runOut &&
          wicketType != WicketType.retiredOut &&
          wicketType != WicketType.obstructingField) {
        bowler.wickets++;
      }
      if (batters.containsKey(outId)) batters[outId]!.out = true;
    }

    final delivery = Delivery(
      sequence: nextSequence++,
      batterRuns: batterRuns,
      totalRuns: total,
      extra: extra,
      extraRuns: penalty,
      legal: legal,
      wicket: wicket,
      wicketType: wicketType,
      strikerId: strikerId,
      bowlerId: bowlerId,
      dismissedPlayerId: dismissedPlayerId,
      completedRuns: completedRuns,
    );
    deliveries.add(delivery);

    // Odd completed runs rotate strike. An over-end rotation is applied
    // separately by the UI/controller after the sixth legal delivery.
    final runningTotal = completedRuns + batterRuns;
    if (runningTotal.isOdd) _swapStrike();
    return delivery;
  }

  void endOver() {
    if (legalBalls > 0 && legalBalls % 6 == 0) _swapStrike();
  }

  void _swapStrike() {
    final old = strikerId;
    strikerId = nonStrikerId;
    nonStrikerId = old;
  }

  void setNextBatter(String playerId) {
    if (!batters.containsKey(playerId) || batters[playerId]!.out) {
      throw ArgumentError('Select an available batter.');
    }
    if (batters[playerId]!.balls > 0 || batters[playerId]!.runs > 0) {
      // Existing not-out batter can return only through an explicit correction.
      throw ArgumentError('This player has already batted.');
    }
    strikerId = playerId;
  }

  void changeBowler(String playerId) {
    if (!bowlers.containsKey(playerId)) {
      throw ArgumentError('Unknown bowler.');
    }
    bowlerId = playerId;
  }
}
