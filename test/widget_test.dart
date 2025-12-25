import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Ana uygulama dosyamızı import ediyoruz
import 'package:istflow/main.dart';

void main() {
  testWidgets('Uygulama açılış testi', (WidgetTester tester) async {
    // 1. Uygulamayı sanal ortamda başlat (MyApp yerine IstFlowApp kullanıyoruz)
    await tester.pumpWidget(const IstFlowApp());

    // 2. Animasyonların bitmesini ve sayfanın tam yüklenmesini bekle
    await tester.pumpAndSettle();

    // 3. DOĞRULAMA ADIMLARI

    // Ekranda "IstFlow" yazan bir metin var mı?
    // (Login ekranındaki başlık veya logo altındaki yazı)
    expect(find.text('IstFlow'), findsOneWidget); // En az bir tane bulmalı

    // Ekranda "Giriş Yap" yazan bir buton veya metin var mı?
    expect(find.text('Giriş Yap'),
        findsWidgets); // Birden fazla bulabilir (AppBar + Buton)

    // Sayaç uygulamasındaki '0' rakamı artık OLMAMALI
    expect(find.text('0'), findsNothing);
  });
}
