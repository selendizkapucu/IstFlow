import 'package:flutter/material.dart';
import 'transfer_calculator_model.dart';

class TransferCalculatorViewModel extends ChangeNotifier {
  // Durumlar
  bool _isStudent = false; // Öğrenci mi?
  bool _isTransfer = false; // Aktarma mı? (False = İlk Basış, True = Aktarma)

  // Getterlar
  bool get isStudent => _isStudent;
  bool get isTransfer => _isTransfer;

  // Hesaplanan Tutar
  double get calculatedPrice {
    // 1. Baz Fiyat (Öğrenci / Tam)
    double basePrice = _isStudent
        ? TransferConstants.studentPrice
        : TransferConstants.fullPrice;

    // 2. Çarpan (İlk Basış / Aktarma)
    double multiplier = _isTransfer
        ? TransferConstants.transferMultiplier
        : TransferConstants.firstBoardingMultiplier;

    return basePrice * multiplier;
  }

  // --- Fonksiyonlar ---

  // Kart Tipini Değiştir
  void toggleCardType(bool value) {
    _isStudent = value;
    notifyListeners();
  }

  // Aktarma Durumunu Değiştir
  void toggleTransfer(bool value) {
    _isTransfer = value;
    notifyListeners();
  }
}
