import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mg_torch_platform_interface.dart';

/// An implementation of [MgTorchPlatform] that uses method channels.
class MethodChannelMgTorch extends MgTorchPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mg_torch');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
