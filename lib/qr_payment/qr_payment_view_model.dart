import 'package:flutter/material.dart';
import 'qr_payment_model.dart';

class QrPaymentViewModel extends ChangeNotifier {
  // Ödeme İşlemini Simüle Et
  // Geriye bir "Model" döndürür (QrPaymentResult)
  Future<QrPaymentResult> processPayment() async {
    // Gerçek bir senaryoda burada API isteği olurdu
    // Simülasyon için 1 saniye bekletiyoruz (Sanki sunucuya bağlanıyor gibi)
    await Future.delayed(const Duration(seconds: 1));

    // Başarılı sonuç döndür
    // (Not: İleride burayı HomeViewModel'deki bakiyeden düşecek şekilde geliştirebiliriz)
    return QrPaymentResult(
      amount: 15.00,
      message: "Geçiş Başarılı!",
      isSuccess: true,
    );
  }
}
