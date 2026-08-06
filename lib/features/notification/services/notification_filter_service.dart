import 'package:bagimlilik/features/notification/enums/notification_type.dart';

class NotificationFilterService {

  NotificationType detect({
    required String packageName,
    required String title,
    required String content,
  }) {

    final package = packageName.toLowerCase();
    final text = "$title $content".toLowerCase();

    /// Bankalar
    const bankKeywords = [
      "ziraat",
      "vakıf",
      "vakif",
      "garanti",
      "akbank",
      "iş bankası",
      "is bankasi",
      "şekerbank",
      "sekerbank",
      "qnb",
      "enpara",
      "denizbank",
      "teb",
      "yapı kredi",
      "yapi kredi",
      "halkbank",
    ];

    /// E-Ticaret
    const shoppingKeywords = [
      "trendyol",
      "hepsiburada",
      "amazon",
      "n11",
      "boyner",
      "flo",
      "lc waikiki",
      "lcw",
      "defacto",
      "mavi",
      "koton",
      "pazarama",
    ];

    /// Kampanya
    const campaignKeywords = [
      "indirim",
      "kampanya",
      "kaçırma",
      "son gün",
      "stok",
      "hemen al",
      "fırsat",
      "kupon",
      "%"
    ];

    /// Kargo
    const shippingKeywords = [
      "kargoya verildi",
      "teslim edildi",
      "dağıtıma çıktı",
      "siparişiniz",
    ];

    /// Önce SMS mi kontrol et
    if (package.contains("messaging")) {

      if (bankKeywords.any((e) => text.contains(e)) &&
          shoppingKeywords.any((e) => text.contains(e))) {
        return NotificationType.shoppingVerification;
      }

      if (bankKeywords.any((e) => text.contains(e))) {
        return NotificationType.bankSms;
      }
    }

    /// Kampanya
    if (campaignKeywords.any((e) => text.contains(e))) {
      return NotificationType.campaign;
    }

    /// Kargo
    if (shippingKeywords.any((e) => text.contains(e))) {
      return NotificationType.shipping;
    }

    /// Sosyal Medya
    if (package.contains("instagram") ||
        package.contains("facebook") ||
        package.contains("tiktok") ||
        package.contains("youtube") ||
        package.contains("whatsapp"))
    {

      return NotificationType.socialMedia;
    }

    return NotificationType.unknown;
  }
}