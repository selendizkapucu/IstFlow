import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'login/login_view.dart';

// 1. ADIM: GLOBAL STATE (Değişken)
// Uygulamanın herhangi bir yerinden erişilebilen tema bilgisi.
// false: Açık Tema, true: Koyu Tema
final themeProvider = StateProvider<bool>((ref) {
  return false;
});

void main() {
  runApp(
    // 2. ADIM: PROVIDERSCOPE
    // Riverpod'un çalışması için tüm uygulamayı sarmalıyoruz.
    const ProviderScope(
      child: IstFlowApp(),
    ),
  );
}

// 3. ADIM: CONSUMERWIDGET
// StatelessWidget yerine ConsumerWidget kullanıyoruz ki veri dinleyebilelim.
class IstFlowApp extends ConsumerWidget {
  const IstFlowApp({super.key});

  @override
  // build metoduna 'WidgetRef ref' parametresini ekliyoruz.
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. ADIM: VERİYİ İZLEME (WATCH)
    // themeProvider her değiştiğinde bu build metodu tekrar çalışır.
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'IstFlow',
      debugShowCheckedModeBanner: false,

      // Sistemin o anki modu (isDarkMode true ise dark, false ise light)
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Açık Tema Ayarları
      theme: ThemeData.light(useMaterial3: true),

      // Koyu Tema Ayarları
      darkTheme: ThemeData.dark(useMaterial3: true),

      // Başlangıç Sayfası
      home: const LoginView(),
    );
  }
}
