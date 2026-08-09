import 'package:bagimlilik/features/notification/constants/dark_pattern_keywords.dart';
import 'package:bagimlilik/features/notification/constants/dark_pattern_regex.dart';
import 'package:bagimlilik/features/notification/constants/verification_code_regex.dart';
import 'package:bagimlilik/features/notification/enums/dark_pattern_type.dart';
import 'package:bagimlilik/features/notification/enums/notification_type.dart';
import 'package:bagimlilik/features/notification/models/notification_analysis.dart';

class NotificationFilterService {

  // ============================================================
  // NORMAL BİLDİRİM SINIFLANDIRMASI
  // ============================================================

  NotificationType detect({
    required String packageName,
    required String title,
    required String content,
  }) {
    final package = packageName.toLowerCase();
    final text = "$title $content".toLowerCase();


    const ignoredPackages = [
      "com.android.systemui",
      "com.android.settings",
    ];

    // Sistem bildirimlerini tamamen yok say
    if (ignoredPackages.contains(package)) {
      return NotificationType.unknown;
    }

    /// Bankalar
    const bankKeywords = [
      "ziraat",
      "vakıf",
      "vakif",
      "garanti",
      "akbank",
      "iş bankası",
      "is bankasi",
      "şekerbank",
      "sekerbank",
      "qnb",
      "enpara",
      "denizbank",
      "teb",
      "yapı kredi",
      "yapi kredi",
      "halkbank",
    ];

    /// E-Ticaret
    const shoppingKeywords = [
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
    ];

    /// Kampanya
    const campaignKeywords = [
      "indirim",
      "kampanya",
      "kaçırma",
      "son gün",
      "stok",
      "hemen al",
      "fırsat",
      "kupon",
      "%",
    ];

    /// Kargo
    const shippingKeywords = [
      "kargoya verildi",
      "teslim edildi",
      "dağıtıma çıktı",
      "siparişiniz",
    ];

    // ------------------------------------------------------------
    // SMS KONTROLÜ
    // ------------------------------------------------------------

    if (package.contains("messaging")) {

      // Alışveriş doğrulama SMS'i
      if (bankKeywords.any((e) => text.contains(e)) &&
          shoppingKeywords.any((e) => text.contains(e))) {
        return NotificationType.shoppingVerification;
      }

      // Banka SMS'i
      if (bankKeywords.any((e) => text.contains(e))) {
        return NotificationType.bankSms;
      }
    }

    // ------------------------------------------------------------
    // KAMPANYA
    // ------------------------------------------------------------

    if (campaignKeywords.any((e) => text.contains(e))) {
      return NotificationType.campaign;
    }

    // ------------------------------------------------------------
    // KARGO
    // ------------------------------------------------------------

    if (shippingKeywords.any((e) => text.contains(e))) {
      return NotificationType.shipping;
    }

    // ------------------------------------------------------------
    // SOSYAL MEDYA
    // ------------------------------------------------------------

    if (package.contains("instagram") ||
        package.contains("facebook") ||
        package.contains("tiktok") ||
        package.contains("youtube") ||
        package.contains("whatsapp")) {
      return NotificationType.socialMedia;
    }

    // ------------------------------------------------------------
    // UNKNOWN
    // ------------------------------------------------------------

    return NotificationType.unknown;
  }

  // ============================================================
  // DARK PATTERN + DOĞRULAMA KODU ANALİZİ
  // ============================================================

  NotificationAnalysis? analyze({
    required String packageName,
    required String title,
    required String content,
  }) {
    final package = packageName.toLowerCase();

    const ignoredPackages = [
      "com.android.systemui",
      "com.android.settings",
      "com.example.bagimlilik",
    ];

    if (ignoredPackages.contains(package)) {
      return null;
    }

    // Önce text'i oluşturuyoruz.
    final text = "$title $content".toLowerCase();

    // ------------------------------------------------------------
    // DOĞRULAMA KODU
    // ------------------------------------------------------------

    String? verificationCode;

    final verificationMatch =
    VerificationCodeRegex.verificationCode.firstMatch(text);

    if (verificationMatch != null) {
      verificationCode = verificationMatch.group(2);
    }

    // ------------------------------------------------------------
    // NORMAL BİLDİRİM TÜRÜNÜ BUL
    // ------------------------------------------------------------

    final notificationType = detect(
      packageName: packageName,
      title: title,
      content: content,
    );

    final patterns = <DarkPatternType>{};

    // ------------------------------------------------------------
    // SCARCITY - KıTLık
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.scarcity,
    ) ||
        DarkPatternRegex.remainingStock.hasMatch(text) ||
        DarkPatternRegex.limitedStock.hasMatch(text)) {
      patterns.add(DarkPatternType.scarcity);
    }

    // ------------------------------------------------------------
    // URGENCY - ACİLİYET
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.urgency,
    ) ||
        DarkPatternRegex.remainingTime.hasMatch(text) ||
        DarkPatternRegex.timeLimit.hasMatch(text)) {
      patterns.add(DarkPatternType.urgency);
    }

    // ------------------------------------------------------------
    // SOCIAL PROOF - SOSYAL KANIT
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.socialProof,
    ) ||
        DarkPatternRegex.peopleCount.hasMatch(text)) {
      patterns.add(DarkPatternType.socialProof);
    }

    // ------------------------------------------------------------
    // RETARGETING - YENİDEN HEDEFLEME
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.retargeting,
    )) {
      patterns.add(DarkPatternType.retargeting);
    }

    // ------------------------------------------------------------
    // HIDDEN COST - GİZLİ MALİYET
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.hiddenCost,
    ) ||
        DarkPatternRegex.additionalFee.hasMatch(text) ||
        DarkPatternRegex.extraPrice.hasMatch(text)) {
      patterns.add(DarkPatternType.hiddenCost);
    }

    // ------------------------------------------------------------
    // CONFIRM SHAMING
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.confirmShaming,
    )) {
      patterns.add(DarkPatternType.confirmShaming);
    }

    // ------------------------------------------------------------
    // FORCED ACTION
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.forcedAction,
    )) {
      patterns.add(DarkPatternType.forcedAction);
    }

    // ------------------------------------------------------------
    // ANALİZ SONUCU
    // ------------------------------------------------------------

    return NotificationAnalysis(
      notificationType: notificationType,

      detectedPatterns: patterns.isEmpty
          ? [DarkPatternType.none]
          : patterns.toList(),

      packageName: packageName,
      title: title,
      content: content,

      verificationCode: verificationCode,
    );
  }

  // ============================================================
  // KEYWORD KONTROLÜ
  // ============================================================

  bool _containsAny(
      String text,
      List<String> keywords,
      ) {
    return keywords.any(
          (keyword) => text.contains(
        keyword.toLowerCase(),
      ),
    );
  }
}