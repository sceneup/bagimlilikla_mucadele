import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // ============================================================
  // BAŞLAT + İZİN İSTE
  // ============================================================

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    // Önce plugin'i başlat
    await _plugin.initialize(settings);

    // Android bildirim izni
    final androidImplementation =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  // ============================================================
  // BİLDİRİM GÖNDER
  // ============================================================

  Future<void> showMicroIntervention({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'micro_intervention_channel',
      'Mikro Müdahaleler',
      channelDescription:
      'Alışveriş davranışlarına yönelik farkındalık bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
    );
  }
}