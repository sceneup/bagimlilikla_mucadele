import 'package:bagimlilik/features/notification/repositories/daily_behavior_stats_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:bagimlilik/features/notification/models/notification_state.dart';
import 'package:bagimlilik/features/notification/providers/notification_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationViewModel extends Notifier<NotificationState>
    with WidgetsBindingObserver {

  @override
  NotificationState build() {
    WidgetsBinding.instance.addObserver(this);

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });

    Future.microtask(checkPermission);

    return const NotificationState();
  }

  // ============================================================
  // ANDROID AYARLARINDAN GERİ DÖNÜLDÜĞÜNDE
  // ============================================================

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    if (state == AppLifecycleState.resumed) {
      checkPermission();
    }
  }

  // ============================================================
  // BİLDİRİM ERİŞİMİNİ AÇ
  // ============================================================

  Future<void> enableNotifications() async {
    final service = ref.read(
      notificationServiceProvider,
    );

    await service.initialize();

    await service.openNotificationSettings();
  }

  // ============================================================
  // İZİN DURUMUNU KONTROL ET
  // ============================================================

  Future<void> checkPermission() async {
    final service = ref.read(
      notificationServiceProvider,
    );

    await service.initialize();

    final granted =
    await service.isPermissionGranted();

    state = state.copyWith(
      hasPermission: granted,
    );

    if (granted) {
      await service.startListening();
    }
  }
  Future<void> confirmNotificationAccess() async {
    final repository = DailyBehaviorStatsRepository();

    await repository.setNotificationAccessConfirmed(true);
  }

  // ============================================================
  // DİNLEMEYİ DURDUR
  // ============================================================

  Future<void> stopListening() async {
    final service = ref.read(
      notificationServiceProvider,
    );

    await service.stopListening();
  }
}