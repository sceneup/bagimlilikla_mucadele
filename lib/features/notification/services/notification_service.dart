import 'dart:async';

import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'local_notification_service.dart';
import 'micro_intervention_service.dart';
import 'notification_filter_service.dart';

class NotificationService {
  StreamSubscription<ServiceNotificationEvent>? _subscription;

  final LocalNotificationService _localNotificationService =
  LocalNotificationService();

  late final MicroInterventionService _microInterventionService;

  // ============================================================
  // BAŞLAT
  // ============================================================

  Future<void> initialize() async {
    await _localNotificationService.initialize();

    _microInterventionService = MicroInterventionService(
      _localNotificationService,
    );
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
  // BİLDİRİMLERİ DİNLE
  // ============================================================

  void startListening() {
    stopListening();

    final filter = NotificationFilterService();

    _subscription =
        NotificationListenerService.notificationsStream.listen(
              (event) async {
            final packageName = event.packageName ?? "";
            final title = event.title ?? "";
            final content = event.content ?? "";

            final analysis = filter.analyze(
              packageName: packageName,
              title: title,
              content: content,
            );

            // Sistem bildirimleri filtreleniyorsa
            // hiçbir işlem yapma.
            if (analysis == null) {
              return;
            }

            print("========== NOTIFICATION ==========");
            print("Package  : $packageName");
            print("Title    : $title");
            print("Content  : $content");
            print("Type     : ${analysis.notificationType}");
            print("Patterns : ${analysis.detectedPatterns}");
            print("==================================");

            // Dark pattern yoksa bildirim gönderme
            if (!analysis.hasDarkPattern) {
              return;
            }

            // Dark pattern varsa mikro müdahale gönder
            await _microInterventionService.sendIntervention(
              analysis.detectedPatterns,
            );
          },
        );
  }

  // ============================================================
  // DURDUR
  // ============================================================

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  // ============================================================
  // TEMİZLE
  // ============================================================

  void dispose() {
    stopListening();
  }
}