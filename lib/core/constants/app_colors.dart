import 'package:flutter/material.dart';

class AppColors {
  // Bu sınıftan nesne üretilmesini engelleriz
  AppColors._();

  // --- ANA MARKALAR RENKLERİ (GÜNCELLENDİ - RESİMDEKİ DEĞERLER) ---
  static const Color primary =
      Color.fromARGB(255, 0, 8, 47); // Koyu Lacivert (Deep Blue)
  static const Color secondary =
      Color.fromARGB(255, 4, 9, 60); // Açık Mavi (Vurgular için)

  // --- ÖZEL BUTON RENKLERİ ---
  static const Color qrButton = Colors.orange;

  // --- KART RENKLERİ ---
  static const Color cardStudent = Colors.teal;
  static const Color cardMother = Colors.deepPurple;
  static const Color cardFull = Color(0xFF37474F);

  // --- ARKA PLAN RENKLERİ ---
  static const Color background = Color(0xFFF5F5F5); // Açık Gri (Gündüz Modu)

  // Karanlık Mod Arka Planı -> Artık yeni 'primary' rengimizle aynı
  static const Color backgroundDark = primary;

  static const Color cardBackground = Colors.white;

  // Karanlık Mod Kart Rengi -> Yeni 'secondary' rengimiz (Biraz daha açık lacivert)
  static const Color cardBackgroundDark = secondary;

  // --- METİN RENKLERİ ---
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);

  static const Color textLight = Colors.white;
  static const Color textLightSecondary = Colors.white70;

  // --- ROZET RENKLERİ ---
  static const Color badgeEarlyBird = Colors.orange;
  static const Color badgeEcoFriendly = Colors.green;
  static const Color badgeUrbanLegend = Colors.amber;
  static const Color badgeTraveler = Colors.blue;
  static const Color badgeNightOwl =
      Color(0xFF1A237E); // Daha parlak bir lacivert

  // --- DURUM RENKLERİ ---
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFB00020);
}
