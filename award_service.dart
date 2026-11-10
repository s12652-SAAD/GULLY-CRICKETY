import '../models/cricket_models.dart';

class AwardService {
  /// Produces transparent candidate rankings. Organizer confirms final awards.
  List<AwardCandidate> candidates({
    required List<Batter> batters,
    required List<Bowler> bowlers,
  }) {
    final result = <AwardCandidate>[];

    if (batters.isNotEmpty) {
      final topRuns = [...batters]..sort((a, b) => b.runs.compareTo(a.runs));
      final p = topRuns.first;
      result.add(AwardCandidate('Best Batsman', p.name,
          '${p.runs} runs from ${p.balls} balls', p.runs.toDouble()));

      final qualified = batters.where((b) => b.balls >= 10).toList()
        ..sort((a, b) => b.strikeRate.compareTo(a.strikeRate));
      if (qualified.isNotEmpty) {
        final s = qualified.first;
        result.add(AwardCandidate('Most Valuable Striker', s.name,
            'Strike rate ${s.strikeRate.toStringAsFixed(1)} (${s.balls} balls)',
            s.strikeRate));
      }
    }

    if (bowlers.isNotEmpty) {
      final topWickets = [...bowlers]..sort((a, b) {
        final wicketCompare = b.wickets.compareTo(a.wickets);
        return wicketCompare != 0 ? wicketCompare : a.economy.compareTo(b.economy);
      });
      final p = topWickets.first;
      result.add(AwardCandidate('Best Bowler', p.name,
          '${p.wickets} wickets, ${p.runsConceded} runs in ${p.overs} overs',
          p.wickets * 100 - p.economy));
    }

    return result;
  }
}
