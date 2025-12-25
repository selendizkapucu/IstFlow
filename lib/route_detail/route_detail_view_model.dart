import 'package:flutter/material.dart';
import 'route_detail_model.dart';

class RouteDetailViewModel extends ChangeNotifier {
  List<RouteStopModel> currentStops = [];
  String lineName = "";

  // SEÇİM DURUMLARI
  int? selectedStartIndex; // Biniş Durağı İndeksi
  int? selectedEndIndex; // İniş Durağı İndeksi

  // ALARM DURUMU
  bool isAlarmSet = false;

  // --- HESAPLAMALAR (GETTERS) ---

  // Seçim tamamlandı mı?
  bool get isRouteSelected =>
      selectedStartIndex != null && selectedEndIndex != null;

  // Kaç durak gidecek?
  int get tripStopCount {
    if (!isRouteSelected) return 0;
    return (selectedEndIndex! - selectedStartIndex!).abs();
  }

  // Tahmini süre (Her durak 2 dk)
  int get tripDurationMinutes => tripStopCount * 2;

  // --- YENİ: VARIŞ SAATİ HESAPLAMA ---
  // Şu anki saate yolculuk süresini ekler
  String get estimatedArrivalTime {
    if (!isRouteSelected) return "--:--";

    final now = DateTime.now();
    final arrival = now.add(Duration(minutes: tripDurationMinutes));

    // Saati ve dakikayı formatla (Örn: 9:5 -> 09:05)
    String hour = arrival.hour.toString().padLeft(2, '0');
    String minute = arrival.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  // --- FONKSİYONLAR ---

  void loadRoute(String name) {
    lineName = name;

    if (lineName.contains("M4")) {
      currentStops = RouteData.m4Stops;
    } else if (lineName.contains("15F")) {
      currentStops = RouteData.bus15fStops;
    } else if (lineName.contains("Marmaray")) {
      currentStops = RouteData.marmarayStops;
    } else {
      currentStops = RouteData.defaultStops;
    }

    // Sayfa açılınca her şeyi sıfırla
    selectedStartIndex = null;
    selectedEndIndex = null;
    isAlarmSet = false;

    notifyListeners();
  }

  void selectStop(int index) {
    if (isAlarmSet) isAlarmSet = false; // Seçim değişirse alarmı kapat

    if (selectedStartIndex == null) {
      selectedStartIndex = index;
    } else if (selectedEndIndex == null) {
      if (index <= selectedStartIndex!) {
        selectedStartIndex = index;
      } else {
        selectedEndIndex = index;
      }
    } else {
      selectedStartIndex = index;
      selectedEndIndex = null;
    }
    notifyListeners();
  }

  void toggleAlarm() {
    isAlarmSet = !isAlarmSet;
    notifyListeners();
  }
}
