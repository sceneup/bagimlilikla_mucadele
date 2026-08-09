import 'package:bagimlilik/features/notification/enums/dark_pattern_type.dart';
import 'package:bagimlilik/features/notification/enums/notification_type.dart';

class NotificationAnalysis {
  final NotificationType notificationType;

  final List<DarkPatternType> detectedPatterns;

  final String packageName;

  final String title;

  final String content;

  final String? verificationCode;

  const NotificationAnalysis({
    required this.notificationType,
    required this.detectedPatterns,
    required this.packageName,
    required this.title,
    required this.content,
    this.verificationCode,
  });

  bool get hasDarkPattern {
    return detectedPatterns.isNotEmpty &&
        !detectedPatterns.contains(DarkPatternType.none);
  }

  bool get isShoppingVerification {
    return notificationType ==
        NotificationType.shoppingVerification;
  }
}