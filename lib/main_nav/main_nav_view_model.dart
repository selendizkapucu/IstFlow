import 'package:flutter/material.dart';
import 'main_nav_model.dart';

class MainNavViewModel extends ChangeNotifier {
  final MainNavModel _model = MainNavModel();

  // View'ın okuması için getter
  int get selectedIndex => _model.selectedIndex;

  // Sayfa değiştirme fonksiyonu
  void changeIndex(int index) {
    _model.selectedIndex = index;
    notifyListeners(); // Ekranı yenile
  }
}
