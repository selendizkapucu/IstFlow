import 'package:flutter/material.dart';
import 'nfc_model.dart';

class NfcViewModel extends ChangeNotifier {
  // Tarama işlemini başlatan fonksiyon
  // Geriye bir "Model" döndürür (Bulunan kart verisi)
  Future<NfcResultModel> startScanSimulation() async {
    // Gerçek senaryoda burada NFC okuyucu paketi (flutter_nfc_kit vb.) çalışır.
    // Biz simülasyon için 3 saniye bekletiyoruz (Sanki kartı okuyor gibi)
    await Future.delayed(const Duration(seconds: 3));

    // Sanki kart bulunmuş gibi veriyi döndür
    return NfcResultModel(
      cardId: "8821-3342",
      balance: "₺ 56.40",
    );
  }
}
