import 'package:flutter/material.dart';
import 'login_model.dart';
// Projendeki diğer sayfaların yolları
import '../main_nav/main_nav_view.dart';
import '../register/register_view.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginModel userModel = LoginModel();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // DÜZELTME BURADA:
  // Varsayılanı 'false' yaptık. Böylece uygulama açıldığında
  // "Tekrar Hoşgeldin" yerine direkt E-posta/Şifre kutuları gelecek.
  bool _isKnownUser = true;
  bool get isKnownUser => _isKnownUser;

  // --- Olaylar ---
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleKnownUser(bool value) {
    _isKnownUser = value;
    passwordController.clear();
    notifyListeners();
  }

  // --- Giriş Mantığı ---
  void login(BuildContext context) {
    String sifre = passwordController.text.trim();

    if (sifre.isEmpty) {
      _showError(context, "Lütfen şifrenizi giriniz.");
      return;
    }
    if (sifre.length < 8) {
      _showError(context, "Şifre en az 8 karakter olmalıdır.");
      return;
    }

    if (!_isKnownUser) {
      String email = emailController.text.trim();
      if (email.isEmpty || !email.contains("@")) {
        _showError(context, "Geçerli bir e-posta giriniz.");
        return;
      }
    }

    // Başarılı Giriş -> Ana Ekrana Git
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavView()),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(child: Text(message))
        ]),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // --- EKLENDİ: Bellek Temizliği ---
  // Sayfadan çıkıldığında controller'ları bellekten siler.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
