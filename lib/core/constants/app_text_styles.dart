import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Büyük Başlıklar (Sayfa Üstleri)
  static const TextStyle header1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Alt Başlıklar (Kart başlıkları vs.)
  static const TextStyle header2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Normal Metin (Açıklamalar)
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Küçük Açıklamalar (Tarih, alt bilgi)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // Rozet Yazıları (Özel)
  static const TextStyle badgeText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Rozet içi genelde beyaz olur
  );
}
