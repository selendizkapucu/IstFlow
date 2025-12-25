import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod Eklendi

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'transfer_calculator_view_model.dart';
import '../main.dart'; // themeProvider için

// 2. PROVIDER TANIMI
// autoDispose: Sayfa kapatıldığında (Modal indiğinde) seçimleri sıfırla.
final transferProvider =
    ChangeNotifierProvider.autoDispose<TransferCalculatorViewModel>((ref) {
  return TransferCalculatorViewModel();
});

// 3. ConsumerWidget
class TransferCalculatorModal extends ConsumerWidget {
  const TransferCalculatorModal({super.key});

  @override
  // 4. WidgetRef Parametresi
  Widget build(BuildContext context, WidgetRef ref) {
    // 5. Verileri Dinliyoruz
    final viewModel = ref.watch(transferProvider);
    final isDark = ref.watch(themeProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tutamaç
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Başlık
          Text("Aktarma Hesapla",
              style: AppTextStyles.header2.copyWith(
                  color: isDark ? AppColors.textLight : AppColors.textPrimary)),

          const SizedBox(height: 20),

          // 1. SEÇENEK: KART TİPİ (Switch)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[100],
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Öğrenci Tarifesi",
                    style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textPrimary)),
                Switch(
                  value: viewModel.isStudent,
                  activeColor: AppColors.cardStudent,
                  onChanged: (val) {
                    // EYLEM: Riverpod üzerinden değiştir
                    // ref.read kullanmak best practice'dir (tetikleyici olduğu için)
                    ref.read(transferProvider).toggleCardType(val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. SEÇENEK: BASIM TİPİ BAŞLIĞI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Basım Tipi",
                  style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textLightSecondary
                          : AppColors.textSecondary)),
              Text(
                viewModel.isTransfer ? "Aktarma" : "İlk Basış",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // --- SLIDER ALANI ---
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.secondary,
              inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
              thumbColor: isDark ? Colors.white : AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
              trackHeight: 6.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            ),
            child: Slider(
              value: viewModel.isTransfer ? 1.0 : 0.0,
              min: 0,
              max: 1,
              divisions: 1,
              label: viewModel.isTransfer ? "Aktarma" : "İlk Basış",
              onChanged: (double val) {
                // EYLEM: Riverpod üzerinden değiştir
                ref.read(transferProvider).toggleTransfer(val == 1.0);
              },
            ),
          ),

          // Slider Altı Etiketler
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("İlk Basış",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey)),
                Text("Aktarma",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey)),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 10),

          // 3. SONUÇ ALANI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ödenecek Tutar:",
                      style: AppTextStyles.body.copyWith(
                          color: isDark
                              ? AppColors.textLightSecondary
                              : AppColors.textSecondary)),
                  Text(
                    viewModel.isStudent ? "Öğrenci Tarifesi" : "Tam Tarife",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey),
                  ),
                ],
              ),
              Text(
                "₺${viewModel.calculatedPrice.toStringAsFixed(2)}",
                style: AppTextStyles.header1.copyWith(
                    color: viewModel.isStudent
                        ? AppColors.cardStudent
                        : (isDark ? Colors.white : AppColors.primary),
                    fontSize: 36),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
