class RouteStopModel {
  final String time;
  final String station;
  final String status; // 'passed', 'current', 'future'

  RouteStopModel({
    required this.time,
    required this.station,
    required this.status,
  });
}

// --- MOCK DATA (SİMÜLASYON VERİLERİ) ---
class RouteData {
  static final List<RouteStopModel> m4Stops = [
    RouteStopModel(time: "10:00", station: "Kadıköy", status: "passed"),
    RouteStopModel(time: "10:03", station: "Ayrılık Çeşmesi", status: "passed"),
    RouteStopModel(time: "10:05", station: "Acıbadem", status: "passed"),
    RouteStopModel(time: "10:08", station: "Ünalan", status: "passed"),
    RouteStopModel(time: "10:11", station: "Göztepe", status: "passed"),
    RouteStopModel(time: "10:14", station: "Yenisahra", status: "passed"),
    RouteStopModel(time: "10:17", station: "Kozyatağı", status: "passed"),
    RouteStopModel(time: "10:20", station: "Bostancı", status: "passed"),
    RouteStopModel(time: "10:23", station: "Küçükyalı", status: "passed"),
    RouteStopModel(time: "10:26", station: "Maltepe", status: "current"), 
    RouteStopModel(time: "10:29", station: "Huzurevi", status: "future"),
    RouteStopModel(time: "10:32", station: "Gülsuyu", status: "future"),
    RouteStopModel(time: "10:35", station: "Esenkent", status: "future"),
    RouteStopModel(time: "10:38", station: "Hastane-Adliye", status: "future"),
    RouteStopModel(time: "10:42", station: "Soğanlık", status: "future"),
    RouteStopModel(time: "10:45", station: "Kartal", status: "future"),
    RouteStopModel(time: "10:48", station: "Yakacık-Adnan Kahveci", status: "future"),
    RouteStopModel(time: "10:52", station: "Pendik", status: "future"),
    RouteStopModel(time: "10:55", station: "Tavşantepe", status: "future"),
    RouteStopModel(time: "10:58", station: "Fevzi Çakmak-Hastane", status: "future"),
    RouteStopModel(time: "11:01", station: "Yayalar-Şeyhli", status: "future"),
    RouteStopModel(time: "11:05", station: "Kurtköy", status: "future"),
    RouteStopModel(time: "11:09", station: "Sabiha Gökçen H.L.", status: "future"),
  ];

  static final List<RouteStopModel> bus15fStops = [
    RouteStopModel(time: "08:45", station: "Beykoz", status: "passed"),
    RouteStopModel(time: "08:50", station: "Paşabahçe", status: "passed"),
    RouteStopModel(time: "08:55", station: "Çubuklu", status: "passed"),
    RouteStopModel(time: "09:00", station: "Kanlıca", status: "passed"),
    RouteStopModel(time: "09:05", station: "Anadolu Hisarı", status: "passed"),
    RouteStopModel(time: "09:10", station: "Kandilli", status: "passed"),
    RouteStopModel(time: "09:15", station: "Kuleli", status: "current"), 
    RouteStopModel(time: "09:20", station: "Çengelköy", status: "future"),
    RouteStopModel(time: "09:25", station: "Beylerbeyi", status: "future"),
    RouteStopModel(time: "09:35", station: "Kuzguncuk", status: "future"),
    RouteStopModel(time: "09:45", station: "Üsküdar", status: "future"),
    RouteStopModel(time: "10:00", station: "Kadıköy", status: "future"),
  ];

  static final List<RouteStopModel> marmarayStops = [
    RouteStopModel(time: "09:00", station: "Halkalı", status: "passed"),
    RouteStopModel(time: "09:38", station: "Sirkeci", status: "passed"),
    RouteStopModel(time: "09:42", station: "Üsküdar", status: "current"),
    RouteStopModel(time: "09:46", station: "Ayrılık Çeşmesi", status: "future"),
    RouteStopModel(time: "09:49", station: "Söğütlüçeşme", status: "future"),
    RouteStopModel(time: "09:52", station: "Feneryolu", status: "future"),
    RouteStopModel(time: "10:52", station: "Gebze", status: "future"),
  ];

  static final List<RouteStopModel> defaultStops = [
    RouteStopModel(time: "--:--", station: "Başlangıç Durağı", status: "passed"),
    RouteStopModel(time: "--:--", station: "Ara Durak", status: "current"),
    RouteStopModel(time: "--:--", station: "Varış Durağı", status: "future"),
  ];
}