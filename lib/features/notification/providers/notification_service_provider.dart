import 'package:bagimlilik/features/notification/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider =
Provider<NotificationService>((ref) {
  final service = NotificationService();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});