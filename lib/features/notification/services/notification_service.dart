import 'dart:async';

import 'package:notification_listener_service/notification_listener_service.dart';

import 'local_notification_service.dart';
import 'micro_intervention_service.dart';
import 'notification_filter_service.dart';
import 'verification_intervention_service.dart';

class NotificationService {
  StreamSubscription? _subscription;

  final LocalNotificationService _localNotificationService =
  LocalNotificationService();

  late final MicroInterventionService _microInterventionService;

  late final VerificationInterventionService
  _verificationInterventionService;

  bool _isInitialized = false;
  bool _isListening = false;

  // ============================================================
  // DUPLICATE KONTROLÜ
  // ============================================================

  String? _lastNotificationKey;
  DateTime? _lastNotificationTime;

  // Aynı notification birkaç saniye içerisinde
  // tekrar gelirse ikinci kez işlemiyoruz.
  static const Duration _duplicateWindow =
  Duration(seconds: 5);

  // ============================================================
  // BAŞLAT
  // ============================================================

  Future<void> initialize() async {
    if (_isInitialized) {
      print("🔁 NotificationService zaten initialize edildi.");
      return;
    }

    await _localNotificationService.initialize();

    _microInterventionService =
        MicroInterventionService(
          _localNotificationService,
        );

    _verificationInterventionService =
        VerificationInterventionService(
          _localNotificationService,
        );

    _isInitialized = true;

    print("🟢 NotificationService initialize edildi.");
  }

  // ============================================================
  // İZİN
  // ============================================================

  Future<bool> requestPermission() async {
    return await NotificationListenerService.requestPermission();
  }

  Future<bool> isPermissionGranted() async {
    return await NotificationListenerService.isPermissionGranted();
  }

  // ============================================================
  // DİNLEMEYİ BAŞLAT
  // ============================================================

  void startListening() {
    // ------------------------------------------------------------
    // INITIALIZE KONTROLÜ
    // ------------------------------------------------------------

    if (!_isInitialized) {
      print(
        "❌ NotificationService henüz initialize edilmedi.",
      );
      return;
    }

    // ------------------------------------------------------------
    // ZATEN DİNLİYORSA TEKRAR LISTENER OLUŞTURMA
    // ------------------------------------------------------------

    if (_isListening) {
      print(
        "🔁 NotificationService zaten dinliyor. "
            "Yeni listener oluşturulmadı.",
      );
      return;
    }

    _isListening = true;

    final filter = NotificationFilterService();

    print("🟢 NotificationService dinlemeye başladı.");

    // ------------------------------------------------------------
    // NOTIFICATION STREAM
    // ------------------------------------------------------------

    _subscription =
        NotificationListenerService.notificationsStream.listen(
              (event) async {
            try {
              // ======================================================
              // ANALİZ
              // ======================================================

              final analysis = filter.analyze(
                packageName: event.packageName,
                title: event.title,
                content: event.content,
              );

              // ======================================================
              // İLGİLENMEDİĞİMİZ BİLDİRİM
              // ======================================================

              if (analysis == null) {
                return;
              }

              // ======================================================
              // DUPLICATE KONTROLÜ
              // ======================================================
              //
              // ÇOK ÖNEMLİ:
              //
              // Bu kontrol LOCAL NOTIFICATION çağrısından ÖNCE
              // yapılmalıdır.
              //
              // Böylece aynı notification 3-4 kere stream'e düşse
              // sadece ilk event işlenir.
              // ======================================================

              final notificationKey =
                  "${analysis.packageName}|"
                  "${analysis.title}|"
                  "${analysis.content}";

              final now = DateTime.now();

              final isDuplicate =
                  _lastNotificationKey == notificationKey &&
                      _lastNotificationTime != null &&
                      now.difference(_lastNotificationTime!) <
                          _duplicateWindow;

              if (isDuplicate) {
                print(
                  "🔁 Duplicate notification engellendi.",
                );

                print(
                  "   Key: $notificationKey",
                );

                return;
              }

              // ------------------------------------------------------
              // BURASI ÇOK ÖNEMLİ
              // ------------------------------------------------------
              //
              // await sendNotification() ÇAĞRISINDAN ÖNCE
              // kaydediyoruz.
              // ------------------------------------------------------

              _lastNotificationKey = notificationKey;
              _lastNotificationTime = now;

              // ======================================================
              // DEBUG
              // ======================================================

              print(
                "========== NOTIFICATION ==========",
              );

              print(
                "Package  : ${analysis.packageName}",
              );

              print(
                "Title    : ${analysis.title}",
              );

              print(
                "Content  : ${analysis.content}",
              );

              print(
                "Type     : ${analysis.notificationType}",
              );

              print(
                "Patterns : ${analysis.detectedPatterns}",
              );

              if (analysis.merchantName != null) {
                print(
                  "Merchant : ${analysis.merchantName}",
                );
              }

              if (analysis.amount != null) {
                print(
                  "Amount   : ${analysis.amount}",
                );
              }

              print(
                "==================================",
              );

              // ======================================================
              // ALIŞVERİŞ DOĞRULAMASI
              // ======================================================

              print(
                "SHOPPING VERIFICATION CHECK: "
                    "${analysis.notificationType}",
              );

              if (analysis.isShoppingVerification) {
                print(
                  "🛒🛒🛒 SHOPPING VERIFICATION YAKALANDI!",
                );

                print(
                  "Merchant: ${analysis.merchantName}",
                );

                print(
                  "Amount: ${analysis.amount}",
                );

                // ----------------------------------------------------
                // ARTIK SADECE İLK EVENT BURAYA GELEBİLİR
                // ----------------------------------------------------

                await _verificationInterventionService
                    .sendShoppingVerificationNotification(
                  merchantName:
                  analysis.merchantName ??
                      "Bilinmeyen mağaza",
                  amount: analysis.amount,
                );

                return;
              }

              print(
                "YAKALANMADI!",
              );

              // ======================================================
              // DARK PATTERN YOK
              // ======================================================

              if (!analysis.hasDarkPattern) {
                return;
              }

              // ======================================================
              // DARK PATTERN VAR
              // ======================================================

              await _microInterventionService
                  .sendIntervention(
                analysis.detectedPatterns,
              );
            } catch (e, stackTrace) {
              print(
                "❌ NotificationService hata: $e",
              );

              print(stackTrace);
            }
          },
          onError: (error) {
            print(
              "❌ Notification stream hatası: $error",
            );
          },
        );
  }

  // ============================================================
  // DİNLEMEYİ DURDUR
  // ============================================================

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;

    _isListening = false;

    print(
      "🔴 NotificationService dinleme durduruldu.",
    );
  }

  // ============================================================
  // DUPLICATE CACHE TEMİZLE
  // ============================================================

  void clearDuplicateCache() {
    _lastNotificationKey = null;
    _lastNotificationTime = null;

    print(
      "🧹 Notification duplicate cache temizlendi.",
    );
  }

  // ============================================================
  // TEMİZLE
  // ============================================================

  void dispose() {
    stopListening();

    _lastNotificationKey = null;
    _lastNotificationTime = null;

    _isInitialized = false;

    print(
      "🧹 NotificationService dispose edildi.",
    );
  }
}