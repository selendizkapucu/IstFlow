import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'home_model.dart';

class HomeViewModel extends ChangeNotifier {
  // --- DURUM DEĞİŞKENLERİ ---

  // 1. DÜZELTME: Bakiye Yönetimi
  // Eskiden dışarıda 'ValueNotifier' olarak duruyordu.
  // Artık sınıfın kendi mülkü oldu. Riverpod bunu koruyacak.
  double walletBalance = 500.0;

  bool isAlertVisible = true;

  // Kart Listesi
  List<TransportCardModel> myCards = [
    TransportCardModel(
      name: "Öğrenci Kartı",
      balance: "₺ 15.00",
      number: "8842",
      color: AppColors.cardStudent,
      isOwned: true,
      price: 0.0,
    ),
    TransportCardModel(
      name: "Tam Kart",
      balance: "₺ 0.00",
      number: "----",
      color: AppColors.cardFull,
      isOwned: false,
      price: 50.0,
    ),
    TransportCardModel(
      name: "Anne Kartı",
      balance: "₺ 0.00",
      number: "----",
      color: AppColors.cardMother,
      isOwned: false,
      price: 75.0,
    ),
  ];

  // İşlem Geçmişi
  List<TransactionModel> transactions = [
    TransactionModel(
      title: "M4 Kadıköy Metro",
      time: "10:30",
      price: "- ₺ 15.00",
      icon: Icons.subway,
      color: Colors.redAccent,
    ),
    TransactionModel(
      title: "15F Otobüs",
      time: "09:15",
      price: "- ₺ 12.00",
      icon: Icons.directions_bus,
      color: Colors.orange,
    ),
    TransactionModel(
      title: "Marmaray",
      time: "Dün",
      price: "- ₺ 25.00",
      icon: Icons.train,
      color: Colors.blue,
    ),
    TransactionModel(
      title: "Bakiye Yükleme",
      time: "Dün",
      price: "+ ₺ 200.00",
      icon: Icons.add_card,
      color: Colors.green,
      isTopUp: true,
    ),
  ];

  // Favoriler
  List<FavoriteLineModel> favorites = [
    FavoriteLineModel(name: "M4", color: Colors.redAccent, icon: Icons.subway),
    FavoriteLineModel(
        name: "15F", color: Colors.orange, icon: Icons.directions_bus),
    FavoriteLineModel(name: "Marmaray", color: Colors.blue, icon: Icons.train),
    FavoriteLineModel(
        name: "500T", color: Colors.green, icon: Icons.directions_bus),
  ];

  // --- FONKSİYONLAR ---

  // Uyarıyı kapat
  void closeAlert() {
    isAlertVisible = false;
    notifyListeners();
  }

  // Kart Satın Alma
  bool buyCard(int index) {
    final card = myCards[index];

    // walletBalance artık sınıfın içinde olduğu için direkt erişiyoruz
    if (walletBalance >= card.price) {
      walletBalance -= card.price;

      // Kartı güncelle
      myCards[index].isOwned = true;
      myCards[index].balance = "₺ 0.00";
      myCards[index].number = (1000 + index * 55).toString();

      notifyListeners(); // Arayüze "Bakiye ve Kart değişti" diye haber ver
      return true;
    }
    return false;
  }

  // Bakiye Yükleme
  bool topUpCard(int index, int amount) {
    if (walletBalance >= amount) {
      walletBalance -= amount;

      // Mevcut bakiyeyi sayıya çevir, ekle, tekrar yazıya çevir
      double currentBalance =
          double.parse(myCards[index].balance.replaceAll('₺', '').trim());
      double newBalance = currentBalance + amount;

      myCards[index].balance = "₺ ${newBalance.toStringAsFixed(2)}";

      notifyListeners();
      return true;
    }
    return false;
  }
}
