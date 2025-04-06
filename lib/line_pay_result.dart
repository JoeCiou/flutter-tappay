class LinePayResult {
  int status;
  String? recTradeId;
  String? bankTransactionId;
  String? orderNumber;

  LinePayResult({
    required this.status,
    this.recTradeId,
    this.bankTransactionId,
    this.orderNumber,
  });

  factory LinePayResult.fromJson(Map<String, dynamic> json) {
    return LinePayResult(
      status: json['status'] as int,
      recTradeId: json['recTradeId'] as String?,
      bankTransactionId: json['bankTransactionId'] as String?,
      orderNumber: json['orderNumber'] as String?,
    );
  }
}
