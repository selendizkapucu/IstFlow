class TripModel {
  String line;
  double price;
  String type;
  DateTime date;

  TripModel({
    required this.line,
    required this.price,
    required this.type,
    required this.date,
  });
}

// Rozet ve Hedef Sabitleri (Logic'te kullanılacak)
class ProfileGoals {
  static const int goalTraveler = 300;
  static const int goalEcoFriendly = 200;
  static const int goalEarlyBird = 50;
  static const int goalNightOwl = 20;

  static const double monthlyCarbonGoal = 800.0;
  static const int monthlyScoreGoal = 1000;
  static const double carbonSavedPerTrip = 2.6;
}
