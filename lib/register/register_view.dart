import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // InputFormatters için
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod eklendi

// MERKEZİ SABİTLER
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

// MVVM
import 'register_model.dart';
import 'register_view_model.dart';

// 2. PROVIDER TANIMI
// autoDispose: Sayfadan çıkıldığında formu temizler.
final registerProvider =
    ChangeNotifierProvider.autoDispose<RegisterViewModel>((ref) {
  return RegisterViewModel();
});

// 3. ConsumerWidget
class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  // WidgetRef ref parametresi eklendi
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. VERİYİ DİNLEME (WATCH)
    // ChangeNotifierProvider sarmalayıcısını kaldırdık, değişkene atadık.
    final viewModel = ref.watch(registerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      // 1. APP BAR
      appBar: AppBar(
        title: Text("Hesap Oluştur", style: AppTextStyles.header2),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // 2. FORM ALANI
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // İkon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.person_add,
                      size: 50, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 30),

              // 1. AD SOYAD
              _buildTextField(
                controller: viewModel.nameController,
                label: "Ad Soyad",
                icon: Icons.person,
              ),
              const SizedBox(height: 15),

              // 2. KART NUMARASI
              _buildTextField(
                controller: viewModel.cardController,
                label: "Kart Numarası (16 Hane)",
                icon: Icons.credit_card,
                isNumber: true,
                maxLength: 16,
              ),
              const SizedBox(height: 15),

              // 3. DOĞUM YILI & MESLEK
              Row(
                children: [
                  // Doğum Yılı
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: viewModel.yearController,
                      label: "Doğum Yılı",
                      icon: Icons.calendar_today,
                      isNumber: true,
                      maxLength: 4,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Meslek Seçimi (Dropdown)
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: viewModel.selectedOccupation,
                      // RegisterConstants sınıfının viewModel veya model içinde tanımlı olduğundan emin ol
                      items: RegisterConstants.occupations.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: AppTextStyles.body),
                        );
                      }).toList(),
                      onChanged: (newValue) =>
                          viewModel.setOccupation(newValue),
                      dropdownColor: AppColors.cardBackground,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        labelText: "Meslek",
                        labelStyle: AppTextStyles.caption,
                        prefixIcon: const Icon(Icons.work,
                            color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // 4. E-POSTA
              _buildTextField(
                controller: viewModel.emailController,
                label: "E-posta Adresi",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              // 5. ŞİFRE
              TextField(
                controller: viewModel.passwordController,
                obscureText: !viewModel.isPasswordVisible,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  labelText: "Şifre Oluştur",
                  labelStyle: AppTextStyles.caption,
                  prefixIcon:
                      const Icon(Icons.lock, color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                        viewModel.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary),
                    onPressed: () => viewModel.togglePasswordVisibility(),
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 30),

              // KAYIT OL BUTONU
              ElevatedButton(
                onPressed: () {
                  // Logic'i çağır ve sonucu al
                  String? error = viewModel.register();

                  if (error != null) {
                    // HATA VARSA
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(error),
                          backgroundColor: AppColors.error),
                    );
                  } else {
                    // BAŞARILIYSA
                    _showSuccessDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Kayıt Ol",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- YARDIMCI METODLAR (Değişiklik yok) ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType ??
          (isNumber ? TextInputType.number : TextInputType.text),
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      maxLength: maxLength,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.caption,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.cardBackground,
        counterText: "",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 60),
              SizedBox(height: 10),
              Text("Tebrikler!", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            "Hesabınız başarıyla oluşturulmuştur. Giriş ekranına yönlendiriliyorsunuz.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
                Navigator.pop(context); // Kayıt ekranını kapat (Login'e dön)
              },
              child: const Text("Giriş Yap",
                  style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }
}
