import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart'; // Merkezi renk dosyamız
import '../core/constants/app_text_styles.dart'; // Merkezi yazı stili dosyamız

class TransportCard extends StatelessWidget {
  final String cardName;
  final String balance;
  final String cardNumber;
  final Color cardColor;
  final bool isOwned;
  final double cardPrice;

  const TransportCard({
    super.key,
    required this.cardName,
    required this.balance,
    required this.cardNumber,
    required this.cardColor,
    required this.isOwned,
    required this.cardPrice,
  });

  @override
  Widget build(BuildContext context) {
    // EĞER KART SATIN ALINMAMIŞSA RENGİ SOLUKLAŞTIR (%50 Opaklık)
    final Color displayColor = isOwned ? cardColor : cardColor.withOpacity(0.5);

    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 300,
      decoration: BoxDecoration(
        color: displayColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // Gölge de kartın rengine göre (sahip değilse silik gölge)
            color: displayColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // --- ARKA PLAN DEKORU (HALKALAR) ---
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),

          // --- KART İÇERİĞİ ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. ÜST KISIM (Kart Adı ve İkon)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardName,
                      // Merkezi beyaz renk kullanıyoruz
                      style: AppTextStyles.header2
                          .copyWith(color: AppColors.textLight),
                    ),
                    const Icon(Icons.nfc,
                        // Hafif silik beyaz
                        color: AppColors.textLightSecondary),
                  ],
                ),

                // 2. ORTA KISIM (Bakiye veya Fiyat)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOwned ? "Bakiye" : "Kart Ücreti",
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textLightSecondary),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isOwned ? balance : "₺ $cardPrice",
                      style: AppTextStyles.header1
                          .copyWith(color: AppColors.textLight, fontSize: 32),
                    ),
                  ],
                ),

                // 3. ALT KISIM (Kart No ve Satın Al Butonu)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardNumber,
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.textLightSecondary,
                          letterSpacing: 2),
                    ),

                    // Eğer kart bizde yoksa "SATIN AL" butonu göster
                    if (!isOwned)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.textLight, // Beyaz arka plan
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "SATIN AL",
                          style: AppTextStyles.caption.copyWith(
                              // Yazı rengi kartın orijinal rengi olsun (Dikkat çeksin)
                              color: cardColor,
                              fontWeight: FontWeight.bold),
                        ),
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
}
