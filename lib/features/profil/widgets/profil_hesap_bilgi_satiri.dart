import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ProfilHesapBilgiSatiri extends StatelessWidget {
  final IconData icon;
  final String baslik;
  final String deger;
  final VoidCallback onEdit;

  const ProfilHesapBilgiSatiri({
    super.key,
    required this.icon,
    required this.baslik,
    required this.deger,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            // İKON
            SizedBox(
              width: 28,
              child: Icon(
                icon,
                size: 21,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 10),

            // BAŞLIK
            Expanded(
              child: Text(
                baslik,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // DEĞER
            SizedBox(
              width: 115,
              child: Text(
                deger,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent,
                ),
              ),
            ),

            // KALEM
            SizedBox(
              width: 32,
              child: IconButton(
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 17,
                ),
                color: AppColors.textSecondary,
                tooltip: 'Düzenle',
              ),
            ),
          ],
        ),
      ),
    );
  }
}