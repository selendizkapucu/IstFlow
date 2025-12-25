import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'route_detail_view_model.dart';
import 'route_detail_model.dart';
import '../main.dart'; // themeProvider için

// PROVIDER TANIMI
final routeDetailProvider = ChangeNotifierProvider.autoDispose
    .family<RouteDetailViewModel, String>((ref, lineName) {
  return RouteDetailViewModel()..loadRoute(lineName);
});

class RouteDetailView extends ConsumerWidget {
  final String lineName;

  const RouteDetailView({super.key, required this.lineName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(routeDetailProvider(lineName));
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,

      // APP BAR
      appBar: AppBar(
        title: Text(viewModel.lineName,
            style: AppTextStyles.header2.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme:
            IconThemeData(color: isDark ? Colors.white : AppColors.textPrimary),
      ),

      body: Column(
        children: [
          // 2. ÜST BİLGİ (YÖNLENDİRME)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white10
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    viewModel.isRouteSelected ? Icons.check_circle : Icons.info,
                    color: isDark ? AppColors.textLight : AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    viewModel.isRouteSelected
                        ? "Rota Planlandı"
                        : (viewModel.selectedStartIndex == null
                            ? "BİNİŞ durağını seçin"
                            : "İNİŞ durağını seçin"),
                    style: AppTextStyles.header2.copyWith(
                        color: isDark ? AppColors.textLight : AppColors.primary,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // 3. LİSTE (TIMELINE)
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.currentStops.length,
              itemBuilder: (context, index) {
                final stop = viewModel.currentStops[index];

                // --- GÖRSEL MANTIK ---
                bool isStart = index == viewModel.selectedStartIndex;
                bool isEnd = index == viewModel.selectedEndIndex;

                bool isBetween = false;
                if (viewModel.selectedStartIndex != null &&
                    viewModel.selectedEndIndex != null) {
                  isBetween = index > viewModel.selectedStartIndex! &&
                      index < viewModel.selectedEndIndex!;
                }

                // Renkler
                Color nodeColor;
                if (isStart) {
                  nodeColor = AppColors.success; // Yeşil
                } else if (isEnd) {
                  nodeColor = AppColors.error; // Kırmızı
                } else if (isBetween) {
                  nodeColor = AppColors.secondary; // Mavi
                } else {
                  nodeColor = isDark
                      ? Colors.grey.shade700
                      : Colors.grey.shade400; // Pasif
                }

                // Yazı Rengi
                Color textColor = (isStart || isEnd || isBetween)
                    ? (isDark ? Colors.white : AppColors.textPrimary)
                    : (isDark ? Colors.white38 : Colors.grey);

                return InkWell(
                  onTap: () {
                    ref.read(routeDetailProvider(lineName)).selectStop(index);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // A. SAAT / DURUM
                          SizedBox(
                            width: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isStart
                                      ? "BİNİŞ"
                                      : (isEnd ? "İNİŞ" : stop.time),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (isStart || isEnd) ? 14 : 12,
                                    color: (isStart || isEnd)
                                        ? nodeColor
                                        : textColor,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                // Alarm İkonu
                                if (isEnd && viewModel.isAlarmSet)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Icon(Icons.notifications_active,
                                        size: 16, color: AppColors.error),
                                  )
                              ],
                            ),
                          ),

                          const SizedBox(width: 15),

                          // B. ÇİZGİ VE NOKTA
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                    width: 3,
                                    color: index == 0
                                        ? Colors.transparent
                                        : (isBetween || isEnd
                                            ? AppColors.secondary
                                            : (isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade300))),
                              ),
                              Icon(
                                (isStart || isEnd)
                                    ? Icons.radio_button_checked
                                    : Icons.circle,
                                color: nodeColor,
                                size: (isStart || isEnd) ? 24 : 14,
                              ),
                              Expanded(
                                child: Container(
                                    width: 3,
                                    color: index ==
                                            viewModel.currentStops.length - 1
                                        ? Colors.transparent
                                        : (isBetween || isStart
                                            ? AppColors.secondary
                                            : (isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade300))),
                              ),
                            ],
                          ),

                          const SizedBox(width: 15),

                          // C. DURAK ADI
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                stop.station,
                                style: AppTextStyles.body.copyWith(
                                    fontWeight: (isStart || isEnd)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: (isStart || isEnd) ? 18 : 16,
                                    color: textColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- 4. ALT HESAPLAMA VE ALARM PANELİ ---
          if (viewModel.isRouteSelected)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardBackgroundDark
                      : AppColors.cardBackground,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, -5))
                  ]),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // İstatistikler (Tutar yerine Varış Saati geldi)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoColumn(
                            "Durak", "${viewModel.tripStopCount}", isDark),
                        Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey.withOpacity(0.3)),
                        _buildInfoColumn("Süre",
                            "${viewModel.tripDurationMinutes} dk", isDark),
                        Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey.withOpacity(0.3)),

                        // YENİ: Varış Saati (Önemli olan bu)
                        _buildInfoColumn(
                            "Varış", viewModel.estimatedArrivalTime, isDark,
                            isHighlight: true),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ALARM BUTONU
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(routeDetailProvider(lineName)).toggleAlarm();

                          if (!viewModel.isAlarmSet) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Alarm kuruldu! İneceğiniz durağa yaklaşınca haber vereceğim."),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: viewModel.isAlarmSet
                                ? AppColors.error
                                : AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        icon: Icon(
                          viewModel.isAlarmSet
                              ? Icons.notifications_off
                              : Icons.notifications_active,
                          color: Colors.white,
                        ),
                        label: Text(
                          viewModel.isAlarmSet
                              ? "Alarmı İptal Et"
                              : "İnilecek Durak Alarmı Kur",
                          style: AppTextStyles.header2
                              .copyWith(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, bool isDark,
      {bool isHighlight = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey, fontSize: 12)),
        const SizedBox(height: 3),
        Text(value,
            style: AppTextStyles.header1.copyWith(
                color: isHighlight
                    ? AppColors.secondary
                    : (isDark ? Colors.white : AppColors.textPrimary),
                fontSize: 20)),
      ],
    );
  }
}
