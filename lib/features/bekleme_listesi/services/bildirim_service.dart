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
    const iosAyarlari = DarwinInitializationSettings();
    const ayarlar = InitializationSettings(
      android: androidAyarlari,
      iOS: iosAyarlari,
    );

    await _plugin.initialize(ayarlar);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

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
      importance: Importance.high,
      priority: Priority.high,
    );
    const bildirimDetaylari = NotificationDetails(android: androidDetaylari);

    await _plugin.zonedSchedule(
      id,
      'Tebrikler!',
      '$kategoriIsim için verdiğin 24 saatlik molayı tamamladın. Bir rozet kazandın.',
      tz.TZDateTime.from(tetikTarihi, tz.local),
      bildirimDetaylari,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> hatirlaticiIptalEt(int id) async {
    await _plugin.cancel(id);
  }
}
