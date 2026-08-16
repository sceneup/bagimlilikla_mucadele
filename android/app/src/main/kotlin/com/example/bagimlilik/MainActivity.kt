package com.example.bagimlilik

import android.content.Context
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

	override fun onResume() {
		super.onResume()
		setAppInForeground(true)
	}

	override fun onPause() {
		setAppInForeground(false)
		super.onPause()
	}

	override fun onDestroy() {
		setAppInForeground(false)
		super.onDestroy()
	}

	private fun setAppInForeground(value: Boolean) {
		getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
			.edit()
			.putBoolean(KEY_APP_IN_FOREGROUND, value)
			.apply()
	}

	companion object {
		private const val PREFS_NAME = "sirius_notification_state"
		const val KEY_APP_IN_FOREGROUND = "app_in_foreground"
	}
}
