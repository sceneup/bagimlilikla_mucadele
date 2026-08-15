import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'local_notification_service.dart';
import 'micro_intervention_service.dart';
import 'notification_filter_service.dart';
import 'verification_intervention_service.dart';
import 'package:android_intent_plus/android_intent.dart';

class NotificationService {
  StreamSubscription? _subscription;
  final GoRouter router;
  late final LocalNotificationService _localNotificationService;

  NotificationService({
    required this.router,
  }) {
    _localNotificationService =
        LocalNotificationService(
          router: router,
        );
  }

  late final MicroInterventionService _microInterventionService;
  late final VerificationInterventionService _verificationInterventionService;

  bool _isInitialized = false;
  bool _isListening = false;


  static String? _lastNotificationKey;
  static DateTime? _lastNotificationTime;


  static const Duration _duplicateWindow = Duration(seconds: 5);
  static final Set<String> _processingShoppingKeys = {};
  static final Map<String, DateTime> _recentShoppingKeys = {};
  static const Duration _shoppingDuplicateWindow = Duration(seconds: 30);

  Future<void> initialize() async {
    if (_isInitialized) {
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
  }

  Future<bool> requestPermission() async {
    return await NotificationListenerService
        .requestPermission();
  }

  Future<bool> isPermissionGranted() async {
    return await NotificationListenerService
        .isPermissionGranted();
  }
  Future<void> openNotificationSettings() async {
    if (!Platform.isAndroid) {
      return;
    }

    const packageName = 'com.example.bagimlilik';

    final intent = AndroidIntent(
      action: 'android.settings.NOTIFICATION_LISTENER_DETAIL_SETTINGS',
      arguments: {
        'android.provider.extra.NOTIFICATION_LISTENER_COMPONENT_NAME':
        '$packageName/notification.listener.service.NotificationListener',
      },
    );

    await intent.launch();
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      return;
    }

    if (_isListening) {
      return;
    }

    _isListening = true;

    final filter = NotificationFilterService();

    _subscription =
        NotificationListenerService.notificationsStream.listen(
              (event) async {
            try {
              final analysis = filter.analyze(
                packageName: event.packageName,
                title: event.title,
                content: event.content,
              );

              if (analysis == null) {
                return;
              }

              // ============================================================
              // ALIŞVERİŞ DOĞRULAMA
              // ============================================================

              if (analysis.isShoppingVerification) {
                print(
                  "Merchant: ${analysis.merchantName}",
                );

                print(
                  "Amount: ${analysis.amount}",
                );

                final shoppingKey =
                _createShoppingNotificationKey(analysis);

                print(
                  "Shopping Key: $shoppingKey",
                );

                // Aynı işlem şu anda işleniyorsa tekrar işleme
                if (_processingShoppingKeys.contains(shoppingKey)) {
                  print(
                    "⚠️ Alışveriş bildirimi zaten işleniyor: $shoppingKey",
                  );
                  return;
                }

                final now = DateTime.now();

                final lastShoppingTime =
                _recentShoppingKeys[shoppingKey];

                // 30 saniye içinde aynı bildirim geldiyse tekrar işleme
                if (lastShoppingTime != null &&
                    now
                        .difference(lastShoppingTime)
                        .compareTo(
                      _shoppingDuplicateWindow,
                    ) <
                        0) {
                  print(
                    "⚠️ Aynı alışveriş bildirimi tekrar geldi: "
                        "$shoppingKey",
                  );
                  return;
                }

                _processingShoppingKeys.add(shoppingKey);
                _recentShoppingKeys[shoppingKey] = now;

                try {
                  await _verificationInterventionService
                      .sendShoppingVerificationNotification(
                    merchantName:
                    analysis.merchantName ??
                        "Bilinmeyen mağaza",
                    amount: analysis.amount,
                  );
                } finally {
                  _processingShoppingKeys.remove(
                    shoppingKey,
                  );
                }

                return;
              }

              // ============================================================
              // NORMAL BİLDİRİM DUPLICATE KONTROLÜ
              // ============================================================

              final notificationKey =
                  "${analysis.packageName}|"
                  "${analysis.title}|"
                  "${analysis.content}";

              final now = DateTime.now();

              final isDuplicate =
                  _lastNotificationKey ==
                      notificationKey &&
                      _lastNotificationTime != null &&
                      now
                          .difference(
                        _lastNotificationTime!,
                      )
                          .compareTo(
                        _duplicateWindow,
                      ) <
                          0;

              if (isDuplicate) {
                return;
              }

              _lastNotificationKey = notificationKey;
              _lastNotificationTime = now;

              // ============================================================
              // DEBUG
              // ============================================================

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

              // ============================================================
              // DARK PATTERN YOKSA MÜDAHALE YOK
              // ============================================================

              if (!analysis.hasDarkPattern) {
                return;
              }

              // ============================================================
              // MİKRO MÜDAHALE
              // ============================================================

              await _microInterventionService.sendIntervention(
                analysis.detectedPatterns,
              );
            } catch (e, stackTrace) {
              debugPrint(
                "❌ NotificationService hata: $e",
              );

              debugPrint(
                stackTrace.toString(),
              );
            }
          },
          onError: (error) {
            debugPrint(
              "❌ Notification stream hatası: $error",
            );
          },
        );
  }

  String _createShoppingNotificationKey(
      dynamic analysis,
      ) {
    final packageName =
    analysis.packageName
        .toString()
        .trim()
        .toLowerCase();

    final merchant =
    (analysis.merchantName ?? "")
        .toString()
        .trim()
        .toLowerCase();

    final amount =
    (analysis.amount ?? "")
        .toString()
        .trim()
        .toLowerCase();

    final verificationCode =
    (analysis.verificationCode ?? "")
        .toString()
        .trim();

    return "$packageName|"
        "$merchant|"
        "$amount|"
        "$verificationCode";
  }

  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    _isListening = false;
  }

  void clearDuplicateCache() {
    _lastNotificationKey = null;
    _lastNotificationTime = null;
    _processingShoppingKeys.clear();
    _recentShoppingKeys.clear();
  }

  void dispose() {
    stopListening();
    _lastNotificationKey = null;
    _lastNotificationTime = null;
    _processingShoppingKeys.clear();
    _recentShoppingKeys.clear();
    _isInitialized = false;
  }
}