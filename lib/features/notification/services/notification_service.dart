import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'local_notification_service.dart';
import 'micro_intervention_service.dart';
import 'notification_filter_service.dart';
import 'verification_intervention_service.dart';

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

  void startListening() {
    if (!_isInitialized) {
      return;
    }

    if (_isListening) {
      return;
    }
    _isListening = true;
    final filter = NotificationFilterService();
    _subscription =
        NotificationListenerService.notificationsStream
            .listen(
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

              if (analysis.isShoppingVerification) {
                print(
                  "Merchant: ${analysis.merchantName}",
                );

                print(
                  "Amount: ${analysis.amount}",
                );

                final shoppingKey =
                _createShoppingNotificationKey(
                  analysis,
                );

                print(
                  "Shopping Key: $shoppingKey",
                );

                if (_processingShoppingKeys
                    .contains(shoppingKey)) {

                  print(
                    "   Key: $shoppingKey",
                  );

                  return;
                }

                final now = DateTime.now();

                final lastShoppingTime =
                _recentShoppingKeys[shoppingKey];

                if (lastShoppingTime != null &&
                    now
                        .difference(lastShoppingTime)
                        .compareTo(
                      _shoppingDuplicateWindow,
                    ) <
                        0) {

                  print(
                    "   Key: $shoppingKey",
                  );

                  return;
                }

                _processingShoppingKeys.add(
                  shoppingKey,
                );

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

              _lastNotificationKey =
                  notificationKey;

              _lastNotificationTime = now;

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
              if (!analysis.hasDarkPattern) {
                return;
              }

              await _microInterventionService
                  .sendIntervention(
                analysis.detectedPatterns,
              );
            } catch (e, stackTrace) {
              debugPrint(
                "❌ NotificationService hata: $e",
              );

              debugPrint(stackTrace.toString());
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

  void stopListening() {
    _subscription?.cancel();
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