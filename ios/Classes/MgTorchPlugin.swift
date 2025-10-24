import Flutter
import UIKit
import AVFoundation

public class MgTorchPlugin: NSObject, FlutterPlugin {
  private var device: AVCaptureDevice?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.geciow.plugins.mgtorch/torch",
                                      binaryMessenger: registrar.messenger())
    let instance = MgTorchPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isTorchAvailable":
      result(isTorchAvailable())
    case "setTorch":
      guard let args = call.arguments as? [String: Any],
            let state = args["state"] as? Bool else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
        return
      }
      setTorch(enabled: state)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func isTorchAvailable() -> Bool {
    device = AVCaptureDevice.default(for: .video)
    return device?.hasTorch ?? false
  }

  private func setTorch(enabled: Bool) {
    guard let dev = device ?? AVCaptureDevice.default(for: .video), dev.hasTorch else { return }
    do {
      try dev.lockForConfiguration()
      if enabled {
        if dev.isTorchModeSupported(.on) {
          try dev.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
        } else {
          dev.torchMode = .on
        }
      } else {
        dev.torchMode = .off
      }
      dev.unlockForConfiguration()
    } catch {
      // ignore, no-op
    }
  }
}
