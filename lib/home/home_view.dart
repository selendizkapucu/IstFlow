import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'home_view_model.dart';
import '../widgets/transport_card.dart';
import '../transfer_calculator/transfer_calculator_view.dart';
import '../route_detail/route_detail_view.dart';
import '../campaigns/campaigns_view.dart';
import '../qr_payment/qr_payment_view.dart';
import '../main.dart'; // themeProvider için

import 'search_delegate.dart';

// PROVIDER TANIMI
final homeProvider = ChangeNotifierProvider.autoDispose<HomeViewModel>((ref) {
  return HomeViewModel();
});

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Verileri ve Temayı Dinliyoruz
    final viewModel = ref.watch(homeProvider);
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: Text("IstFlow",
            style: AppTextStyles.header1.copyWith(
                color: isDark ? AppColors.textLight : AppColors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CampaignsView()));
            },
            icon: Icon(Icons.card_giftcard,
                color: isDark ? AppColors.textLight : AppColors.secondary),
            tooltip: "Fırsatlar",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. SANAL ASİSTAN / ARAMA ÇUBUĞU ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: GestureDetector(
                onTap: () {
                 

                  // Arama motorunu çalıştır
                  showSearch(context: context, delegate: RouteSearchDelegate());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.cardBackgroundDark : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ]),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.secondary),
                      const SizedBox(width: 10),
                      Text(
                        "Hat veya durak ara...",
                        style: AppTextStyles.body.copyWith(
                            color: isDark ? Colors.white54 : Colors.grey),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.mic,
                            size: 20, color: AppColors.secondary),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // --- 2. UYARI KUTUSU ---
            if (viewModel.isAlertVisible) _buildAlertBox(viewModel),

            const SizedBox(height: 10),

            // --- 3. KARTLAR ---
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: viewModel.myCards.length,
                itemBuilder: (context, index) {
                  final card = viewModel.myCards[index];
                  return GestureDetector(
                    onTap: () {
                      if (card.isOwned) {
                        _showTopUpModal(context, viewModel, index, isDark);
                      } else {
                        _showBuyCardDialog(context, viewModel, index, isDark);
                      }
                    },
                    child: TransportCard(
                      cardName: card.name,
                      balance: card.balance,
                      cardNumber: card.number,
                      cardColor: card.color,
                      isOwned: card.isOwned,
                      cardPrice: card.price,
                    ),
                  );
                },
              ),
            ),

            // --- 4. KISAYOLLAR ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sık Kullanılanlar",
                      style: AppTextStyles.header2.copyWith(
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary)),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const TransferCalculatorModal(),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calculate,
                            size: 16,
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.primary),
                        const SizedBox(width: 4),
                        Text("Aktarma Hesapla",
                            style: AppTextStyles.caption.copyWith(
                                color: isDark
                                    ? AppColors.textLight
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- 5. FAVORİ HATLAR ---
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: viewModel.favorites.length,
                itemBuilder: (context, index) {
                  final fav = viewModel.favorites[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RouteDetailView(lineName: fav.name)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: Column(children: [
                        CircleAvatar(
                            radius: 28,
                            backgroundColor: fav.color.withOpacity(0.2),
                            child: Icon(fav.icon, color: fav.color)),
                        const SizedBox(height: 5),
                        Text(fav.name,
                            style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textLightSecondary
                                    : AppColors.textPrimary))
                      ]),
                    ),
                  );
                },
              ),
            ),

            // --- 6. SON HAREKETLER ---
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Son Hareketler",
                    style: AppTextStyles.header2.copyWith(
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textPrimary))),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: viewModel.transactions.length,
              itemBuilder: (context, index) {
                final item = viewModel.transactions[index];
                return GestureDetector(
                  onTap: () {
                    if (!item.isTopUp) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RouteDetailView(lineName: item.title)));
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardBackgroundDark
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2))
                        ]),
                    child: ListTile(
                      leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: item.color.withOpacity(0.1),
                              shape: BoxShape.circle),
                          child: Icon(item.icon, color: item.color)),
                      title: Text(item.title,
                          style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textLight
                                  : AppColors.textPrimary)),
                      subtitle: Text(item.time,
                          style: AppTextStyles.caption.copyWith(
                              color: isDark
                                  ? AppColors.textLightSecondary
                                  : AppColors.textSecondary)),
                      trailing: Text(item.price,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: item.isTopUp
                                  ? AppColors.success
                                  : AppColors.error)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QrPaymentView()));
        },
        backgroundColor: AppColors.qrButton,
        icon: const Icon(Icons.qr_code_scanner, color: AppColors.textLight),
        label: const Text("QR Okut",
            style: TextStyle(
                color: AppColors.textLight, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- YARDIMCI WIDGETLAR (Aynen korundu) ---

  // (Aşağıdaki _buildAlertBox, _showBuyCardDialog, _showTopUpModal,
  // _buildMoneyButton ve _showErrorDialog metotlarını bir önceki
  // gönderdiğim "Tam Kod"dan alabilirsin, onlar değişmedi.)

  // Kodun çok uzun olmaması için sadece değişen kısmı (yukarıyı) attım
  // ama istersen onları da buraya ekleyip bütün bir dosya yapabilirsin.

  // ŞUNU UNUTMA:
  // Eğer copy-paste yaparken aşağıdakiler silinirse, bir önceki cevabımdaki
  // "lib/home/home_view.dart (Tam Kod)" kısmının alt tarafını kopyalayıp
  // buranın altına yapıştırabilirsin.

  Widget _buildAlertBox(HomeViewModel viewModel) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.error.withOpacity(0.5))),
      child: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: AppColors.error),
        const SizedBox(width: 10),
        const Expanded(
            child: Text(
                "M4 Hattında teknik arıza nedeniyle seferler gecikmelidir.",
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                    fontWeight: FontWeight.bold))),
        InkWell(
            onTap: () => viewModel.closeAlert(),
            child: const Icon(Icons.close, size: 18, color: AppColors.error))
      ]),
    );
  }

  void _showBuyCardDialog(
      BuildContext context, HomeViewModel viewModel, int index, bool isDark) {
    final card = viewModel.myCards[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        title: Text("${card.name} Satın Al",
            style: AppTextStyles.header2.copyWith(
                color: isDark ? AppColors.textLight : AppColors.textPrimary)),
        content: Text(
            "Bu kartı ₺${card.price} karşılığında satın almak istiyor musunuz?",
            style: AppTextStyles.body.copyWith(
                color: isDark
                    ? AppColors.textLightSecondary
                    : AppColors.textPrimary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Vazgeç",
                  style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              bool success = viewModel.buyCard(index);
              Navigator.pop(ctx);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColors.success,
                    content: Text("${card.name} başarıyla satın alındı!")));
              } else {
                _showErrorDialog(context, isDark);
              }
            },
            child:
                const Text("Satın Al", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTopUpModal(
      BuildContext context, HomeViewModel viewModel, int index, bool isDark) {
    final card = viewModel.myCards[index];
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
            Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            Text("${card.name} Bakiye Yükle",
                style: AppTextStyles.header2.copyWith(
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary)),
            const SizedBox(height: 10),
            Text("Mevcut: ${card.balance}",
                style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textLightSecondary
                        : AppColors.textSecondary)),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _buildMoneyButton(context, viewModel, index, 50, isDark),
              _buildMoneyButton(context, viewModel, index, 100, isDark),
              _buildMoneyButton(context, viewModel, index, 200, isDark),
            ]),
          ]),
        );
      },
    );
  }

  Widget _buildMoneyButton(BuildContext context, HomeViewModel viewModel,
      int index, int amount, bool isDark) {
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
                  "Bu karta ₺$amount yüklemek istediğinize emin misiniz?",
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
                    Navigator.pop(dialogContext);
                    bool success = viewModel.topUpCard(index, amount);
                    Navigator.pop(context);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColors.success,
                          content: Text("₺$amount başarıyla yüklendi.")));
                    } else {
                      _showErrorDialog(context, isDark);
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
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Text("₺$amount",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  void _showErrorDialog(BuildContext context, bool isDark) {
    showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
                backgroundColor: isDark
                    ? AppColors.cardBackgroundDark
                    : AppColors.cardBackground,
                title: Text("Yetersiz Bakiye",
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black)),
                content: Text("Ana Cüzdan bakiyeniz yetersiz.",
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Tamam"))
                ]));
  }
}
