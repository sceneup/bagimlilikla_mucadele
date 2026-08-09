import 'package:bagimlilik/features/notification/services/local_notification_service.dart';

class VerificationInterventionService {
  final LocalNotificationService _notificationService;

  VerificationInterventionService(
      this._notificationService,
      );

  Future<void> sendShoppingVerificationNotification({
    required String shoppingName,
  }) async {
    await _notificationService.showMicroIntervention(
      title: "Alışveriş doğrulaması algılandı 🛒",
      body:
      "$shoppingName alışverişine ait bir doğrulama kodu algılandı. "
          "Bu alışverişi bekleme listene eklemek ister misin?",
    );
  }
}