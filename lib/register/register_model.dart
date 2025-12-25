class RegisterModel {
  String name;
  String cardNumber;
  String birthYear;
  String occupation;
  String email;
  String password;

  RegisterModel({
    required this.name,
    required this.cardNumber,
    required this.birthYear,
    required this.occupation,
    required this.email,
    required this.password,
  });
}

// Sabit Meslek Listesi (İstersen veritabanından da gelebilir)
class RegisterConstants {
  static const List<String> occupations = [
    "Öğrenci",
    "Çalışan",
    "Emekli",
    "Sivil"
  ];
}
