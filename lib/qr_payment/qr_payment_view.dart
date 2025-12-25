import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod

// MERKEZİ DOSYALAR
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

// MVVM
import 'qr_payment_view_model.dart';
import '../main.dart'; // themeProvider için

// 2. PROVIDER TANIMI
final qrPaymentProvider =
    ChangeNotifierProvider.autoDispose<QrPaymentViewModel>((ref) {
  return QrPaymentViewModel();
});

// 3. ConsumerStatefulWidget KULLANIMI
// Animasyon olduğu için 'ConsumerWidget' yetmez, 'ConsumerStatefulWidget' lazım.
class QrPaymentView extends ConsumerStatefulWidget {
  const QrPaymentView({super.key});

  @override
  ConsumerState<QrPaymentView> createState() => _QrPaymentViewState();
}

// 4. ConsumerState
// 'State' yerine 'ConsumerState' yazıyoruz. Bu sayede 'ref' her yerden erişilebilir oluyor.
class _QrPaymentViewState extends ConsumerState<QrPaymentView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animasyon motoru aynen kalıyor
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 200).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 5. VERİLERİ DİNLİYORUZ
    // ConsumerState içinde olduğumuz için 'ref' parametresi gelmez, direkt kullanırız.
    final viewModel = ref.watch(qrPaymentProvider);
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.primary,

      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("QR ile Öde",
            style: AppTextStyles.header2.copyWith(color: Colors.white)),
        centerTitle: true,
      ),

      // --- GÖVDE ---
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Turnikeye Okutunuz",
              style: AppTextStyles.body
                  .copyWith(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 30),

            // --- STACK (QR VE TARAYICI ÇİZGİSİ) ---
            Stack(
              children: [
                // KATMAN 1: QR KOD (Zemin)
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.qr_code_2,
                    size: 200,
                    color: Colors.black,
                  ),
                ),

                // KATMAN 2: HAREKET EDEN ÇİZGİ
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: _animation.value + 10,
                      left: 10,
                      child: Container(
                        width: 200,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            // --- STACK SONU ---

            const SizedBox(height: 50),

            // --- MANUEL OKUTMA BUTONU ---
            ElevatedButton.icon(
              onPressed: () async {
                // ViewModel'deki işlemi tetikle (ref.read GEREKMEZ, viewModel elimizde var)
                // Ama best practice olarak aksiyonlarda ref.read kullanmak daha güvenlidir.
                // Burada zaten viewModel değişkenini watch ettiğimiz için direkt onu kullanabiliriz.
                final result = await viewModel.processPayment();

                // 'mounted' kontrolü ConsumerState içinde de geçerlidir.
                if (mounted && result.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 10),
                          Text("${result.message} - ₺${result.amount}0"),
                        ],
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.nfc, color: AppColors.textLight),
              label: Text("Manuel Okut",
                  style: AppTextStyles.body.copyWith(
                      color: AppColors.textLight, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
