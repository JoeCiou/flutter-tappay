import 'package:flutter_tappay/line_pay_result.dart';

import 'flutter_tappay_platform_interface.dart';

class FlutterTappay {
  static FlutterTappay instance = FlutterTappay._();

  FlutterTappay._();

  Future<void> setup({
    required int appId,
    required String appKey,
    required bool isProduction,
  }) async {
    return FlutterTappayPlatform.instance.setup(
      appId: appId,
      appKey: appKey,
      isProduction: isProduction,
    );
  }

  Future<bool> isLinePayAvailable() {
    return FlutterTappayPlatform.instance.isLinePayAvailable();
  }

  Future<void> installLineApp() {
    return FlutterTappayPlatform.instance.installLineApp();
  }

  Future<void> getLinePayPrime({
    required String returnUrl,
    required void Function(String prime) onSuccess,
    required void Function(int code, String message) onFailure,
  }) {
    return FlutterTappayPlatform.instance.getLinePayPrime(
      returnUrl: returnUrl,
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
  }

  Future<LinePayResult> redirectToLinePay({
    required String paymentUrl,
    required void Function(LinePayResult result) onException,
  }) {
    return FlutterTappayPlatform.instance.redirectToLinePay(
      paymentUrl: paymentUrl,
      onException: onException,
    );
  }
}
