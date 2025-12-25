import 'package:flutter/material.dart';
import 'register_model.dart'; // Constants için

class RegisterViewModel extends ChangeNotifier {
  // --- KONTROLCÜLER ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Seçilen Meslek
  String? _selectedOccupation;
  String? get selectedOccupation => _selectedOccupation;

  // Şifre Gizle/Göster
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // --- AKSİYONLAR ---

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setOccupation(String? value) {
    _selectedOccupation = value;
    notifyListeners();
  }

  // --- KAYIT MANTIĞI ---
  // Hata varsa String döner, Başarılıysa null döner
  String? register() {
    // 1. Boş Alan Kontrolü
    if (nameController.text.isEmpty ||
        cardController.text.isEmpty ||
        yearController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        _selectedOccupation == null) {
      return "Lütfen tüm alanları doldurunuz.";
    }

    // 2. Kart Numarası Kontrolü
    if (cardController.text.length != 16) {
      return "Kart numarası 16 hane olmalıdır.";
    }

    // 3. (Opsiyonel) Kayıt işlemini simüle et (API isteği vb.)
    print("Kayıt Başarılı: ${nameController.text}");

    // Hata yok, işlem başarılı
    return null;
  }

  // --- EKLENDİ: BELLEK TEMİZLİĞİ (CRITICAL) ---
  // Sayfa kapandığında bu controller'ları öldürmezsek hafıza şişer.
  @override
  void dispose() {
    nameController.dispose();
    cardController.dispose();
    yearController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
