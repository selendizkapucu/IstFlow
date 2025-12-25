import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod

// MERKEZİ SABİTLER
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

// MVVM
import 'nfc_model.dart';
import 'nfc_view_model.dart';

// 2. PROVIDER TANIMI
final nfcProvider = ChangeNotifierProvider.autoDispose<NfcViewModel>((ref) {
  return NfcViewModel();
});

// 3. ConsumerStatefulWidget
class NfcView extends ConsumerStatefulWidget {
  const NfcView({super.key});

  @override
  ConsumerState<NfcView> createState() => _NfcViewState();
}

class _NfcViewState extends ConsumerState<NfcView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 1. Animasyon Motorunu Başlat
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // 2. Tarama Mantığını Başlat (Riverpod Yöntemi)
    // initState içinde context veya ref kullanmak için addPostFrameCallback güvenlidir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScanProcess();
    });
  }

  // ViewModel ile iletişim kuran ara fonksiyon
  Future<void> _startScanProcess() async {
    // ref.read ile ViewModel'deki fonksiyonu tetikliyoruz
    final result = await ref.read(nfcProvider).startScanSimulation();

    // Ekran hala açıksa sonucu göster
    if (mounted) {
      _showResultDialog(result);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Burada ViewModel'i dinlemeye gerek yok çünkü sadece işlem yapıyor,
    // ekranda dinamik bir şey değişmiyor (sadece animasyon var).
    // Ama yine de watch etmek zarar vermez.
    // final viewModel = ref.watch(nfcProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Animasyonlu Halkalar
          _buildRipple(0.0),
          _buildRipple(0.3),
          _buildRipple(0.6),

          // İkon ve Yazı
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.nfc, size: 100, color: Colors.white),
              const SizedBox(height: 50),
              Text(
                "Taranıyor...",
                style: AppTextStyles.header1
                    .copyWith(color: AppColors.secondary, letterSpacing: 2),
              ),
              const SizedBox(height: 10),
              Text(
                "Kartı telefonun arkasına yaklaştırın",
                style: AppTextStyles.body
                    .copyWith(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRipple(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = (_controller.value + delay) % 1.0;
        return Container(
          width: 300 * value,
          height: 300 * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.secondary.withOpacity(1.0 - value),
              width: 20 * (1.0 - value),
            ),
          ),
        );
      },
    );
  }

  // --- SONUÇ PENCERESİ ---
  void _showResultDialog(NfcResultModel result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              const Icon(Icons.check_circle,
                  color: AppColors.success, size: 60),
              const SizedBox(height: 10),
              Text("Kart Bulundu!",
                  style: AppTextStyles.header2.copyWith(color: Colors.white)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Kart ID: ${result.cardId}", style: AppTextStyles.caption),
              const SizedBox(height: 20),
              const Text("Mevcut Bakiye",
                  style: TextStyle(color: Colors.white70)),
              Text(result.balance,
                  style: AppTextStyles.header1
                      .copyWith(color: AppColors.secondary, fontSize: 32)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
                Navigator.pop(context); // Sayfadan çık
              },
              child: const Text("Kapat", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
                Navigator.pop(context); // Sayfadan çık

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: AppColors.success,
                    content: Text("Kart başarıyla cüzdana eklendi!")));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary),
              child: const Text("Cüzdana Ekle",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
