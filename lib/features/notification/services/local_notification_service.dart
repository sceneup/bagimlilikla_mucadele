import 'dart:convert';

import 'package:bagimlilik/features/bekleme_listesi/services/bekleme_listesi_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // ============================================================
  // BAŞLAT + İZİN İSTE
  // ============================================================

  Future<void> initialize() async {
    const androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse:
      _onNotificationResponse,
    );

    final androidImplementation =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation
        ?.requestNotificationsPermission();
  }

  // ============================================================
  // NORMAL MİKRO MÜDAHALE
  // ============================================================

  Future<void> showMicroIntervention({
    required String title,
    required String body,
  }) async {
    final androidDetails =
    AndroidNotificationDetails(
      'micro_intervention_channel',
      'Mikro Müdahaleler',
      channelDescription:
      'Alışveriş davranışlarına yönelik farkındalık bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation:
      BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'Sirius',
      ),
    );

    final notificationDetails =
    NotificationDetails(
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

  // ============================================================
  // ALIŞVERİŞ DOĞRULAMA BİLDİRİMİ
  // ============================================================

  Future<void> showShoppingVerificationNotification({
    required String title,
    required String body,
    required String merchantName,
    String? amount,
  }) async {
    // Action'a aktarılacak bilgiler
    final payload = jsonEncode({
      'merchantName': merchantName,
      'amount': amount,
    });

    final androidDetails =
    AndroidNotificationDetails(
      'shopping_verification_channel',
      'Alışveriş Doğrulamaları',
      channelDescription:
      'Alışveriş doğrulama bildirimleri',
      importance: Importance.high,
      priority: Priority.high,

      // Uzun metin
      styleInformation:
      BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'Sirius',
      ),

      // Actionlar
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

    final notificationDetails =
    NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      DateTime.now()
          .millisecondsSinceEpoch
          .remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // ============================================================
  // ACTION CEVABI
  // ============================================================

  void _onNotificationResponse(
      NotificationResponse response,
      ) {
    print(
      "🔔 Notification action: ${response.actionId}",
    );

    switch (response.actionId) {
      case 'add_to_waiting_list':
        _addToWaitingList(response);
        break;

      case 'skip':
        print(
          "⚪ Şimdilik geç seçildi.",
        );
        break;

      default:
        print(
          "ℹ️ Bildirime tıklandı.",
        );
    }
  }

  // ============================================================
  // BEKLEME LİSTESİNE EKLE
  // ============================================================

  Future<void> _addToWaitingList(
      NotificationResponse response,
      ) async {
    try {
      print(
        "🟢 Bekleme listesine ekle seçildi.",
      );

      final payload = response.payload;

      if (payload == null || payload.isEmpty) {
        print(
          "❌ Notification payload bulunamadı.",
        );
        return;
      }

      final data =
      jsonDecode(payload)
      as Map<String, dynamic>;

      final merchantName =
      data['merchantName']?.toString();

      final amount =
      data['amount']?.toString();

      if (merchantName == null ||
          merchantName.isEmpty) {
        print(
          "❌ İşyeri bilgisi bulunamadı.",
        );
        return;
      }

      print(
        "🏪 İşyeri: $merchantName",
      );

      print(
        "💰 Tutar: $amount",
      );

      final beklemeListesiService =
      BeklemeListesiService();

      await beklemeListesiService
          .bildirimdenEkle(
        merchantName: merchantName,
        amount: amount,
      );

      print(
        "✅ Alışveriş bekleme listesine eklendi.",
      );
    } catch (e, stackTrace) {
      print(
        "❌ Bekleme listesine ekleme hatası: $e",
      );

      print(stackTrace);
    }
  }
}