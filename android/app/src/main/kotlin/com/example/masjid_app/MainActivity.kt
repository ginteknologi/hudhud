package com.example.masjid_app

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "hudhud/system_settings"
    private val locationChannelName = "hudhud/location"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, locationChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "getTimeZoneId") {
                    result.success(java.util.TimeZone.getDefault().id)
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                val intent = when (call.method) {
                    // Daftar app yang bebas dari optimasi baterai (Doze).
                    "openBatteryOptimizationSettings" -> Intent(
                        Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS
                    )
                    // Layar izin "Alarms & reminders" (Android 12+).
                    "openExactAlarmSettings" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).setData(
                            Uri.parse("package:$packageName")
                        )
                    } else {
                        null
                    }
                    else -> null
                }

                if (intent == null) {
                    result.success(false)
                    return@setMethodCallHandler
                }

                try {
                    startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                    result.success(true)
                } catch (e: Exception) {
                    // Sebagian ROM tidak punya layar ini — biar Dart pakai fallback.
                    result.success(false)
                }
            }
    }
}
