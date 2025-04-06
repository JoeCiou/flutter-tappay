import 'package:flutter_tappay/line_pay_result.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tappay_method_channel.dart';

abstract class FlutterTappayPlatform extends PlatformInterface {
  /// Constructs a FlutterTappayPlatform.
  FlutterTappayPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTappayPlatform _instance = MethodChannelFlutterTappay();

  /// The default instance of [FlutterTappayPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTappay].
  static FlutterTappayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTappayPlatform] when
  /// they register themselves.
  static set instance(FlutterTappayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setup({
    required int appId,
    required String appKey,
    required bool isProduction,
  }) {
    throw UnimplementedError('setup() has not been implemented.');
  }

  Future<bool> isLinePayAvailable() {
    throw UnimplementedError('isLinePayAvailable() has not been implemented.');
  }

  Future<void> installLineApp() {
    throw UnimplementedError('installLineApp() has not been implemented.');
  }

  Future<void> getLinePayPrime({
    required String returnUrl,
    required void Function(String prime) onSuccess,
    required void Function(int code, String message) onFailure,
  }) {
    throw UnimplementedError('getLinePayPrime() has not been implemented.');
  }

  Future<LinePayResult> redirectToLinePay({
    required String paymentUrl,
    required void Function(LinePayResult result) onException,
  }) {
    throw UnimplementedError('redirectToLinePay() has not been implemented.');
  }
}
