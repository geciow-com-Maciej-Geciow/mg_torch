import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mg_torch_method_channel.dart';

abstract class MgTorchPlatform extends PlatformInterface {
  /// Constructs a MgTorchPlatform.
  MgTorchPlatform() : super(token: _token);

  static final Object _token = Object();

  static MgTorchPlatform _instance = MethodChannelMgTorch();

  /// The default instance of [MgTorchPlatform] to use.
  ///
  /// Defaults to [MethodChannelMgTorch].
  static MgTorchPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MgTorchPlatform] when
  /// they register themselves.
  static set instance(MgTorchPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
