import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/degerlendirme_secenek_karti.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:bagimlilik/features/odak_kontrolu/services/kategori_service.dart';
import 'package:flutter/material.dart';

class OzetAdimi extends StatelessWidget {
  final BeklemeOgesi? oge;

  const OzetAdimi({
    this.oge,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Kategori? kategori;
    if (oge != null) {
      final kategoriler = KategoriService().kategorileriGetir();
      for (final item in kategoriler) {
        if (item.id == oge!.kategoriId) {
          kategori = item;
          break;
        }
      }
    }

    final kategoriIsim = kategori?.isim ?? oge?.kategoriId ?? 'Genel Harcama';
    final tetikleyici = oge?.tetikleyiciId ?? 'Can Sıkıntısı / Stres';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const DegerlendirmeBadge(text: 'Düşün & Karar Ver'),
          const SizedBox(height: 20),

          const Text(
            '24 saat geçti 🌿',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Dün bu ürünü almak istemiştin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),

          const Text(
            'Bugün hâlâ aklında mı?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 28),

          // Ürün Özet Kartı
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
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kategori?.arkaplanRengi ?? AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    kategori?.ikon ?? Icons.shopping_bag_outlined,
                    color: kategori?.simgeRengi ?? AppColors.primary,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'KATEGORİ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  kategoriIsim,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Tetikleyici Alt Kartı
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.psychology_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tespit Edilen Tetikleyici',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tetikleyici,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Kaydırarak devam et',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.hint,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                size: 14,
                color: AppColors.hint,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
