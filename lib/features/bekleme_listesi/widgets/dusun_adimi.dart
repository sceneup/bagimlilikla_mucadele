import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/degerlendirme_secenek_karti.dart';
import 'package:flutter/material.dart';

class DusunAdimi extends StatelessWidget {
  final TextEditingController controller;

  const DusunAdimi({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DegerlendirmeBadge(text: 'KENDİNE BİR SORU SOR.'),
          const SizedBox(height: 16),

          const Text(
            'Şimdi almazsan hayatında ne değişir?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Düşüncelerini istersen buraya yazabilirsin.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: TextField(
              controller: controller,
              maxLines: 5,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Aklından geçenleri yazabilirsin...',
                hintStyle: TextStyle(
                  color: AppColors.hint,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
