import 'package:flutter/material.dart';

// Kampanya Veri Modeli
class CampaignModel {
  final String title;
  final String description;
  final String requirementText;
  final IconData badgeIcon;
  final IconData brandLogo;
  final Color brandColor;
  final String requiredBadgeType; // 'earlyBird', 'nightOwl', 'eco'

  CampaignModel({
    required this.title,
    required this.description,
    required this.requirementText,
    required this.badgeIcon,
    required this.brandLogo,
    required this.brandColor,
    required this.requiredBadgeType,
  });
}

// Kampanya Listesi (Mock Data)
class CampaignsData {
  static final List<CampaignModel> campaigns = [
    CampaignModel(
      title: "Beltur'da Kahve Ismarliyoruz!",
      description:
          "Sabahın erken saatlerinde yola düşenlere 1 Küçük Boy Filtre Kahve hediye.",
      requirementText: "Gereken: Erkenci Rozeti",
      badgeIcon: Icons.wb_sunny,
      brandLogo: Icons.coffee,
      brandColor: Colors.brown,
      requiredBadgeType: 'earlyBird',
    ),
    CampaignModel(
      title: "Sıcak Bir Çorba İyi Gider!",
      description:
          "Gece geç saatlerde yolculuk yapanlara İBB Kent Lokantaları'nda çorba ikramı.",
      requirementText: "Gereken: Gece Kuşu Rozeti",
      badgeIcon: Icons.nights_stay,
      brandLogo: Icons.soup_kitchen,
      brandColor: Colors.orange,
      requiredBadgeType: 'nightOwl',
    ),
    CampaignModel(
      title: "Yerebatan Sarnıcı Girişi",
      description:
          "Toplu taşıma kullanarak doğayı koruduğun için teşekkürler. Giriş biletin bizden!",
      requirementText: "Gereken: Çevre Dostu Rozeti",
      badgeIcon: Icons.eco,
      brandLogo: Icons.museum,
      brandColor: Colors.teal,
      requiredBadgeType: 'eco',
    ),
  ];
}
