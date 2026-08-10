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
    final shoppingInfo = amount != null
        ? "$merchantName üzerinden $amount TL"
        : merchantName;

    await _notificationService
        .showShoppingVerificationNotification(
      title: "Alışveriş doğrulaması algılandı 🛒",
      body:
      "$shoppingInfo tutarında bir alışveriş için "
          "doğrulama kodu algılandı. "
          "Bu alışverişi bekleme listene eklemek ister misin?",
      merchantName: merchantName,
      amount: amount,
    );
  }
}