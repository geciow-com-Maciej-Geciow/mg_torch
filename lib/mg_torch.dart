import 'dart:io';
import 'package:flutter/services.dart';

class MgTorch {
  static const MethodChannel _channel =
      MethodChannel('com.geciow.plugins.mgtorch/torch');

  /// Returns true if a torch (flash) exists on the device.
  static Future<bool> isAvailable() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return false;
    try {
      final res = await _channel.invokeMethod<bool>('isTorchAvailable');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Sets the torch on/off.
  static Future<void> set(bool enabled) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    try {
      await _channel.invokeMethod('setTorch', {'state': enabled});
    } catch (_) {
      // no-op
    }
  }

  static Future<void> enable() => set(true);
  static Future<void> disable() => set(false);
}
