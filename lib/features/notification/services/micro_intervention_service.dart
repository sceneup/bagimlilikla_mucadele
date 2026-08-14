import 'package:bagimlilik/features/notification/enums/dark_pattern_type.dart';
import 'package:bagimlilik/features/notification/services/local_notification_service.dart';
import 'package:bagimlilik/features/notification/repositories/daily_behavior_stats_repository.dart';

class MicroInterventionService {
  final LocalNotificationService _notificationService;

  final DailyBehaviorStatsRepository _statsRepository =
  DailyBehaviorStatsRepository();

  MicroInterventionService(this._notificationService);

  Future<void> sendIntervention(
      List<DarkPatternType> patterns,
      ) async {
    if (patterns.isEmpty ||
        patterns.contains(DarkPatternType.none)) {
      return;
    }

    if (patterns.length > 1) {
      await _notificationService.showMicroIntervention(
        title: "Bir dakika düşün 🧠",
        body:
        "Bu bildirimde birden fazla satın alma tetikleyicisi "
            "bulunuyor. Karar vermeden önce gerçekten ihtiyacın "
            "olup olmadığını değerlendirmek ister misin?",
      );

      await _statsRepository.incrementMicroIntervention();

      return;
    }

    switch (patterns.first) {
      case DarkPatternType.scarcity:
        await _notificationService.showMicroIntervention(
          title: "Bir dakika düşün 🧠",
          body:
          "Bu bildirimde ürünün sınırlı olduğu vurgulanıyor. "
              "Satın almadan önce gerçekten ihtiyacın olup olmadığını "
              "düşünmek ister misin?",
        );
        break;

      case DarkPatternType.urgency:
        await _notificationService.showMicroIntervention(
          title: "Acele etmek zorunda değilsin ⏳",
          body:
          "Bu bildirimde zaman baskısı oluşturuluyor. "
              "Satın alma kararını vermeden önce biraz beklemeyi "
              "düşünebilirsin.",
        );
        break;

      case DarkPatternType.socialProof:
        await _notificationService.showMicroIntervention(
          title: "Herkes alıyor diye almak zorunda değilsin 👥",
          body:
          "Bu bildirimde başkalarının davranışları öne çıkarılıyor. "
              "Senin gerçekten ihtiyacın var mı?",
        );
        break;

      case DarkPatternType.retargeting:
        await _notificationService.showMicroIntervention(
          title: "Daha önce baktığın ürün tekrar karşında 👀",
          body:
          "Bu bildirim daha önce ilgilendiğin bir ürünü yeniden "
              "hatırlatıyor. İhtiyacın devam ediyor mu?",
        );
        break;

      case DarkPatternType.confirmShaming:
        await _notificationService.showMicroIntervention(
          title: "Kararını baskı altında verme 💭",
          body:
          "Bu içerik, satın almaktan vazgeçtiğinde kendini kötü "
              "hissetmene neden olabilecek bir ifade içeriyor.",
        );
        break;

      case DarkPatternType.none:
        return;
    }

    await _statsRepository.incrementMicroIntervention();
  }
}
//değişti