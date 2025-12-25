import 'package:flutter/material.dart';
import 'profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  // --- DURUM DEĞİŞKENLERİ ---
  bool isNotificationOn = true;
  List<TripModel> travelHistory = [];

  // Constructor çalıştığında verileri oluştur
  ProfileViewModel() {
    _generateSimulationData();
  }

  // --- VERİ SİMÜLASYONU ---
  void _generateSimulationData() {
    final now = DateTime.now();

    // 1. 60 Tane Sabah Yolculuğu (Dün) - Metro Ağırlıklı
    for (int i = 0; i < 60; i++) {
      travelHistory.add(TripModel(
        line: "M4 Metro",
        price: 17.70,
        type: "Tam",
        date: DateTime(now.year, now.month, now.day - 1, 06, 30),
      ));
    }
    // 2. 85 Tane Normal Yolculuk (Önceki Gün) - Otobüs Ağırlıklı
    for (int i = 0; i < 85; i++) {
      travelHistory.add(TripModel(
        line: "15F Beykoz",
        price: 17.70,
        type: "Tam",
        date: DateTime(now.year, now.month, now.day - 2, 14, 00),
      ));
    }
    // 3. Biraz da Marmaray ekleyelim ki grafik renkli olsun
    for (int i = 0; i < 20; i++) {
      travelHistory.add(TripModel(
        line: "Marmaray",
        price: 35.00,
        type: "Tam",
        date: DateTime(now.year, now.month, now.day - 3, 18, 00),
      ));
    }
    notifyListeners();
  }

  // --- HESAPLAMALAR (GETTERS) ---

  // YENİ: HARCAMA KATEGORİ ANALİZİ (PASTA GRAFİK İÇİN)
  Map<String, double> get spendingCategories {
    double metroTotal = 0;
    double busTotal = 0;
    double trainTotal = 0;
    double total = 0;

    final now = DateTime.now();

    for (var trip in travelHistory) {
      // Sadece "Bu Ay" yapılan harcamaları analiz et
      if (trip.date.month == now.month && trip.date.year == now.year) {
        // Kategoriye Ayır
        if (trip.line.contains("Metro") ||
            (trip.line.startsWith("M") && !trip.line.contains("Marmaray"))) {
          metroTotal += trip.price;
        } else if (trip.line.contains("Marmaray") ||
            trip.line.contains("Tren")) {
          trainTotal += trip.price;
        } else {
          // Diğer her şey (IETT vb.) otobüs varsayılır
          busTotal += trip.price;
        }

        total += trip.price;
      }
    }

    if (total == 0) return {};

    // Yüzdeleri hesapla ve döndür
    return {
      "Metro": (metroTotal / total) * 100,
      "Otobüs": (busTotal / total) * 100,
      "Marmaray": (trainTotal / total) * 100,
    };
  }

  // Yolculuk Sayıları
  int get weeklyJourneyCount {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    return travelHistory.where((t) => t.date.isAfter(lastWeek)).length;
  }

  int get monthlyJourneyCount {
    final now = DateTime.now();
    return travelHistory
        .where((t) => t.date.month == now.month && t.date.year == now.year)
        .length;
  }

  // Harcamalar
  double get dailyTotalCost {
    double total = 0;
    final now = DateTime.now();
    for (var trip in travelHistory) {
      if (trip.date.day == now.day &&
          trip.date.month == now.month &&
          trip.date.year == now.year) {
        total += trip.price;
      }
    }
    return total;
  }

  double get monthlyTotalCost {
    double total = 0;
    final now = DateTime.now();
    for (var trip in travelHistory) {
      if (trip.date.month == now.month && trip.date.year == now.year)
        total += trip.price;
    }
    return total;
  }

  double get yearlyTotalCost {
    double total = 0;
    final now = DateTime.now();
    for (var trip in travelHistory) {
      if (trip.date.year == now.year) total += trip.price;
    }
    return total;
  }

  // Puan Hesaplama
  int get monthlyScore {
    int score = 0;
    final now = DateTime.now();
    for (var trip in travelHistory) {
      if (trip.date.month == now.month && trip.date.year == now.year) {
        score += 2; // Standart puan
        if (trip.date.hour < 7)
          score += 5; // Erkenci
        else if (trip.date.hour >= 0 && trip.date.hour < 5)
          score += 15; // Gece kuşu
      }
    }
    return score;
  }

  // Rozet İstatistikleri
  int get earlyBirdCount => travelHistory.where((t) => t.date.hour < 7).length;
  int get nightOwlCount =>
      travelHistory.where((t) => t.date.hour >= 0 && t.date.hour < 5).length;
  double get monthlyCarbonSaved =>
      monthlyJourneyCount * ProfileGoals.carbonSavedPerTrip;

  // Rozet Durumları
  bool get hasTravelerBadge => monthlyJourneyCount >= ProfileGoals.goalTraveler;
  bool get hasEcoBadge => monthlyJourneyCount >= ProfileGoals.goalEcoFriendly;
  bool get hasEarlyBadge => earlyBirdCount >= ProfileGoals.goalEarlyBird;
  bool get hasNightBadge => nightOwlCount >= ProfileGoals.goalNightOwl;
  bool get hasCityLegendBadge =>
      hasTravelerBadge && hasEcoBadge && hasEarlyBadge && hasNightBadge;

  int get totalBadgesEarned {
    int count = 0;
    if (hasTravelerBadge) count++;
    if (hasEcoBadge) count++;
    if (hasEarlyBadge) count++;
    if (hasNightBadge) count++;
    if (hasCityLegendBadge) count++;
    return count;
  }

  int get badgesNeededForVip => 5 - totalBadgesEarned;

  // --- AKSİYONLAR ---
  void toggleNotification(bool value) {
    isNotificationOn = value;
    notifyListeners();
  }
}
