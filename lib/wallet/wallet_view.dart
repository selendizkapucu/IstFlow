import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod Eklendi

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'wallet_view_model.dart';
import '../home/home_view.dart'; // homeProvider'a erişmek için (Bakiye oradaydı)
import '../nfc/nfc_view.dart';
import '../main.dart'; // themeProvider için

// 2. PROVIDER TANIMI
final walletProvider =
    ChangeNotifierProvider.autoDispose<WalletViewModel>((ref) {
  return WalletViewModel();
});

class WalletView extends ConsumerWidget {
  const WalletView({super.key});

  @override
  // 3. WidgetRef parametresi
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. VERİLERİ DİNLİYORUZ
    final viewModel = ref.watch(walletProvider);
    final isDark = ref.watch(themeProvider);

    // ⚠️ DİKKAT: Bakiyeyi HomeViewModel'den çekiyoruz
    // Çünkü bakiye (walletBalance) değişkenini oraya koymuştuk.
    // Bu sayede Ana Sayfa'da para harcayınca Cüzdan'da da düşer.
    final homeVM = ref.watch(homeProvider);
    final currentBalance = homeVM.walletBalance;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: Text("Cüzdanım",
            style: AppTextStyles.header2.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      // ValueListenableBuilder kalktı, artık homeVM.walletBalance'ı dinliyoruz.
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // CÜZDAN KARTI
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade800, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(viewModel.model.cardHolder,
                          style: AppTextStyles.header2
                              .copyWith(color: Colors.white, fontSize: 18)),
                      const Icon(Icons.account_balance_wallet,
                          color: Colors.white),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kullanılabilir Bakiye",
                          style: AppTextStyles.caption
                              .copyWith(color: Colors.white70)),
                      const SizedBox(height: 5),
                      // BAKİYE BURADA GÖSTERİLİYOR
                      Text("₺ ${currentBalance.toStringAsFixed(2)}",
                          style: AppTextStyles.header1
                              .copyWith(color: Colors.white, fontSize: 36)),
                    ],
                  ),
                  Text(viewModel.model.cardNumber,
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white54, letterSpacing: 2)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PARA YÜKLE BUTONU
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showBankTopUpDialog(context, viewModel, homeVM, isDark);
                },
                icon: const Icon(Icons.add_circle, color: Colors.white),
                label: Text("Bankadan Para Yükle",
                    style: AppTextStyles.header2
                        .copyWith(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // NFC BUTONU
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NfcView()));
                },
                icon: Icon(Icons.nfc,
                    color: isDark ? AppColors.textLight : AppColors.primary),
                label: Text("Fiziksel Kart Oku (NFC)",
                    style: AppTextStyles.header2.copyWith(
                        color: isDark ? AppColors.textLight : AppColors.primary,
                        fontSize: 18)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: isDark ? AppColors.textLight : AppColors.primary,
                      width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
                "Maksimum bakiye limiti: ₺${viewModel.model.maxWalletLimit.toInt()}",
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textLightSecondary
                        : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  // --- YARDIMCI EKRANLAR ---

  // homeVM parametresi eklendi çünkü parayı oraya yükleyeceğiz
  void _showBankTopUpDialog(BuildContext context, WalletViewModel viewModel,
      dynamic homeVM, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2))),
              Text("Cüzdana Yükle",
                  style: AppTextStyles.header2.copyWith(
                      color: isDark
                          ? AppColors.textLight
                          : AppColors.textPrimary)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bankButton(context, viewModel, homeVM, 100, isDark),
                  _bankButton(context, viewModel, homeVM, 250, isDark),
                  _bankButton(context, viewModel, homeVM, 500, isDark),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                  "Maksimum bakiye limiti: ₺${viewModel.model.maxWalletLimit.toInt()}",
                  style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textLightSecondary
                          : AppColors.textSecondary)),
            ],
          ),
        );
      },
    );
  }

  Widget _bankButton(BuildContext context, WalletViewModel viewModel,
      dynamic homeVM, double amount, bool isDark) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor: isDark
                  ? AppColors.cardBackgroundDark
                  : AppColors.cardBackground,
              title: Text("Yükleme Onayı",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textLight
                          : AppColors.textPrimary)),
              content: Text(
                  "Cüzdanınıza ₺${amount.toInt()} yüklemek istediğinize emin misiniz?",
                  style: TextStyle(
                      color: isDark
                          ? AppColors.textLightSecondary
                          : AppColors.textPrimary)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("İptal",
                        style: TextStyle(color: AppColors.textSecondary))),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // Dialogu kapat

                    // 1. KONTROL: Limit aşımı var mı?
                    String? error =
                        viewModel.checkLimit(homeVM.walletBalance, amount);

                    if (error != null) {
                      Navigator.pop(context); // Modalı kapat
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(error),
                          backgroundColor: AppColors.error));
                    } else {
                      // 2. İŞLEM: Parayı HomeViewModel'deki bakiyeye ekle
                      // (Çünkü tek bir bakiye kaynağımız var)
                      homeVM.walletBalance += amount;
                      homeVM
                          .notifyListeners(); // Ana Sayfa ve Cüzdan güncellensin

                      Navigator.pop(context); // Modalı kapat
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Başarılı! Cüzdana ₺${amount.toInt()} eklendi."),
                          backgroundColor: AppColors.success));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  child:
                      const Text("Evet", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Text("+ ₺${amount.toInt()}"),
    );
  }
}
