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
  Future<void> getLinePayPrime({
    required String returnUrl,
    required void Function(String prime) onSuccess,
    required void Function(int code, String message) onFailure,
  }) {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'onLinePayCallback') {
        if (call.arguments['status'] == 'success') {
          final String prime = call.arguments['prime'];
          onSuccess(prime);
        } else if (call.arguments['status'] == 'failure') {
          final int code = call.arguments['code'];
          final String message = call.arguments['message'];
          onFailure(code, message);
        }
      }
    });
    return methodChannel.invokeMethod('getLinePayPrime', {
      'returnUrl': returnUrl,
    });
  }

  @override
  Future<LinePayResult> redirectToLinePay({
    required String paymentUrl,
    required void Function(LinePayResult result) onException,
  }) async {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'onLinePayException') {
        final LinePayResult result = LinePayResult.fromJson(call.arguments);
        onException(result);
      }
    });
    final json = await methodChannel.invokeMethod('redirectToLinePay', {
      'paymentUrl': paymentUrl,
    });

    return LinePayResult.fromJson(Map<String, Object>.from(json));
  }
}
