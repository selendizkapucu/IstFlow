class WalletModel {
  double maxWalletLimit; // En fazla kaç TL olabilir?
  String cardNumber; // Kart üzerindeki numara (Görsel amaçlı)
  String cardHolder; // Kart Sahibi

  WalletModel({
    this.maxWalletLimit = 2000.0,
    this.cardNumber = "TR88 0000 .... .... 1923",
    this.cardHolder = "IstFlow Wallet",
  });
}
