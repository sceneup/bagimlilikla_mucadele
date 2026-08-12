import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:flutter/material.dart';

class BeklemeListKart extends StatelessWidget {
  final BeklemeOgesi oge;
  final Kategori? kategori;
  final VoidCallback? onTap;

  const BeklemeListKart({
    required this.oge,
    this.kategori,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final suresiDoldu = oge.suresiDoldu;
    final kalan = oge.kalanSure;

    final durumMetni = suresiDoldu
        ? 'Süre doldu, tekrar değerlendir'
        : '${kalan.inHours} saat kaldı';

    final kategoriBulundu = kategori != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
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

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    kategoriBulundu
                        ? kategori!.isim
                        : oge.kategoriId,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    durumMetni,
                    style: TextStyle(
                      color: suresiDoldu
                          ? Colors.redAccent
                          : AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 80,
              child: LinearProgressIndicator(
                value: oge.ilerlemeOrani,
                minHeight: 8,
                borderRadius:
                BorderRadius.circular(10),
                color: suresiDoldu
                    ? Colors.redAccent
                    : AppColors.primary,
                backgroundColor:
                AppColors.secondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}