package com.example.bagimlilik

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import androidx.core.app.NotificationCompat
import java.util.Locale

class SiriusNotificationListener : NotificationListenerService() {

    override fun onListenerConnected() {
        super.onListenerConnected()
        ensureChannels()
        Log.d(TAG, "Listener connected")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        Log.d(TAG, "Listener disconnected")
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        super.onNotificationPosted(sbn)

        if (isAppInForeground()) {
            Log.d(TAG, "App foreground, native listener skipped")
            return
        }

        val packageName = sbn.packageName.lowercase(Locale.ROOT)
        val notification = sbn.notification ?: return

        val title = notification.extras.getCharSequence(Notification.EXTRA_TITLE)
            ?.toString()
            .orEmpty()
        val content = extractContent(notification)

        val analysis = NotificationFilter.analyze(
            packageName = packageName,
            title = title,
            content = content,
        ) ?: return

        Log.d(TAG, "Package=$packageName type=${analysis.notificationType} patterns=${analysis.detectedPatterns}")

        if (analysis.isShoppingVerification) {
            queuePendingStat(STAT_VERIFICATION)
            showShoppingVerificationNotification(analysis)
            return
        }

        if (!analysis.hasDarkPattern) {
            return
        }

        queuePendingStat(STAT_MICRO_INTERVENTION)
        showMicroInterventionNotification(analysis)
    }

    private fun showMicroInterventionNotification(analysis: NotificationAnalysis) {
        val body = when {
            analysis.detectedPatterns.size > 1 -> {
                "Bu bildiride birden fazla satın alma tetikleyicisi var. Karar vermeden önce bir kez daha düşün."
            }

            analysis.detectedPatterns.firstOrNull() == DarkPatternType.scarcity -> {
                "Bu içerik sınırlı stok vurgusu yapıyor. Gerçek ihtiyacını tekrar değerlendirebilirsin."
            }

            analysis.detectedPatterns.firstOrNull() == DarkPatternType.urgency -> {
                "Bu içerik zaman baskısı oluşturuyor. Kararı biraz ertelemek daha sağlıklı olabilir."
            }

            analysis.detectedPatterns.firstOrNull() == DarkPatternType.socialProof -> {
                "Bu içerik başkalarının davranışını öne çıkarıyor. Senin ihtiyacın ne?"
            }

            analysis.detectedPatterns.firstOrNull() == DarkPatternType.retargeting -> {
                "Bu bildirim daha önce baktığın şeyi yeniden öne çıkarıyor. İhtiyacın sürüyor mu?"
            }

            analysis.detectedPatterns.firstOrNull() == DarkPatternType.confirmShaming -> {
                "Bu mesaj, vazgeçme kararını kötü hissettirmeye çalışıyor olabilir."
            }

            else -> {
                "Satın almadan önce gerçekten ihtiyacın olup olmadığını bir kez daha düşün."
            }
        }

        postNotification(
            channelId = MICRO_CHANNEL_ID,
            channelName = "Mikro Müdahaleler",
            title = "Bir dakika düşün 🧠",
            content = body,
            notificationId = analysis.stableId(),
        )
    }

    private fun showShoppingVerificationNotification(analysis: NotificationAnalysis) {
        val merchant = analysis.merchantName ?: "Bilinmeyen mağaza"
        val shoppingInfo = if (analysis.amount != null) {
            "$merchant üzerinden ${analysis.amount} TL"
        } else {
            merchant
        }

        postNotification(
            channelId = SHOPPING_CHANNEL_ID,
            channelName = "Alışveriş Doğrulamaları",
            title = "Alışveriş doğrulaması algılandı 🛒",
            content = "$shoppingInfo tutarında bir alışveriş için doğrulama kodu algılandı.",
            notificationId = analysis.stableId(),
            actions = buildShoppingActions(analysis),
        )
    }

    private fun postNotification(
        channelId: String,
        channelName: String,
        title: String,
        content: String,
        notificationId: Int,
        actions: List<NotificationCompat.Action> = emptyList(),
    ) {
        createChannel(channelId, channelName)

        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            ?: Intent(this, MainActivity::class.java)

        launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)

        val pendingIntent = PendingIntent.getActivity(
            this,
            notificationId,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or pendingIntentFlags(),
        )

        val builder = NotificationCompat.Builder(this, channelId)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(content)
            .setStyle(NotificationCompat.BigTextStyle().bigText(content))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)

        actions.forEach { builder.addAction(it) }

        notificationManager().notify(notificationId, builder.build())
    }

    private fun buildShoppingActions(analysis: NotificationAnalysis): List<NotificationCompat.Action> {
        val waitingListIntent = Intent(this, SiriusNotificationActionReceiver::class.java).apply {
            action = ACTION_ADD_TO_WAITING_LIST
            putExtra(EXTRA_MERCHANT_NAME, analysis.merchantName.orEmpty())
            putExtra(EXTRA_AMOUNT, analysis.amount.orEmpty())
        }

        val skipIntent = Intent(this, SiriusNotificationActionReceiver::class.java).apply {
            action = ACTION_SKIP
        }

        val waitingListPendingIntent = PendingIntent.getBroadcast(
            this,
            analysis.stableId(),
            waitingListIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or pendingIntentFlags(),
        )

        val skipPendingIntent = PendingIntent.getBroadcast(
            this,
            analysis.stableId() + 1,
            skipIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or pendingIntentFlags(),
        )

        return listOf(
            NotificationCompat.Action.Builder(
                android.R.drawable.ic_input_add,
                "Bekleme listesine al",
                waitingListPendingIntent,
            ).build(),
            NotificationCompat.Action.Builder(
                android.R.drawable.ic_menu_close_clear_cancel,
                "Şimdilik geç",
                skipPendingIntent,
            ).build(),
        )
    }

    private fun ensureChannels() {
        createChannel(MICRO_CHANNEL_ID, "Mikro Müdahaleler")
        createChannel(SHOPPING_CHANNEL_ID, "Alışveriş Doğrulamaları")
    }

    private fun createChannel(channelId: String, channelName: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val channel = NotificationChannel(
            channelId,
            channelName,
            NotificationManager.IMPORTANCE_HIGH,
        )
        notificationManager().createNotificationChannel(channel)
    }

    private fun notificationManager(): NotificationManager {
        return getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    private fun isAppInForeground(): Boolean {
        val prefs = getSharedPreferences(APP_STATE_PREFS, Context.MODE_PRIVATE)
        return prefs.getBoolean(MainActivity.KEY_APP_IN_FOREGROUND, false)
    }

    private fun queuePendingStat(type: String) {
        val prefs = getSharedPreferences(QUEUE_PREFS, Context.MODE_PRIVATE)
        val current = prefs.getInt(type, 0)
        prefs.edit().putInt(type, current + 1).apply()
    }

    private fun pendingIntentFlags(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            0
        }
    }

    private fun extractContent(notification: Notification): String {
        val extras = notification.extras
        val candidates = listOf(
            extras.getCharSequence(Notification.EXTRA_BIG_TEXT),
            extras.getCharSequence(Notification.EXTRA_TEXT),
            extras.getCharSequence(Notification.EXTRA_SUB_TEXT),
        )

        return candidates.firstOrNull { !it.isNullOrBlank() }
            ?.toString()
            .orEmpty()
    }

    companion object {
        private const val TAG = "SiriusNotification"
        private const val APP_STATE_PREFS = "sirius_notification_state"
        private const val QUEUE_PREFS = "FlutterSharedPreferences"
        private const val STAT_VERIFICATION = "flutter.pending_verification_count"
        private const val STAT_MICRO_INTERVENTION = "flutter.pending_micro_intervention_count"
        private const val MICRO_CHANNEL_ID = "micro_intervention_channel_native"
        private const val SHOPPING_CHANNEL_ID = "shopping_verification_channel_native"
        private const val ACTION_ADD_TO_WAITING_LIST = "add_to_waiting_list"
        private const val ACTION_SKIP = "skip"
        private const val EXTRA_MERCHANT_NAME = "merchantName"
        private const val EXTRA_AMOUNT = "amount"
    }
}

private fun NotificationAnalysis.stableId(): Int {
    return (packageName + title + content + (merchantName ?: "") + (amount ?: "")).hashCode()
}

private data class NotificationAnalysis(
    val notificationType: NotificationType,
    val detectedPatterns: List<DarkPatternType>,
    val packageName: String,
    val title: String,
    val content: String,
    val verificationCode: String?,
    val merchantName: String?,
    val amount: String?,
) {
    val hasDarkPattern: Boolean
        get() = detectedPatterns.isNotEmpty() && !detectedPatterns.contains(DarkPatternType.none)

    val isShoppingVerification: Boolean
        get() = notificationType == NotificationType.shoppingVerification
}

private enum class NotificationType {
    shoppingVerification,
    eCommerce,
    bankSms,
    whatsapp,
    unknown,
}

private enum class DarkPatternType {
    scarcity,
    urgency,
    socialProof,
    retargeting,
    confirmShaming,
    none,
}

private object NotificationFilter {
    private val ignoredPackages = setOf(
        "com.android.systemui",
        "com.android.settings",
        "com.example.bagimlilik",
    )

    private val whatsappPackages = setOf("com.whatsapp")

    private val messagingPackages = setOf(
        "com.google.android.apps.messaging",
        "com.samsung.android.messaging",
    )

    private val ecommercePackages = setOf(
        "trendyol",
        "hepsiburada",
        "amazon",
        "n11",
        "boyner",
        "flo",
        "lc waikiki",
        "lcw",
        "defacto",
        "mavi",
        "koton",
        "pazarama",
    )

    private val verificationCodeRegex = Regex(
        "(?:doğrulama\\s+kodunuz|doğrulama\\s+kodu|onay\\s+kodunuz|onay\\s+kodu|güvenlik\\s+kodunuz|güvenlik\\s+kodu|tek\\s+kullanımlık\\s+şifreniz|tek\\s+kullanımlık\\s+şifre|tek\\s+kullanımlık\\s+kodunuz|tek\\s+kullanımlık\\s+kodu|şifreniz|şifre|sifreniz|sifre|kodunuz|kodu)\\s*[:\\-]?\\s*(\\d{4,8})\\b",
        setOf(RegexOption.IGNORE_CASE),
    )

    private val transactionContextRegex = Regex(
        "\\b(harcamanız|harcamaniz|harcama|alışverişiniz|alisverisiniz|alışveriş|alisveris|siparişiniz|siparisiniz|sipariş|siparis|ödemeniz|odemeniz|ödeme|isleminiz|işleminiz|islem|işlem|satın alım|satin alim|satın alma|satin alma|kartınızla|kartinizla|kartınızdan|kartinizdan)\\b",
        setOf(RegexOption.IGNORE_CASE),
    )

    private val amountRegex = Regex(
        "(\\d{1,3}(?:[.]\\d{3})*(?:,\\d{1,2})?|\\d+(?:,\\d{1,2})?)\\s*TL\\b",
        setOf(RegexOption.IGNORE_CASE),
    )

    private val merchantRegex = Regex(
        "^\\s*(.*?)\\s+işyerinden\\b",
        setOf(RegexOption.IGNORE_CASE, RegexOption.MULTILINE),
    )

    private val remainingStockRegex = Regex("\\b(son|kalan)\\s+\\d+\\s*(ürün|adet)\\b", setOf(RegexOption.IGNORE_CASE))
    private val limitedStockRegex = Regex("\\b(sadece|yalnızca)\\s+\\d+\\s*(adet|ürün)?\\s*(kaldı|kalmış)\\b", setOf(RegexOption.IGNORE_CASE))
    private val remainingTimeRegex = Regex("\\b(son|kalan)\\s+\\d+\\s*(dakika|saat|gün)\\b", setOf(RegexOption.IGNORE_CASE))
    private val timeLimitRegex = Regex("\\b\\d+\\s*(dakika|saat|gün)\\s*(içinde|kaldı)\\b", setOf(RegexOption.IGNORE_CASE))
    private val peopleCountRegex = Regex("\\b\\d+\\s*(kişi|kullanıcı)\\b", setOf(RegexOption.IGNORE_CASE))

    private val scarcityKeywords = listOf(
        "son ürün",
        "son adet",
        "stokta son",
        "stok tükeniyor",
        "stoklar tükeniyor",
        "sınırlı stok",
        "sınırlı sayıda",
        "tükenmeden",
        "stok bitiyor",
        "stoklar bitiyor",
        "son şans",
        "son fırsat",
    )

    private val urgencyKeywords = listOf(
        "hemen al",
        "şimdi al",
        "acele et",
        "son saat",
        "son gün",
        "son dakika",
        "süre doluyor",
        "kampanya bitiyor",
        "fırsat bitiyor",
        "bitmeden",
        "kaçırma",
        "hemen satın al",
        "şimdi satın al",
    )

    private val socialProofKeywords = listOf(
        "çok satan",
        "en çok satan",
        "çok tercih edilen",
        "popüler",
        "trend ürün",
        "şu anda inceleniyor",
        "şu anda görüntüleniyor",
        "kişi görüntülüyor",
        "kişi inceliyor",
        "kişi satın aldı",
        "kişi satın alıyor",
        "kişinin sepetinde",
    )

    private val retargetingKeywords = listOf(
        "sepetindeki",
        "sepetinizdeki",
        "sepetinde",
        "sepetinizde",
        "favorindeki",
        "favorinizdeki",
        "favorilerindeki",
        "az önce incelediğin",
        "az önce incelediğiniz",
        "baktığın ürün",
        "baktığınız ürün",
        "ilgilendiğin ürün",
        "ilgilendiğiniz ürün",
        "seni bekliyor",
        "sizi bekliyor",
        "hala düşünüyor musun",
    )

    private val confirmShamingKeywords = listOf(
        "fırsatı kaçırmayı tercih ediyorum",
        "tasarruf etmek istemiyorum",
        "indirim istemiyorum",
        "fırsatı kaçır",
        "hayır, istemiyorum",
        "hayır, devam etmek istemiyorum",
    )

    fun analyze(
        packageName: String,
        title: String,
        content: String,
    ): NotificationAnalysis? {
        val normalizedPackage = packageName.lowercase(Locale.ROOT)
        val text = "$title $content".lowercase(Locale.ROOT)

        if (normalizedPackage in ignoredPackages) {
            return null
        }

        val verificationMatch = verificationCodeRegex.find(text)
        val hasVerificationCode = verificationMatch != null
        val verificationCode = verificationMatch?.groupValues?.getOrNull(1)
        val hasTransactionContext = transactionContextRegex.containsMatchIn(text)
        val amountMatch = amountRegex.find(text)
        val amount = amountMatch?.groupValues?.getOrNull(1)
        val hasAmount = amountMatch != null
        val merchantMatch = merchantRegex.find(content)
        var merchantName = merchantMatch?.groupValues?.getOrNull(1)?.trim()
        if (!merchantName.isNullOrEmpty()) {
            merchantName = merchantName.uppercase(Locale.ROOT)
        }
        val hasMerchant = !merchantName.isNullOrEmpty()

        val notificationType = detectNotificationType(
            packageName = normalizedPackage,
            text = text,
            hasVerificationCode = hasVerificationCode,
            hasTransactionContext = hasTransactionContext,
            hasAmount = hasAmount,
            hasMerchant = hasMerchant,
        )

        if (notificationType == NotificationType.unknown) {
            return null
        }

        val patterns = mutableListOf<DarkPatternType>()

        if (containsAny(text, scarcityKeywords) || remainingStockRegex.containsMatchIn(text) || limitedStockRegex.containsMatchIn(text)) {
            patterns.add(DarkPatternType.scarcity)
        }
        if (containsAny(text, urgencyKeywords) || remainingTimeRegex.containsMatchIn(text) || timeLimitRegex.containsMatchIn(text)) {
            patterns.add(DarkPatternType.urgency)
        }
        if (containsAny(text, socialProofKeywords) || peopleCountRegex.containsMatchIn(text)) {
            patterns.add(DarkPatternType.socialProof)
        }
        if (containsAny(text, retargetingKeywords)) {
            patterns.add(DarkPatternType.retargeting)
        }
        if (containsAny(text, confirmShamingKeywords)) {
            patterns.add(DarkPatternType.confirmShaming)
        }

        return NotificationAnalysis(
            notificationType = notificationType,
            detectedPatterns = if (patterns.isEmpty()) listOf(DarkPatternType.none) else patterns,
            packageName = packageName,
            title = title,
            content = content,
            verificationCode = verificationCode,
            merchantName = merchantName,
            amount = amount,
        )
    }

    private fun detectNotificationType(
        packageName: String,
        text: String,
        hasVerificationCode: Boolean,
        hasTransactionContext: Boolean,
        hasAmount: Boolean,
        hasMerchant: Boolean,
    ): NotificationType {
        if (hasVerificationCode && hasTransactionContext && (hasAmount || hasMerchant)) {
            return NotificationType.shoppingVerification
        }

        if (packageName in whatsappPackages) {
            return NotificationType.whatsapp
        }

        if (packageName in ecommercePackages) {
            return NotificationType.eCommerce
        }

        if (packageName in messagingPackages) {
            if (isBankSms(text)) {
                return NotificationType.bankSms
            }
            return NotificationType.unknown
        }

        return NotificationType.unknown
    }

    private fun isBankSms(text: String): Boolean {
        val keywords = listOf(
            "banka",
            "hesabınız",
            "hesabiniz",
            "kartınız",
            "kartiniz",
            "şifre",
            "sifre",
            "kod",
            "tl",
            "harcama",
            "işlem",
            "işleminiz",
            "işlemi",
        )

        return containsAny(text, keywords)
    }

    private fun containsAny(text: String, keywords: List<String>): Boolean {
        return keywords.any { text.contains(it.lowercase(Locale.ROOT)) }
    }
}