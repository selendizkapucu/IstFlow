import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod Eklendi

import 'main_nav_view_model.dart';

// SAYFALAR
import '../home/home_view.dart';
import '../wallet/wallet_view.dart'; // Cüzdan sayfan (CityPass)
import '../profile/profile_view.dart';

// 2. PROVIDER TANIMI
// autoDispose: Kullanıcı çıkış yapıp (Login'e dönüp) tekrar girerse,
// menü sıfırlanır (yani yine Ana Sayfa'dan başlar).
final mainNavProvider =
    ChangeNotifierProvider.autoDispose<MainNavViewModel>((ref) {
  return MainNavViewModel();
});

// 3. ConsumerWidget
class MainNavView extends ConsumerWidget {
  const MainNavView({super.key});

  @override
  // WidgetRef ref parametresini ekledik
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. VERİYİ DİNLEME (WATCH)
    // Hangi sayfanın seçili olduğunu buradan takip ediyoruz.
    final viewModel = ref.watch(mainNavProvider);

    // Menüdeki Sayfalar
    final List<Widget> pages = [
      const HomeView(),
      const WalletView(),
      const ProfileView(),
    ];

    return Scaffold(
      // Seçili sayfayı göster
      body: pages[viewModel.selectedIndex],

      // Alt Menü (Material 3 Design)
      bottomNavigationBar: NavigationBar(
        selectedIndex: viewModel.selectedIndex,
        onDestinationSelected: (int index) {
          // Değişikliği tetikle
          // (ref.read kullanıyoruz çünkü bu bir eylem/aksiyon)
          // Not: viewModel değişkeni zaten watch edildiği için
          // viewModel.changeIndex(index) demek de çalışır ama
          // best practice olarak aksiyonlarda read önerilir.
          ref.read(mainNavProvider).changeIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Cüzdan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
