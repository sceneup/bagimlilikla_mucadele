import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class DegerlendirmeBadge extends StatelessWidget {
  final String text;

  const DegerlendirmeBadge({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class DegerlendirmeSecenekKarti extends StatelessWidget {
  final String iconText;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const DegerlendirmeSecenekKarti({
    required this.iconText,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected ? AppColors.secondaryContainer : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.border.withValues(alpha: 0.4),
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : AppColors.secondaryContainer2,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    iconText,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
