enum LinePayPrimeResultStatus {
  success,
  failure,
}

class LinePayPrimeResult {
  final LinePayPrimeResultStatus status;
  final String? prime;
  final int? code;
  final String? message;

  LinePayPrimeResult({
    required this.status,
    this.prime,
    this.code,
    this.message,
  });

  factory LinePayPrimeResult.fromJson(Map<String, dynamic> json) {
    return LinePayPrimeResult(
      status: LinePayPrimeResultStatus.values.byName(json['status'] as String),
      prime: json['prime'] as String?,
      code: json['code'] as int?,
      message: json['message'] as String?,
    );
  }
}

class LinePayRedirectionResult {
  int status;
  String? recTradeId;
  String? bankTransactionId;
  String? orderNumber;

  LinePayRedirectionResult({
    required this.status,
    this.recTradeId,
    this.bankTransactionId,
    this.orderNumber,
  });

  factory LinePayRedirectionResult.fromJson(Map<String, dynamic> json) {
    return LinePayRedirectionResult(
      status: json['status'] as int,
      recTradeId: json['recTradeId'] as String?,
      bankTransactionId: json['bankTransactionId'] as String?,
      orderNumber: json['orderNumber'] as String?,
    );
  }
}
