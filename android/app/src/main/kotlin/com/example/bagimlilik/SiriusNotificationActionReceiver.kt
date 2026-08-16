package com.example.bagimlilik

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import org.json.JSONObject

class SiriusNotificationActionReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_ADD_TO_WAITING_LIST -> {
                val merchantName = intent.getStringExtra(EXTRA_MERCHANT_NAME).orEmpty()
                val amount = intent.getStringExtra(EXTRA_AMOUNT)
                if (merchantName.isNotBlank()) {
                    queuePendingWaitingListItem(context, merchantName, amount)
                }
            }

            ACTION_SKIP -> {
                queuePendingStat(context, STAT_SKIP)
            }
        }
    }

    private fun queuePendingStat(context: Context, key: String) {
        val prefs = context.getSharedPreferences(QUEUE_PREFS, Context.MODE_PRIVATE)
        val current = prefs.getInt(key, 0)
        prefs.edit().putInt(key, current + 1).apply()
    }

    private fun queuePendingWaitingListItem(
        context: Context,
        merchantName: String,
        amount: String?,
    ) {
        val prefs = context.getSharedPreferences(QUEUE_PREFS, Context.MODE_PRIVATE)
        val pending = prefs.getStringSet(KEY_PENDING_WAITING_LIST_ITEMS, emptySet())?.toMutableSet()
            ?: mutableSetOf()

        val payload = JSONObject()
            .put("merchantName", merchantName)
            .put("amount", amount)
            .put("createdAt", System.currentTimeMillis())
            .toString()

        pending.add(payload)
        prefs.edit().putStringSet(KEY_PENDING_WAITING_LIST_ITEMS, pending).apply()

        Log.d(TAG, "Queued waiting list item: $merchantName")
    }

    companion object {
        private const val TAG = "SiriusNotifAction"
        private const val QUEUE_PREFS = "FlutterSharedPreferences"
        private const val KEY_PENDING_WAITING_LIST_ITEMS = "flutter.pending_waiting_list_items"
        private const val STAT_SKIP = "flutter.pending_skip_count"
        private const val ACTION_ADD_TO_WAITING_LIST = "add_to_waiting_list"
        private const val ACTION_SKIP = "skip"
        private const val EXTRA_MERCHANT_NAME = "merchantName"
        private const val EXTRA_AMOUNT = "amount"
    }
}
