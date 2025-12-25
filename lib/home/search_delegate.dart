import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../route_detail/route_detail_view.dart';

class RouteSearchDelegate extends SearchDelegate {
  // ARAMA YAPILACAK LİSTE (Veritabanı Simülasyonu)
  // Gerçekte burası ViewModel'den de gelebilir ama şimdilik statik kalabilir.
  final List<String> searchTerms = [
    "M4 Kadıköy - Sabiha Gökçen",
    "15F Beykoz - Kadıköy",
    "Marmaray (Halkalı - Gebze)",
    "500T Tuzla - Cevizlibağ",
    "11ÜS Sultanbeyli - Üsküdar",
    "M5 Üsküdar - Çekmeköy",
  ];

  // Arama Çubuğunun Sağındaki İkonlar (Temizle)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; // Yazıyı temizle
        },
        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
      ),
    ];
  }

  // Arama Çubuğunun Solundaki İkon (Geri Dön)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // Aramayı kapat
      },
      icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
    );
  }

  // Arama Sonucu (Enter'a basınca ne olsun?)
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var term in searchTerms) {
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(term);
      }
    }
    return _buildResultList(matchQuery, context);
  }

  // Arama Önerileri (Yazarken ne çıksın?)
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var term in searchTerms) {
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(term);
      }
    }
    return _buildResultList(matchQuery, context);
  }

  // Liste Görünümü (Ortak Fonksiyon)
  Widget _buildResultList(List<String> results, BuildContext context) {
    // Tema kontrolünü burada yapıyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          var result = results[index];
          return ListTile(
            leading: Icon(
              result.contains("M4") ||
                      result.contains("Marmaray") ||
                      result.contains("M5")
                  ? Icons.subway
                  : Icons.directions_bus,
              color: AppColors.secondary,
            ),
            title: Text(result,
                style: AppTextStyles.body.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary)),
            onTap: () {
              // SEÇİM YAPILDI!
              // Detay sayfasına yönlendiriyoruz
              // Seçilen hattın ismini (result) parametre olarak gönderiyoruz.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteDetailView(lineName: result),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Arama Çubuğu Teması (Karanlık Mod Uyumu İçin)
  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.grey),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          // Arama yazısı rengi
          color: isDark ? Colors.white : Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
