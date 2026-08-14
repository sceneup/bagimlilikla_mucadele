import 'dart:convert';
import 'package:bagimlilik/features/notification/repositories/daily_behavior_stats_repository.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/repositories/bekleme_listesi_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();
  final DailyBehaviorStatsRepository _statsRepository =
  DailyBehaviorStatsRepository();
  final GoRouter router;

  LocalNotificationService({
    required this.router,
  });

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
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

  // NORMAL MİKRO MÜDAHALE

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

  Future<void> showShoppingVerificationNotification({
    required String title,
    required String body,
    required String merchantName,
    String? amount,
  }) async {
    // SADECE BU BİLDİRİM İÇİN YÖNLENDİRME BİLGİSİ
    final payload = jsonEncode({
      'type': 'waiting_list',
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

  Future<void> _onNotificationResponse(
      NotificationResponse response,
      ) async {
    debugPrint(
      '🔔 Notification action: ${response.actionId}',
    );

    switch (response.actionId) {
    // --------------------------------------------------------
    // BEKLEME LİSTESİNE EKLE BUTONU
    // --------------------------------------------------------

      case 'add_to_waiting_list':
        _addToWaitingList(response);
        break;

    // --------------------------------------------------------
    // ŞİMDİLİK GEÇ
    // --------------------------------------------------------

      case 'skip':
        await _statsRepository.incrementSkip();
        debugPrint(
          '⚪ Şimdilik geç seçildi.',
        );
        break;

    // --------------------------------------------------------
    // BİLDİRİMİN KENDİSİNE TIKLANDI
    // --------------------------------------------------------

      default:
        _handleNotificationTap(response);
        break;
    }
  }

  // ============================================================
  // BİLDİRİMİN KENDİSİNE TIKLANINCA
  // ============================================================

  void _handleNotificationTap(
      NotificationResponse response,
      ) {
    try {
      final payload = response.payload;

      if (payload == null || payload.isEmpty) {
        router.push('/bilgi');
        return;
      }

      final data =
      jsonDecode(payload) as Map<String, dynamic>;

      final type = data['type']?.toString();

      if (type != 'waiting_list') {
        return;
      }

      final user =
          Supabase.instance.client.auth.currentUser;

      if (user == null) {
        debugPrint(
          '⚠️ Kullanıcı giriş yapmamış.',
        );

        router.push('/giris');
        return;
      }

      debugPrint(
        '📋 Bekleme listesine yönlendiriliyor.',
      );

      router.push('/odak-kontrolu');
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Bildirim yönlendirme hatası: $e',
      );

      debugPrint(
        stackTrace.toString(),
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
      debugPrint(
        '🟢 Bekleme listesine ekle seçildi.',
      );

      final payload = response.payload;

      if (payload == null || payload.isEmpty) {
        debugPrint(
          '❌ Notification payload bulunamadı.',
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
        debugPrint(
          '❌ İşyeri bilgisi bulunamadı.',
        );
        return;
      }

      debugPrint(
        '🏪 İşyeri: $merchantName',
      );

      debugPrint(
        '💰 Tutar: $amount',
      );

      double? fiyat;

      if (amount != null &&
          amount.isNotEmpty) {
        final temizTutar = amount
            .replaceAll('₺', '')
            .replaceAll('TL', '')
            .replaceAll(' ', '')
            .replaceAll('.', '')
            .replaceAll(',', '.');

        fiyat = double.tryParse(
          temizTutar,
        );
      }

      final repository =
      BeklemeListesiRepository();

      final yeniOge = BeklemeOgesi(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        userId: repository.currentUserId,
        kategoriId: merchantName,
        tetikleyiciId: merchantName,
        eklenmeTarihi: DateTime.now(),
        fiyat: fiyat,
      );

      await repository.ogeEkle(
        yeniOge,
      );
      await _statsRepository.incrementWaitingList();
      debugPrint(
        '✅ Alışveriş bekleme listesine eklendi.',
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Bekleme listesine ekleme hatası: $e',
      );

      debugPrint(
        stackTrace.toString(),
      );
    }
  }
}