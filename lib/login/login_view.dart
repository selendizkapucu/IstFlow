import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod Paketi

// MERKEZİ DOSYALARIMIZ
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

// Sayfa Bağlantıları
import '../register/register_view.dart';
import 'login_view_model.dart'; // ViewModel burada duruyor

// 2. PROVIDER TANIMI (Global)
// autoDispose: Sayfadan çıkınca text controller'ları ve state'i sıfırlar.
final loginProvider = ChangeNotifierProvider.autoDispose<LoginViewModel>((ref) {
  return LoginViewModel();
});

// 3. ConsumerWidget (Riverpod Tüketicisi)
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  // WidgetRef ref parametresini ekledik
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. VERİYİ DİNLEME (WATCH)
    // Artık Consumer<LoginViewModel> sarmalayıcısına ihtiyacımız yok.
    // Bu satır sayesinde 'viewModel' içindeki her değişiklikte ekran güncellenir.
    final viewModel = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      // 1. APP BAR
      appBar: AppBar(
        title: Text(
          "IstFlow",
          style: AppTextStyles.header1.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // 5. TEMİZLENMİŞ AĞAÇ YAPISI
      // ChangeNotifierProvider ve Consumer widget'ları kalktı.
      // Doğrudan içeriğe odaklanıyoruz.
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Doğa dostu ulaşım için...",
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 40),

              // 2. EKRAN DEĞİŞİMİ
              if (viewModel.isKnownUser)
                _buildKnownUserView(viewModel)
              else
                _buildGuestUserView(viewModel),

              const SizedBox(height: 20),

              // 3. GİRİŞ BUTONU
              ElevatedButton(
                onPressed: () => viewModel.login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Giriş Yap",
                  style: AppTextStyles.header2.copyWith(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // 4. ALT SEÇENEKLER
              _buildBottomOptions(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  // --- YARDIMCI WIDGETLAR ---
  // (Burada değişiklik yapmaya gerek yok, viewModel parametre olarak geliyor)

  Widget _buildKnownUserView(LoginViewModel viewModel) {
    return Column(
      children: [
        // Profil Foto Alanı
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: const CircleAvatar(
            radius: 65,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
        ),
        const SizedBox(height: 25),

        Text("Tekrar Hoş Geldin,",
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 5),

        Text(
          viewModel.userModel.savedName,
          style: AppTextStyles.header1.copyWith(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),

        Text(viewModel.userModel.savedEmail,
            style: AppTextStyles.caption.copyWith(fontSize: 14)),

        const SizedBox(height: 40),

        _buildPasswordField(viewModel),
      ],
    );
  }

  Widget _buildGuestUserView(LoginViewModel viewModel) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle),
          child: const Icon(Icons.directions_bus_rounded,
              size: 50, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        Text("Giriş Yap", style: AppTextStyles.header1.copyWith(fontSize: 28)),
        const SizedBox(height: 30),
        TextField(
          controller: viewModel.emailController,
          keyboardType: TextInputType.emailAddress,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            labelText: "E-posta Adresi",
            labelStyle:
                AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            hintText: "ornek@email.com",
            prefixIcon: const Icon(Icons.email_outlined,
                color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 20),
        _buildPasswordField(viewModel),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => viewModel.toggleKnownUser(true),
            child: Text(
              "${viewModel.userModel.savedName} hesabına dön",
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginViewModel viewModel) {
    return TextField(
      controller: viewModel.passwordController,
      obscureText: !viewModel.isPasswordVisible,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: "Şifre",
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        prefixIcon:
            const Icon(Icons.lock_outline, color: AppColors.textSecondary),
        suffixIcon: IconButton(
          icon: Icon(
            viewModel.isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: AppColors.textSecondary,
          ),
          onPressed: () => viewModel.togglePasswordVisibility(),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildBottomOptions(BuildContext context, LoginViewModel viewModel) {
    return Column(
      children: [
        if (viewModel.isKnownUser)
          TextButton(
            onPressed: () => viewModel.toggleKnownUser(false),
            child: Text(
              "Başka bir hesapla giriş yap",
              style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hesabınız yok mu? ",
                style:
                    AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterView()),
                );
              },
              child: Text(
                "Hesap Oluştur",
                style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
