class QrPaymentResult {
  final double amount;
  final String message;
  final bool isSuccess;

  QrPaymentResult({
    required this.amount,
    required this.message,
    required this.isSuccess,
  });
}
