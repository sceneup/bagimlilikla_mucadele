import 'package:bagimlilik/core/routers/app_router.dart';
import 'package:flutter/widgets.dart';
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

    // Cihazın yerel timezone'unu doğru ayarla
    final timezoneName = DateTime.now().timeZoneName;
    try {
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      // Timezone adı tanınmazsa UTC+3 olarak Türkiye saatini ayarla
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
      } catch (_) {
        // UTC'de devam et
      }
    }

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
        if (response.payload == 'yeniden_degerlendirme') {
          appRouter.push('/yeniden-degerlendirme');
        }
      },
    );

    // Uygulama kapalıyken bildirime tıklanarak açıldıysa direkt yönlendir
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails?.notificationResponse?.payload;
      debugPrint("🔔 Uygulama kapalıyken bildirime tıklandı: $payload");
      if (payload == 'yeniden_degerlendirme') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appRouter.push('/yeniden-degerlendirme');
        });
      }
    }

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

    // 32-bit integer taşmasını kesin olarak önle
    final safeId = id & 0x7FFFFFFF;

    // tetikTarihi yerel saatle gelir, tz.local'e çevirerek zamanla
    final tzZaman = tz.TZDateTime.from(tetikTarihi, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    final hedef = tzZaman.isBefore(now) ? now.add(const Duration(seconds: 5)) : tzZaman;

    debugPrint('🔔 Bildirim planlandı: ID=$safeId, Hedef=$hedef (şimdi=$now)');

    try {
      await _plugin.zonedSchedule(
        safeId,
        '🌿 24 saatin doldu',
        '$kategoriIsim — Dün almak istediğin ürün hâlâ aklında mı? Şimdi kararını yeniden değerlendirebilirsin.',
        hedef,
        bildirimDetaylari,
        // alarmClock: ekran kilitli/pil tasarrufu modunda dahi çalışır
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'yeniden_degerlendirme',
      );
      debugPrint('✅ Bildirim alarmClock modunda başarıyla planlandı: ID=$safeId');
    } catch (e) {
      debugPrint('⚠️ alarmClock başarısız, exactAllowWhileIdle deneniyor: $e');
      try {
        await _plugin.zonedSchedule(
          safeId,
          '🌿 24 saatin doldu',
          '$kategoriIsim — Dün almak istediğin ürün hâlâ aklında mı? Şimdi kararını yeniden değerlendirebilirsin.',
          hedef,
          bildirimDetaylari,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'yeniden_degerlendirme',
        );
      } catch (e2) {
        debugPrint('⚠️ exactAllowWhileIdle başarısız, inexact deneniyor: $e2');
        await _plugin.zonedSchedule(
          safeId,
          '🌿 24 saatin doldu',
          '$kategoriIsim — Dün almak istediğin ürün hâlâ aklında mı? Şimdi kararını yeniden değerlendirebilirsin.',
          hedef,
          bildirimDetaylari,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'yeniden_degerlendirme',
        );
      }
    }

    // ─── DEBUG: Planlanan bildirimleri logla ───
    final bekleyenler = await _plugin.pendingNotificationRequests();
    debugPrint('📋 Toplam planlanmış bildirim sayısı: ${bekleyenler.length}');
    for (final b in bekleyenler) {
      debugPrint('   └─ ID:${b.id} | Başlık: ${b.title} | Body: ${b.body}');
    }

    // ─── DEBUG: Hemen anlık bildirim göster (kanalın çalıştığını doğrular) ───
    await _plugin.show(
      (safeId + 1000) & 0x7FFFFFFF,
      '✅ Alarm kuruldu',
      '$kategoriIsim için ${hedef.hour}:${hedef.minute.toString().padLeft(2, '0')} zamanında bildirim gelecek.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bekleme_listesi_kanali',
          'Bekleme Listesi Hatırlatmaları',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
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
    await _plugin.cancel(id + 1000000); // debug bildirimini de iptal et
  }
}
