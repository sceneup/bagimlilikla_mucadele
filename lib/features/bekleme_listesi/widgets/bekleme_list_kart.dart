import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:flutter/material.dart';

class BeklemeListKart extends StatelessWidget {
  final BeklemeOgesi oge;
  final Kategori? kategori;
  final VoidCallback? onTap;
  final ValueChanged<String>? onKararSecildi;

  const BeklemeListKart({
    required this.oge,
    this.kategori,
    this.onTap,
    this.onKararSecildi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final suresiDoldu = oge.suresiDoldu || oge.status == 'ready_for_evaluation';
    final kalan = oge.kalanSure;
    final kalanSaat = (kalan.inMinutes / 60.0).ceil();

    final String durumMetni;
    if (suresiDoldu) {
      durumMetni = 'Süre doldu, kararını ver!';
    } else if (kalanSaat > 1) {
      durumMetni = '$kalanSaat saat kaldı';
    } else if (kalan.inMinutes > 0) {
      durumMetni = '${kalan.inMinutes} dakika kaldı';
    } else {
      durumMetni = 'Az önce eklendi';
    }

    final kategoriBulundu = kategori != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kategoriBulundu
                        ? kategori!.arkaplanRengi
                        : const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    kategoriBulundu
                        ? kategori!.ikon
                        : Icons.storefront,
                    color: kategoriBulundu
                        ? kategori!.simgeRengi
                        : const Color(0xFF7A7A7A),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kategoriBulundu
                            ? kategori!.isim
                            : oge.kategoriId,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        durumMetni,
                        style: TextStyle(
                          color: suresiDoldu
                              ? Colors.redAccent
                              : AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                if (oge.fiyat != null) ...[
                  Text(
                    '₺${oge.fiyat!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    value: oge.ilerlemeOrani,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                    color: suresiDoldu
                        ? Colors.redAccent
                        : AppColors.primary,
                    backgroundColor: AppColors.secondaryContainer,
                  ),
                ),
              ],
            ),

            if (suresiDoldu && onKararSecildi != null) ...[
              const Divider(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 8,
                runSpacing: 6,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => onKararSecildi!('abandoned'),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Vazgeçtim', style: TextStyle(fontSize: 12)),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => onKararSecildi!('wait_more'),
                    icon: const Icon(Icons.history, size: 16),
                    label: const Text('+24 Saat Bekle', style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => onKararSecildi!('purchased'),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                    label: const Text('Satın Aldım', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}