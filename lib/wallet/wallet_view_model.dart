import 'package:flutter/material.dart';
import 'wallet_model.dart';

class WalletViewModel extends ChangeNotifier {
  // Modelimiz
  final WalletModel model = WalletModel();

  // --- BAKİYE LİMİT KONTROLÜ ---

  // Artık bakiyeyi kendisi değiştirmiyor (Çünkü bakiye HomeViewModel'de merkezi duruyor).
  // Bu fonksiyonun tek görevi: "Bu işlem kurallara uygun mu?" diye bakmak.
  // String dönerse HATA mesajıdır, null dönerse ONAY verilmiştir.

  String? checkLimit(double currentBalance, double amount) {
    // 1. Limit Kontrolü
    if (currentBalance + amount > model.maxWalletLimit) {
      return "Hata! Cüzdan bakiyesi en fazla ₺${model.maxWalletLimit.toInt()} olabilir.";
    }

    return null; // Hata yok, işlem yapılabilir.
  }
}
