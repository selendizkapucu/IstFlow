import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'profile_model.dart';
import 'profile_view_model.dart';
import '../login/login_view.dart';
import '../main.dart';

final profileProvider =
    ChangeNotifierProvider.autoDispose<ProfileViewModel>((ref) {
  return ProfileViewModel();
});

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileProvider);
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: Text("Profilim",
            style: AppTextStyles.header2.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(viewModel, isDark),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Aylık Özet",
                    style: AppTextStyles.header2.copyWith(
                        color: isDark ? Colors.white : AppColors.textPrimary)),
              ),
            ),
            const SizedBox(height: 10),

            // --- YANA KAYDIRMALI LİSTE ---
            SizedBox(
              height: 165,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                children: [
                  _buildInfoCard(
                    context: context,
                    isDark: isDark,
                    child: _buildCircularChart(
                        value: viewModel.monthlyJourneyCount,
                        goal: ProfileGoals.goalTraveler,
                        label: "Yolculuk",
                        color: AppColors.badgeTraveler),
                    onTap: () =>
                        _showJourneyAnalysis(context, viewModel, isDark),
                  ),
                  _buildInfoCard(
                    context: context,
                    isDark: isDark,
                    child: _buildCircularChart(
                        value: viewModel.monthlyScore,
                        goal: ProfileGoals.monthlyScoreGoal,
                        label: "CityPuan",
                        color: AppColors.badgeUrbanLegend),
                    onTap: () => _showScoreDetails(context, viewModel, isDark),
                  ),
                  _buildInfoCard(
                    context: context,
                    isDark: isDark,
                    child: _buildCircularChart(
                        value: viewModel.monthlyCarbonSaved.toInt(),
                        goal: ProfileGoals.monthlyCarbonGoal.toInt(),
                        label: "Karbon (kg)",
                        color: AppColors.badgeEcoFriendly),
                    onTap: () =>
                        _showCarbonAnalysis(context, viewModel, isDark),
                  ),
                  // HARCAMA KARTI (Düzeltildi: Artık yarım ekran açılıyor)
                  _buildInfoCard(
                    context: context,
                    isDark: isDark,
                    child: _buildCircularChart(
                        value: viewModel.dailyTotalCost.toInt(),
                        goal: 5000,
                        label: "Harcama (TL)",
                        color: AppColors.error,
                        isMoney: true),
                    onTap: () =>
                        _showSpendingAnalysis(context, viewModel, isDark),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: Text("1000 puana ulaş, sürpriz hediyeleri kazan!",
                  style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? AppColors.textLightSecondary
                          : AppColors.textSecondary)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Rozet Koleksiyonu (${viewModel.totalBadgesEarned})",
                    style: AppTextStyles.header2.copyWith(
                        color: isDark ? Colors.white : AppColors.textPrimary)),
              ),
            ),
            const SizedBox(height: 10),

            // ROZETLER
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _buildBadgeCard(
                      context: context,
                      title: "Şehir Efsanesi",
                      shortDesc: "Tüm Rozetler",
                      longDesc: "Şehrin hakimi sensin!",
                      isUnlocked: viewModel.hasCityLegendBadge,
                      current: viewModel.hasCityLegendBadge
                          ? 4
                          : viewModel.totalBadgesEarned,
                      goal: 4,
                      icon: Icons.emoji_events,
                      color: AppColors.badgeUrbanLegend,
                      isMasterBadge: true,
                      isDark: isDark),
                  _buildBadgeCard(
                      context: context,
                      title: "Gezgin",
                      shortDesc: "300 Yolculuk",
                      longDesc: "Şehri karış karış gezdin.",
                      isUnlocked: viewModel.hasTravelerBadge,
                      current: viewModel.monthlyJourneyCount,
                      goal: ProfileGoals.goalTraveler,
                      icon: Icons.location_on,
                      color: AppColors.badgeTraveler,
                      isDark: isDark),
                  _buildBadgeCard(
                      context: context,
                      title: "Çevre Dostu",
                      shortDesc: "200 Yolculuk",
                      longDesc: "Doğa sana minnettar!",
                      isUnlocked: viewModel.hasEcoBadge,
                      current: viewModel.monthlyJourneyCount,
                      goal: ProfileGoals.goalEcoFriendly,
                      icon: Icons.eco,
                      color: AppColors.badgeEcoFriendly,
                      isDark: isDark),
                  _buildBadgeCard(
                      context: context,
                      title: "Erkenci",
                      shortDesc: "07:00 Öncesi",
                      longDesc: "Güne erken başladın.",
                      isUnlocked: viewModel.hasEarlyBadge,
                      current: viewModel.earlyBirdCount,
                      goal: ProfileGoals.goalEarlyBird,
                      icon: Icons.wb_sunny,
                      color: AppColors.badgeEarlyBird,
                      isDark: isDark),
                  _buildBadgeCard(
                      context: context,
                      title: "Gece Kuşu",
                      shortDesc: "00:00 Sonrası",
                      longDesc: "Şehir uyurken yoldasın.",
                      isUnlocked: viewModel.hasNightBadge,
                      current: viewModel.nightOwlCount,
                      goal: ProfileGoals.goalNightOwl,
                      icon: Icons.nights_stay,
                      color: AppColors.badgeNightOwl,
                      isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // AYARLAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardBackgroundDark
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05), blurRadius: 10)
                    ]),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text("Bildirimler",
                          style: AppTextStyles.body.copyWith(
                              color: isDark
                                  ? AppColors.textLight
                                  : AppColors.textPrimary)),
                      activeColor: AppColors.secondary,
                      value: viewModel.isNotificationOn,
                      onChanged: (val) => viewModel.toggleNotification(val),
                    ),
                    Divider(
                        height: 1,
                        color: isDark ? Colors.grey[800] : Colors.grey[200]),
                    SwitchListTile(
                      title: Text("Karanlık Mod",
                          style: AppTextStyles.body.copyWith(
                              color: isDark
                                  ? AppColors.textLight
                                  : AppColors.textPrimary)),
                      activeColor: AppColors.secondary,
                      value: isDark,
                      onChanged: (val) {
                        ref.read(themeProvider.notifier).state = val;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ÇIKIŞ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                        (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("Çıkış Yap",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- YARDIMCI WIDGETLAR (Aynen Kalıyor) ---
  Widget _buildProfileHeader(ProfileViewModel viewModel, bool isDark) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, size: 60, color: Colors.white)),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
                child: const Icon(Icons.star, color: Colors.white, size: 20)),
          ],
        ),
        const SizedBox(height: 10),
        Text("Nico Robin",
            style: AppTextStyles.header1.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary)),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
              "${viewModel.badgesNeededForVip} rozet sonra Üst Segment!",
              style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppColors.textLightSecondary
                      : AppColors.textSecondary)),
        ),
        Text("ogrenci@university.edu.tr",
            style: AppTextStyles.caption.copyWith(
                color: isDark
                    ? AppColors.textLightSecondary
                    : AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildInfoCard(
      {required BuildContext context,
      required Widget child,
      required VoidCallback onTap,
      required bool isDark}) {
    return Container(
        width: 110,
        margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
        decoration: BoxDecoration(
            color: isDark
                ? AppColors.cardBackgroundDark
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ]),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                child:
                    Padding(padding: const EdgeInsets.all(12), child: child))));
  }

  Widget _buildCircularChart(
      {required int value,
      required int goal,
      required String label,
      required Color color,
      bool isMoney = false}) {
    double progress = (value / goal).clamp(0.0, 1.0);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          height: 60,
          width: 60,
          child: Stack(fit: StackFit.expand, children: [
            CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.2),
                color: color,
                strokeCap: StrokeCap.round),
            Center(
                child: Text(isMoney ? "${value ~/ 1000}k" : "$value",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color)))
          ])),
      const SizedBox(height: 8),
      Text(label, style: AppTextStyles.caption)
    ]);
  }

  Widget _buildBadgeCard(
      {required BuildContext context,
      required String title,
      required String shortDesc,
      required String longDesc,
      required bool isUnlocked,
      required int current,
      required int goal,
      required IconData icon,
      required Color color,
      bool isMasterBadge = false,
      required bool isDark}) {
    double progress = (current / goal).clamp(0.0, 1.0);
    return InkWell(
        onTap: () => _showBadgeDetailDialog(
            context, title, longDesc, icon, color, isUnlocked, isDark),
        child: Container(
            width: 110,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? color.withOpacity(0.1)
                  : (isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: isUnlocked ? color : Colors.grey.withOpacity(0.3),
                  width: isUnlocked ? (isMasterBadge ? 3 : 2) : 1),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(isUnlocked ? icon : Icons.lock,
                  color: isUnlocked ? color : Colors.grey,
                  size: isMasterBadge ? 40 : 36),
              const SizedBox(height: 8),
              Text(title,
                  style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isDark ? Colors.white70 : AppColors.textPrimary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  color: isUnlocked ? color : Colors.grey,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(5)),
              const SizedBox(height: 4),
              Text(shortDesc,
                  style: TextStyle(
                      fontSize: 10,
                      color: isUnlocked ? color : Colors.grey,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
            ])));
  }

  // --- MODALLAR ---

  // 1. YOLCULUK DETAYI
  void _showJourneyAnalysis(
      BuildContext context, ProfileViewModel viewModel, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_bus,
                size: 50, color: AppColors.badgeTraveler),
            const SizedBox(height: 10),
            Text("Yolculuk İstatistikleri",
                style: AppTextStyles.header2.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _buildAnalysisBox(
                        "Bu Hafta",
                        "${viewModel.weeklyJourneyCount}",
                        "Yolculuk",
                        AppColors.badgeTraveler,
                        isDark)),
                const SizedBox(width: 15),
                Expanded(
                    child: _buildAnalysisBox(
                        "Bu Ay",
                        "${viewModel.monthlyJourneyCount}",
                        "Yolculuk",
                        AppColors.badgeTraveler,
                        isDark)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 2. PUAN DETAYI
  void _showScoreDetails(
      BuildContext context, ProfileViewModel viewModel, bool isDark) {
    showModalBottomSheet(
        context: context,
        backgroundColor:
            isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.stars,
                    size: 60, color: AppColors.badgeUrbanLegend),
                const SizedBox(height: 10),
                Text("CityPuan Detayları",
                    style: AppTextStyles.header2.copyWith(
                        color: isDark ? Colors.white : AppColors.textPrimary)),
                Text("${viewModel.monthlyScore} Puan",
                    style: AppTextStyles.header1
                        .copyWith(color: AppColors.badgeUrbanLegend)),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.secondary.withOpacity(0.1)
                            : AppColors.badgeUrbanLegend.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(children: [
                      _buildListRow("Standart Yolculuk",
                          "+${viewModel.monthlyJourneyCount * 2}", isDark),
                      _buildListRow("Erkenci Bonusu",
                          "+${viewModel.earlyBirdCount * 5}", isDark),
                      _buildListRow("Gece Kuşu Bonusu",
                          "+${viewModel.nightOwlCount * 15}", isDark)
                    ]))
              ]));
        });
  }

  // 3. KARBON DETAYI
  void _showCarbonAnalysis(
      BuildContext context, ProfileViewModel viewModel, bool isDark) {
    int treeEquivalent = (viewModel.monthlyCarbonSaved / 2).toInt();
    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.eco, size: 60, color: AppColors.badgeEcoFriendly),
            const SizedBox(height: 10),
            Text("Karbon Tasarrufu",
                style: AppTextStyles.header2.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: AppColors.badgeEcoFriendly.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Text("Toplam Tasarruf",
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87)),
                  Text("${viewModel.monthlyCarbonSaved.toStringAsFixed(1)} kg",
                      style: AppTextStyles.header1
                          .copyWith(color: AppColors.badgeEcoFriendly)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.forest,
                  color: AppColors.badgeEcoFriendly, size: 20),
              const SizedBox(width: 5),
              Text("Bu, $treeEquivalent ağacın temizliğine eşdeğer!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.badgeEcoFriendly))
            ]),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetailDialog(
      BuildContext context,
      String title,
      String longDesc,
      IconData icon,
      Color color,
      bool isUnlocked,
      bool isDark) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                backgroundColor: isDark
                    ? AppColors.cardBackgroundDark
                    : AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: Icon(icon, size: 50, color: color)),
                  const SizedBox(height: 15),
                  Text(title,
                      style: AppTextStyles.header2.copyWith(
                          color:
                              isDark ? Colors.white : AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: isUnlocked ? AppColors.success : Colors.grey,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(isUnlocked ? "KAZANILDI" : "KİLİTLİ",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12))),
                  const SizedBox(height: 15),
                  Text(longDesc,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                          color:
                              isDark ? Colors.white70 : AppColors.textPrimary))
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Kapat",
                          style: TextStyle(color: AppColors.textSecondary)))
                ]));
  }

  Widget _buildAnalysisBox(
      String title, String value, String unit, Color color, bool isDark) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3))),
        child: Column(children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 12)),
          const SizedBox(height: 5),
          Text(value,
              style: AppTextStyles.header2.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimary)),
          Text(unit, style: AppTextStyles.caption)
        ]));
  }

  // --- GÜNCELLENMİŞ: HARCAMA ANALİZİ (DASHBOARD - Scroll Düzeltmesi) ---
  void _showSpendingAnalysis(
      BuildContext context, ProfileViewModel viewModel, bool isDark) {
    final categories = viewModel.spendingCategories;

    final Map<String, Color> categoryColors = {
      "Metro": Colors.redAccent,
      "Otobüs": Colors.orange,
      "Marmaray": Colors.blue,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        // YÜKSEKLİK AYARI: Ekranın %55'i kadar olsun (Diğerleriyle aynı hizada)
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          color:
              isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        // SCROLL: İçerik sığmazsa kaydırılabilir
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tutamaç Çizgisi
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2)),
                ),

                const Icon(Icons.pie_chart, size: 50, color: AppColors.error),
                const SizedBox(height: 10),
                Text("Harcama Analizi",
                    style: AppTextStyles.header2.copyWith(
                        color: isDark ? Colors.white : AppColors.textPrimary)),

                const SizedBox(height: 30),

                // 1. PASTA GRAFİK (ORTASINA TOPLAM TUTAR YAZDIK)
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(220, 220),
                        painter: SimplePieChartPainter(
                          categories: categories,
                          colors: categoryColors,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Toplam",
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white54 : Colors.grey)),
                          Text("₺${viewModel.monthlyTotalCost.toInt()}",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary)),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 2. KATEGORİLER (YAN YANA MODERN KUTULAR)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: categories.entries.map((entry) {
                    return Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              color: categoryColors[entry.key] ?? Colors.grey,
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(height: 5),
                        Text(entry.key,
                            style: TextStyle(
                                color:
                                    isDark ? Colors.white70 : Colors.black87)),
                        Text("%${entry.value.toStringAsFixed(1)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black)),
                      ],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),
                Divider(
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                    thickness: 2),
                const SizedBox(height: 10),

                // 3. DÖNEMSEL TOPLAMLAR (MODERN KART LİSTESİ)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Dönemsel Toplamlar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              isDark ? Colors.white : AppColors.textPrimary)),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color:
                              isDark ? Colors.white10 : Colors.grey.shade200)),
                  child: Column(
                    children: [
                      _buildModernListRow(
                          Icons.today,
                          "Bugün",
                          "₺${viewModel.dailyTotalCost.toStringAsFixed(2)}",
                          isDark),
                      Divider(
                          height: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200]),
                      _buildModernListRow(
                          Icons.calendar_month,
                          "Bu Ay",
                          "₺${viewModel.monthlyTotalCost.toStringAsFixed(2)}",
                          isDark),
                      Divider(
                          height: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200]),
                      _buildModernListRow(
                          Icons.calendar_today,
                          "Bu Yıl",
                          "₺${viewModel.yearlyTotalCost.toStringAsFixed(2)}",
                          isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListRow(String title, String value, bool isDark) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: AppTextStyles.body.copyWith(
                  color: isDark ? Colors.white70 : AppColors.textPrimary)),
          Text(value,
              style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary))
        ]));
  }

  // Modern Liste Satırı
  Widget _buildModernListRow(
      IconData icon, String title, String value, bool isDark) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.error, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.textPrimary)),
      trailing: Text(value,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : AppColors.textPrimary)),
    );
  }
}

// --- PASTA GRAFİK ÇİZİCİ ---
class SimplePieChartPainter extends CustomPainter {
  final Map<String, double> categories;
  final Map<String, Color> colors;

  SimplePieChartPainter({required this.categories, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    double total = 0;
    categories.values.forEach((v) => total += v);

    double startRadian = -pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintObj = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    categories.forEach((key, value) {
      final sweepRadian = (value / total) * 2 * pi;
      paintObj.color = colors[key] ?? Colors.grey;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian - 0.1,
        false,
        paintObj,
      );

      startRadian += sweepRadian;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
