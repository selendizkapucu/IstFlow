import 'package:flutter/material.dart';

// Kart Modeli
class TransportCardModel {
  String name;
  String balance;
  String number;
  Color color;
  bool isOwned;
  double price;

  TransportCardModel({
    required this.name,
    required this.balance,
    required this.number,
    required this.color,
    required this.isOwned,
    required this.price,
  });
}

// İşlem Geçmişi Modeli
class TransactionModel {
  String title;
  String time;
  String price;
  IconData icon;
  Color color;
  bool isTopUp; // Yükleme mi harcama mı?

  TransactionModel({
    required this.title,
    required this.time,
    required this.price,
    required this.icon,
    required this.color,
    this.isTopUp = false,
  });
}

// Favori Hat Modeli
class FavoriteLineModel {
  String name;
  Color color;
  IconData icon;

  FavoriteLineModel({
    required this.name,
    required this.color,
    required this.icon,
  });
}
