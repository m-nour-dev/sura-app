package com.sura.app.sura_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "com.sura.adhan/channel"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"playAdhan" -> {
					val sound = call.argument<String>("sound") ?: "adhan_egypt"
					val intent = Intent(this, AdhanService::class.java)
					intent.putExtra("sound", sound)
					if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
						startForegroundService(intent)
					} else {
						startService(intent)
					}
					result.success(true)
				}
				"stopAdhan" -> {
					val intent = Intent(this, AdhanService::class.java)
					intent.action = "STOP_ADHAN"
					if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
						startForegroundService(intent)
					} else {
						startService(intent)
					}
					result.success(true)
				}
				else -> result.notImplemented()
			}
		}
	}
}

