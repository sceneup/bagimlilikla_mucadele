import 'package:bagimlilik/core/routers/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class BildirimService {
  static final BildirimService _instance = BildirimService._internal();

  factory BildirimService() => _instance;

  BildirimService._internal();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _hazir = false;

  Future<void> baslat() async {
    if (_hazir) {
      return;
    }

    tz_data.initializeTimeZones();

    const androidAyarlari = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosAyarlari = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const ayarlar = InitializationSettings(
      android: androidAyarlari,
      iOS: iosAyarlari,
    );

    await _plugin.initialize(
      ayarlar,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("🔔 Bildirime tıklandı: ${response.payload}");
        appRouter.push('/yeniden-degerlendirme');
      },
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    _hazir = true;
  }

  Future<void> hatirlaticiKur({
    required int id,
    required String kategoriIsim,
    required DateTime tetikTarihi,
  }) async {
    await baslat();

    const androidDetaylari = AndroidNotificationDetails(
      'bekleme_listesi_kanali',
      'Bekleme Listesi Hatırlatmaları',
      channelDescription:
          'Bekleme listesindeki ürünler için 24 saatlik mola tamamlandığında bildirim',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );
    const iosDetaylari = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const bildirimDetaylari = NotificationDetails(
      android: androidDetaylari,
      iOS: iosDetaylari,
    );

    final utcTetik = tetikTarihi.toUtc();
    final tzZaman = tz.TZDateTime.from(utcTetik, tz.UTC);

    debugPrint('🔔 Bildirim planlandı: ID=$id, UTC Zamanı=$utcTetik');

    await _plugin.zonedSchedule(
      id,
      '🌿 24 saatin doldu',
      '$kategoriIsim — Dün almak istediğin ürün hâlâ aklında mı? Şimdi kararını yeniden değerlendirebilirsin.',
      tzZaman,
      bildirimDetaylari,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'yeniden_degerlendirme',
    );
  }

  Future<void> anlikTestBildirimiGoster() async {
    await baslat();
    const androidDetaylari = AndroidNotificationDetails(
      'bekleme_listesi_kanali',
      'Bekleme Listesi Hatırlatmaları',
      channelDescription:
          'Bekleme listesindeki ürünler için 24 saatlik mola tamamlandığında bildirim',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const bildirimDetaylari = NotificationDetails(android: androidDetaylari);
    await _plugin.show(
      99999,
      '🌿 Test Bildirimi',
      'Bildirimler cihazında başarıyla çalışıyor! Süre dolduğunda bu ekran açılacak.',
      bildirimDetaylari,
      payload: 'yeniden_degerlendirme',
    );
  }

  Future<void> hatirlaticiIptalEt(int id) async {
    await _plugin.cancel(id);
  }
}
