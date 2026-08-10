import 'package:bagimlilik/features/notification/services/local_notification_service.dart';

class VerificationInterventionService {
  final LocalNotificationService _notificationService;

  VerificationInterventionService(
      this._notificationService,
      );

  Future<void> sendShoppingVerificationNotification({
    required String merchantName,
    String? amount,
  }) async {
    print("🟢 VerificationInterventionService ÇALIŞTI");

    final shoppingInfo = amount != null
        ? "$merchantName üzerinden $amount TL"
        : merchantName;

    print("🟢 Bildirim gönderiliyor: $shoppingInfo");

    await _notificationService.showMicroIntervention(
      title: "Alışveriş doğrulaması algılandı 🛒",
      body:
      "$shoppingInfo tutarında bir alışveriş için doğrulama kodu algılandı. "
          "Bu alışverişi bekleme listene eklemek ister misin?",
    );

    print("🟢 Local notification çağrısı tamamlandı");
  }
}