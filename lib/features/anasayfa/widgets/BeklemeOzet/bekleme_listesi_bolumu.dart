import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/bekleme_listesi/viewmodels/bekleme_listesi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BeklemeListesiBolumu extends ConsumerWidget {
  const BeklemeListesiBolumu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncListe = ref.watch(beklemeListesiViewModelProvider);

    return asyncListe.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (liste) {
        if (liste.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Bekleme listende henüz bir şey yok.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        final hazirSayisi = liste.where((oge) => oge.suresiDoldu).length;
        final ozetMetni = hazirSayisi > 0
            ? '${liste.length} ürün bekliyor, $hazirSayisi tanesi değerlendirmeni bekliyor'
            : '${liste.length} ürün bekliyor';

        return InkWell(
          onTap: () => context.push('/bekleme-listesi'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.hourglass_top,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    ozetMetni,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black38),
              ],
            ),
          ),
        );
      },
    );
  }
}
