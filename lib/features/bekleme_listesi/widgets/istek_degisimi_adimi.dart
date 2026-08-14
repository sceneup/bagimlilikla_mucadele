import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/degerlendirme_secenek_karti.dart';
import 'package:flutter/material.dart';

class IstekDegisimiAdimi extends StatelessWidget {
  final int? seciliPuan;
  final ValueChanged<int> onPuanSecildi;

  const IstekDegisimiAdimi({
    required this.seciliPuan,
    required this.onPuanSecildi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const DegerlendirmeBadge(text: 'Pause & Reflect'),
          const SizedBox(height: 20),

          const Text(
            'İsteğin değişti mi?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Dün bu ürünü alma isteğini 5/5 olarak değerlendirmiştin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),

          // Derecelendirme Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Şimdi ne kadar istiyorsun?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    final puan = index + 1;
                    final isSelected = seciliPuan == puan;
                    return InkWell(
                      onTap: () => onPuanSecildi(puan),
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.secondaryContainer2,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border.withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          '$puan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Hiç\nistemiyorum',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Çok\nistiyorum',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
