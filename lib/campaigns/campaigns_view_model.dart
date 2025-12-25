import 'package:flutter/material.dart';
import 'campaigns_model.dart'; // Model ve Data

class CampaignsViewModel extends ChangeNotifier {
  // Kampanya Listesi
  List<CampaignModel> campaigns = CampaignsData.campaigns;

  // Rozet Durumları (Simüle Edilmiş)
  bool _hasEarlyBirdBadge = false;
  bool _hasNightOwlBadge = false;
  bool _hasEcoBadge = false;

  CampaignsViewModel() {
    _calculateBadges();
  }

  // Profil sayfasındaki mantığın aynısı (Simülasyon)
  void _calculateBadges() {
    // 320 adet rastgele yolculuk üret
    List<DateTime> travelHistory = List.generate(320, (index) {
      DateTime date = DateTime.now();
      if (index < 105) {
        // Erkenci (06:30)
        return DateTime(date.year, date.month, date.day, 06, 30);
      } else if (index < 130) {
        // Gece Kuşu (01:30)
        return DateTime(date.year, date.month, date.day, 01, 30);
      } else {
        // Normal (14:00)
        return DateTime(date.year, date.month, date.day, 14, 00);
      }
    });

    // Rozet Kontrolleri
    int earlyCount = travelHistory.where((d) => d.hour < 7).length;
    _hasEarlyBirdBadge = earlyCount >= 100;

    int nightCount =
        travelHistory.where((d) => d.hour >= 0 && d.hour < 5).length;
    _hasNightOwlBadge = nightCount >= 20;

    _hasEcoBadge = travelHistory.length >= 200;

    notifyListeners();
  }

  // Kampanyanın kilidi açık mı?
  bool isCampaignUnlocked(String requiredBadgeType) {
    switch (requiredBadgeType) {
      case 'earlyBird':
        return _hasEarlyBirdBadge;
      case 'nightOwl':
        return _hasNightOwlBadge;
      case 'eco':
        return _hasEcoBadge;
      default:
        return false;
    }
  }
}
