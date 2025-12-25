class TransferConstants {
  // Standart Tarife (Otobüs / Metro)
  static const double fullPrice = 17.70; // Tam
  static const double studentPrice = 8.64; // Öğrenci

  // Aktarma İndirim Oranları
  // İlk Basış: %100 ödenir (1.0)
  // Aktarma: %70 ödenir (0.70) -> %30 İndirim
  static const double firstBoardingMultiplier = 1.0;
  static const double transferMultiplier = 0.70;
}
