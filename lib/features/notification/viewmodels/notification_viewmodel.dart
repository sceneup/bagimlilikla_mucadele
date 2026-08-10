import 'package:bagimlilik/features/notification/models/notification_state.dart';
import 'package:bagimlilik/features/notification/providers/notification_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationViewModel extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    return const NotificationState();
  }

  Future<void> enableNotifications() async {
    final service = ref.read(notificationServiceProvider);

    // ============================================================
    // 1. LOCAL NOTIFICATION SERVİSİNİ BAŞLAT
    // ============================================================

    await service.initialize();

    // ============================================================
    // 2. BİLDİRİM OKUMA İZNİ
    // ============================================================

    final granted = await service.requestPermission();

    state = state.copyWith(
      hasPermission: granted,
    );

    // ============================================================
    // 3. BİLDİRİMLERİ DİNLE
    // ============================================================

    if (granted) {
      service.startListening();
    }
  }

  void stopListening() {
    ref
        .read(notificationServiceProvider)
        .stopListening();
  }
}