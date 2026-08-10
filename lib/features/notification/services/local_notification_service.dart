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

    // Plugin'i başlat
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
    final androidDetails = AndroidNotificationDetails(
      'micro_intervention_channel',
      'Mikro Müdahaleler',
      channelDescription:
      'Alışveriş davranışlarına yönelik farkındalık bildirimleri',
      importance: Importance.high,
      priority: Priority.high,

      // ========================================================
      // UZUN METNİ GENİŞLETİLEBİLİR YAP
      // ========================================================

      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'Sirius',
      ),
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      DateTime.now()
          .millisecondsSinceEpoch
          .remainder(100000),
      title,
      body,
      notificationDetails,
    );
  }
}