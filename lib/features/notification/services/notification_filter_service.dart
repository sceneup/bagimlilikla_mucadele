import 'package:bagimlilik/features/notification/constants/dark_pattern_keywords.dart';
import 'package:bagimlilik/features/notification/constants/dark_pattern_regex.dart';
import 'package:bagimlilik/features/notification/constants/notification_app_packages.dart';
import 'package:bagimlilik/features/notification/constants/verification_code_regex.dart';
import 'package:bagimlilik/features/notification/enums/dark_pattern_type.dart';
import 'package:bagimlilik/features/notification/enums/notification_type.dart';
import 'package:bagimlilik/features/notification/models/notification_analysis.dart';

class NotificationFilterService {
  // ============================================================
  // BİLDİRİM ANALİZİ
  // ============================================================

  NotificationAnalysis? analyze({
    required String packageName,
    required String title,
    required String content,
  }) {
    final package = packageName.toLowerCase();

    final text = "$title $content".toLowerCase();

    // ============================================================
    // SIRIUS / SİSTEM BİLDİRİMLERİ
    // ============================================================

    const ignoredPackages = [
      "com.android.systemui",
      "com.android.settings",
      "com.example.bagimlilik",
    ];

    if (ignoredPackages.contains(package)) {
      return null;
    }

    // ============================================================
    // DOĞRULAMA KODU
    // ============================================================

    final verificationMatch =
    VerificationCodeRegex.verificationCode.firstMatch(text);

    final hasVerificationCode =
        verificationMatch != null;

    final verificationCode =
    verificationMatch?.group(1);
    // ============================================================
    // İŞLEM / ALIŞVERİŞ BAĞLAMI
    // ============================================================

    final hasTransactionContext =
    VerificationCodeRegex.transactionContext.hasMatch(text);

    // ============================================================
    // TUTAR
    // ============================================================

    final amountMatch =
    VerificationCodeRegex.amount.firstMatch(text);

    final amount =
    amountMatch?.group(1);

    final hasAmount =
        amountMatch != null;

    // ============================================================
    // MAĞAZA / İŞYERİ
    // ============================================================

    final merchantMatch =
    VerificationCodeRegex.merchant.firstMatch(content);

    String? merchantName =
    merchantMatch?.group(1)?.trim();

    if (merchantName != null &&
        merchantName.isNotEmpty) {
      merchantName = merchantName.toUpperCase();
    }

    final hasMerchant =
        merchantName != null &&
            merchantName.isNotEmpty;

    // ============================================================
    // DEBUG - SADECE ANALİZ İÇİN
    // ============================================================

    print("========== FILTER ANALYSIS ==========");
    print("Package              : $package");
    print("Has verificationCode : $hasVerificationCode");
    print("Has transaction      : $hasTransactionContext");
    print("Has amount           : $hasAmount");
    print("Has merchant         : $hasMerchant");

    // Kodun kendisini yazdırmıyoruz.
    print("=====================================");

    // ============================================================
    // BİLDİRİM TÜRÜ
    // ============================================================

    final notificationType = _detectNotificationType(
      package: package,
      text: text,
      hasVerificationCode: hasVerificationCode,
      hasTransactionContext: hasTransactionContext,
      hasAmount: hasAmount,
      hasMerchant: hasMerchant,
    );

    // ============================================================
    // İLGİLENMEDİĞİMİZ BİLDİRİMLER
    // ============================================================

    if (notificationType == NotificationType.unknown) {
      return null;
    }

    // ============================================================
    // DARK PATTERNLER
    // ============================================================

    final patterns = <DarkPatternType>{};

    // ------------------------------------------------------------
    // SCARCITY
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
    // URGENCY
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
    // SOCIAL PROOF
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.socialProof,
    ) ||
        DarkPatternRegex.peopleCount.hasMatch(text)) {
      patterns.add(DarkPatternType.socialProof);
    }

    // ------------------------------------------------------------
    // RETARGETING
    // ------------------------------------------------------------

    if (_containsAny(
      text,
      DarkPatternKeywords.retargeting,
    )) {
      patterns.add(DarkPatternType.retargeting);
    }

    // ------------------------------------------------------------
    // HIDDEN COST
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

    // ============================================================
    // SONUÇ
    // ============================================================

    return NotificationAnalysis(
      notificationType: notificationType,

      detectedPatterns: patterns.isEmpty
          ? [DarkPatternType.none]
          : patterns.toList(),

      packageName: packageName,
      title: title,
      content: content,

      verificationCode: verificationCode,
      merchantName: merchantName,
      amount: amount,
    );
  }

  // ============================================================
  // BİLDİRİM TÜRÜ
  // ============================================================

  NotificationType _detectNotificationType({
    required String package,
    required String text,
    required bool hasVerificationCode,
    required bool hasTransactionContext,
    required bool hasAmount,
    required bool hasMerchant,
  }) {
    // ============================================================
    // ALIŞVERİŞ DOĞRULAMASI
    // ============================================================

    if (hasVerificationCode &&
        hasTransactionContext &&
        (hasAmount || hasMerchant)) {
      return NotificationType.shoppingVerification;
    }

    // ============================================================
    // WHATSAPP
    // ============================================================

    if (NotificationAppPackages.whatsapp.contains(package)) {
      return NotificationType.whatsapp;
    }

    // ============================================================
    // E-TİCARET
    // ============================================================

    if (NotificationAppPackages.eCommerce.contains(package)) {
      return NotificationType.eCommerce;
    }

    // ============================================================
    // SMS / BANKA
    // ============================================================

    if (NotificationAppPackages.messaging.contains(package)) {
      if (_isBankSms(text)) {
        return NotificationType.bankSms;
      }

      return NotificationType.unknown;
    }

    // ============================================================
    // KENDİ UYGULAMAMIZ
    // ============================================================

    if (NotificationAppPackages.ownApp.contains(package)) {
      return NotificationType.unknown;
    }

    return NotificationType.unknown;
  }

  // ============================================================
  // BANKA SMS
  // ============================================================

  bool _isBankSms(String text) {
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

    return bankKeywords.any(
          (keyword) => text.contains(keyword),
    );
  }

  // ============================================================
  // KEYWORD
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