import 'package:flutter_tappay/line_pay_result.dart';

import 'flutter_tappay_platform_interface.dart';
export 'line_pay_result.dart';

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

  Future<LinePayPrimeResult> getLinePayPrime({
    required String returnUrl,
  }) {
    return FlutterTappayPlatform.instance.getLinePayPrime(
      returnUrl: returnUrl,
    );
  }

  Future<LinePayRedirectionResult> redirectToLinePay({
    required String paymentUrl,
  }) {
    return FlutterTappayPlatform.instance.redirectToLinePay(
      paymentUrl: paymentUrl,
    );
  }
}
