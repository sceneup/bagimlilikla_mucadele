import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/degerlendirme_secenek_karti.dart';
import 'package:flutter/material.dart';

class DegerlendirAdimi extends StatelessWidget {
  final String? seciliIhtiyac;
  final ValueChanged<String> onIhtiyacSecildi;

  const DegerlendirAdimi({
    required this.seciliIhtiyac,
    required this.onIhtiyacSecildi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DegerlendirmeBadge(text: 'BİR KEZ DAHA DÜŞÜNELİM.'),
          const SizedBox(height: 16),

          const Text(
            'Bu ürün şu anda gerçekten ihtiyacın olan bir şey mi?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Dürüst olmak iyidir. Sadece kendine sor.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          DegerlendirmeSecenekKarti(
            iconText: '❤️',
            title: 'Evet, ihtiyacım var',
            description: 'Gerçekten kullanacağım bir şey.',
            isSelected: seciliIhtiyac == 'evet',
            onTap: () => onIhtiyacSecildi('evet'),
          ),
          const SizedBox(height: 12),

          DegerlendirmeSecenekKarti(
            iconText: '💜',
            title: 'Emin değilim',
            description: 'Belki de sadece anlık bir heves.',
            isSelected: seciliIhtiyac == 'emin_degilim',
            onTap: () => onIhtiyacSecildi('emin_degilim'),
          ),
          const SizedBox(height: 12),

          DegerlendirmeSecenekKarti(
            iconText: '🌱',
            title: 'Hayır, ihtiyacım yok',
            description: 'Bunu harcayacak paramı biriktirebilirim.',
            isSelected: seciliIhtiyac == 'hayir',
            onTap: () => onIhtiyacSecildi('hayir'),
          ),
        ],
      ),
    );
  }
}
