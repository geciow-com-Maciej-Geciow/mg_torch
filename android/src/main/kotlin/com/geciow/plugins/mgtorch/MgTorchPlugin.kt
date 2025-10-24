package com.geciow.plugins.mgtorch

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MgTorchPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var cameraManager: CameraManager? = null
    private var flashCameraId: String? = null
    private var appContext: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.geciow.plugins.mgtorch/torch")
        channel.setMethodCallHandler(this)
        appContext = binding.applicationContext
        cameraManager = appContext?.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        flashCameraId = firstBackCameraWithFlash()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isTorchAvailable" -> result.success(isTorchAvailable())
            "setTorch" -> {
                val state = call.argument<Boolean>("state") ?: false
                setTorch(state)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun firstBackCameraWithFlash(): String? {
        val cm = cameraManager ?: return null
        return try {
            cm.cameraIdList.firstOrNull { id ->
                val c = cm.getCameraCharacteristics(id)
                val hasFlash = c.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
                val facing = c.get(CameraCharacteristics.LENS_FACING)
                hasFlash && facing == CameraCharacteristics.LENS_FACING_BACK
            } ?: cm.cameraIdList.firstOrNull { id ->
                cm.getCameraCharacteristics(id)
                    .get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
            }
        } catch (_: Exception) { null }
    }

    private fun isTorchAvailable(): Boolean {
        return try {
            (flashCameraId ?: firstBackCameraWithFlash())?.let { id ->
                cameraManager?.getCameraCharacteristics(id)
                    ?.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
            } ?: false
        } catch (_: Exception) { false }
    }

    private fun setTorch(enabled: Boolean) {
        try {
            val id = flashCameraId ?: firstBackCameraWithFlash() ?: return
            cameraManager?.setTorchMode(id, enabled)
        } catch (_: Exception) { /* ignore */ }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        appContext = null
        cameraManager = null
        flashCameraId = null
    }
}
