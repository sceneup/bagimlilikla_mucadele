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

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final androidImplementation =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  // ============================================================
  // NORMAL MİKRO MÜDAHALE
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
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
    );
  }

  // ============================================================
  // ALIŞVERİŞ DOĞRULAMA BİLDİRİMİ
  // ============================================================

  Future<void> showShoppingVerificationNotification({
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'shopping_verification_channel',
      'Alışveriş Doğrulamaları',
      channelDescription:
      'Alışveriş doğrulama bildirimleri',
      importance: Importance.high,
      priority: Priority.high,

      // ----------------------------------------------------------
      // UZUN METİN
      // ----------------------------------------------------------

      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'Sirius',
      ),

      // ----------------------------------------------------------
      // ACTIONLAR
      // ----------------------------------------------------------

      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'add_to_waiting_list',
          'Bekleme listesine al',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          'skip',
          'Şimdilik geç',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
    );
  }

  // ============================================================
  // ACTION CEVABI
  // ============================================================

  void _onNotificationResponse(
      NotificationResponse response,
      ) {
    print(
      '🔔 Notification action: ${response.actionId}',
    );

    switch (response.actionId) {
      case 'add_to_waiting_list':
        print(
          '🟢 Bekleme listesine al seçildi.',
        );
        break;

      case 'skip':
        print(
          '⚪ Şimdilik geç seçildi.',
        );
        break;

      default:
        print(
          'ℹ️ Bildirime tıklandı.',
        );
    }
  }
}