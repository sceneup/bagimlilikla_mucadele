import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/degerlendirme_secenek_karti.dart';
import 'package:flutter/material.dart';

class KararAdimi extends StatelessWidget {
  final String? seciliKarar;
  final ValueChanged<String> onKararSecildi;

  const KararAdimi({
    required this.seciliKarar,
    required this.onKararSecildi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DegerlendirmeBadge(text: 'Pause & Reflect'),
          const SizedBox(height: 16),

          const Text(
            'Şimdi ne yapmak istiyorsun?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),

          DegerlendirmeSecenekKarti(
            iconText: '🌱',
            title: 'Vazgeçmek istiyorum',
            description: 'İyi ki biraz bekledim.',
            isSelected: seciliKarar == 'abandoned',
            onTap: () => onKararSecildi('abandoned'),
          ),
          const SizedBox(height: 12),

          DegerlendirmeSecenekKarti(
            iconText: '⏳',
            title: 'Biraz daha beklemek istiyorum',
            description: 'Karar vermek için biraz daha zamana ihtiyacım var.',
            isSelected: seciliKarar == 'wait_more',
            onTap: () => onKararSecildi('wait_more'),
          ),
          const SizedBox(height: 12),

          DegerlendirmeSecenekKarti(
            iconText: '🛍️',
            title: 'Hâlâ satın almak istiyorum',
            description: 'Bu ürünün benim için hâlâ anlamlı olduğunu düşünüyorum.',
            isSelected: seciliKarar == 'purchased',
            onTap: () => onKararSecildi('purchased'),
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Kararını değiştirmek zorunda değilsin. Sadece yeniden düşünmüş oldun.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
