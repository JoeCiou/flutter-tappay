import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tappay/line_pay_result.dart';

import 'flutter_tappay_platform_interface.dart';

/// An implementation of [FlutterTappayPlatform] that uses method channels.
class MethodChannelFlutterTappay extends FlutterTappayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tappay');

  @override
  Future<void> setup({
    required int appId,
    required String appKey,
    required bool isProduction,
  }) {
    return methodChannel.invokeMethod('setup', {
      'appId': appId,
      'appKey': appKey,
      'isProduction': isProduction,
    });
  }

  @override
  Future<bool> isLinePayAvailable() {
    return methodChannel.invokeMethod<bool>('isLinePayAvailable').then((value) => value ?? false);
  }

  @override
  Future<void> installLineApp() {
    return methodChannel.invokeMethod('installLineApp');
  }

  @override
  Future<LinePayPrimeResult> getLinePayPrime({
    required String returnUrl,
  }) async {
    final json = await methodChannel.invokeMethod('getLinePayPrime', {
      'returnUrl': returnUrl,
    });

    return LinePayPrimeResult.fromJson(Map<String, Object>.from(json));
  }

  @override
  Future<LinePayRedirectionResult> redirectToLinePay({
    required String paymentUrl,
  }) async {
    final json = await methodChannel.invokeMethod('redirectToLinePay', {
      'paymentUrl': paymentUrl,
    });

    return LinePayRedirectionResult.fromJson(Map<String, Object>.from(json));
  }
}
