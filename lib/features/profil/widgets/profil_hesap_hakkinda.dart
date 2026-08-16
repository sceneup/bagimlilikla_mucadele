import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilHesapHakkinda extends StatelessWidget {
  const ProfilHesapHakkinda({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ayarlar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _AyarSatiri(
                icon: Icons.notifications_none_outlined,
                baslik: 'Bildirimler',
                onTap: () {
                  context.go("/erisim-bildirim");
                },
              ),

              const Divider(
                height: 1,
                indent: 48,
                endIndent: 12,
              ),

              _AyarSatiri(
                icon: Icons.shield_outlined,
                baslik: 'Gizlilik ve KVKK',
                onTap: () {
                  // KVKK sayfası
                },
              ),

              const Divider(
                height: 1,
                indent: 48,
                endIndent: 12,
              ),

              _AyarSatiri(
                icon: Icons.info_outline,
                baslik: 'Hakkında',
                onTap: () {
                  context.go("/hakkinda");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AyarSatiri extends StatelessWidget {
  final IconData icon;
  final String baslik;
  final VoidCallback onTap;

  const _AyarSatiri({
    required this.icon,
    required this.baslik,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}