import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'campaigns_view_model.dart';
import 'campaigns_model.dart';

class CampaignsView extends StatelessWidget {
  const CampaignsView({super.key});

  @override
  Widget build(BuildContext context) {
    // TEMA KONTROLÜ
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => CampaignsViewModel(),
      child: Scaffold(
        // DÜZELTME: Karanlık Mod Arka Planı
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.background,

        appBar: AppBar(
          title: Text("Fırsatlar Dünyası",
              style: AppTextStyles.header2.copyWith(
                  color: isDark ? AppColors.textLight : AppColors.textPrimary)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: isDark ? AppColors.textLight : AppColors.textPrimary),
        ),

        body: Consumer<CampaignsViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rozetlerinle Kazan!",
                      style: AppTextStyles.header1.copyWith(
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary)),
                  const SizedBox(height: 5),
                  Text(
                    "Kazandığın rozetler sana özel hediyelerin kapısını açar.",
                    style: AppTextStyles.body.copyWith(
                        color: isDark
                            ? AppColors.textLightSecondary
                            : AppColors.textSecondary),
                  ),
                  const SizedBox(height: 30),
                  ...viewModel.campaigns.map((campaign) {
                    bool isUnlocked = viewModel
                        .isCampaignUnlocked(campaign.requiredBadgeType);

                    return _buildCouponCard(
                      context: context,
                      campaign: campaign,
                      isUnlocked: isUnlocked,
                      isDark:
                          isDark, // DÜZELTME: isDark parametresi gönderiliyor
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCouponCard({
    required BuildContext context,
    required CampaignModel campaign,
    required bool isUnlocked,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        // DÜZELTME: Kart arka plan rengi karanlık modda cardBackgroundDark
        color: isUnlocked
            ? (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground)
            : (isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ]
            : [],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: isUnlocked ? campaign.brandColor : Colors.grey,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(
              child: Icon(campaign.brandLogo,
                  size: 60, color: Colors.white.withOpacity(0.8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        campaign.title,
                        style: AppTextStyles.header2.copyWith(
                            fontSize: 18,
                            // DÜZELTME: Yazı rengi
                            color: isUnlocked
                                ? (isDark
                                    ? AppColors.textLight
                                    : AppColors.textPrimary)
                                : Colors.grey[600]),
                      ),
                    ),
                    if (!isUnlocked)
                      const Icon(Icons.lock, color: Colors.grey)
                    else
                      Icon(campaign.badgeIcon, color: campaign.brandColor),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  campaign.description,
                  style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      // DÜZELTME: Açıklama rengi
                      color: isUnlocked
                          ? (isDark
                              ? AppColors.textLightSecondary
                              : AppColors.textSecondary)
                          : Colors.grey[600]),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                            isUnlocked
                                ? Icons.check_circle
                                : Icons.info_outline,
                            size: 16,
                            color:
                                isUnlocked ? AppColors.success : Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          isUnlocked
                              ? "Rozetiniz Var"
                              : campaign.requirementText,
                          style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  isUnlocked ? AppColors.success : Colors.grey),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: isUnlocked
                          ? () => _showCouponQR(context, campaign, isDark)
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: campaign.brandColor,
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10)),
                      child: Text(isUnlocked ? "KULLAN" : "KİLİTLİ",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCouponQR(
      BuildContext context, CampaignModel campaign, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(campaign.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.header2.copyWith(
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary)),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors
                      .white, // QR her zaman beyaz zemin üstüne olsun okunabilirlik için
                  border: Border.all(color: campaign.brandColor, width: 4),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Icon(Icons.qr_code_2, size: 150, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Text("Kasa görevlisine okutunuz.",
                style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textLightSecondary
                        : AppColors.textSecondary)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, size: 16, color: AppColors.error),
                  SizedBox(width: 5),
                  Text("02:59",
                      style: TextStyle(
                          color: AppColors.error, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Kapat",
                  style: TextStyle(color: AppColors.textSecondary)))
        ],
      ),
    );
  }
}
