import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/bekleme_listesi/viewmodels/bekleme_listesi_view_model.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/bekleme_list_kart.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:bagimlilik/features/odak_kontrolu/services/kategori_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeklemeListesiView extends ConsumerWidget {
  const BeklemeListesiView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncListe = ref.watch(
      beklemeListesiViewModelProvider,
    );

    final kategoriler = KategoriService().kategorileriGetir();

    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: const CustomAppBar(
        title: 'Bekleme Listem',
        centerTitle: false,
      ),
      body: asyncListe.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Liste yüklenirken bir hata oluştu: $error',
          ),
        ),
        data: (liste) {
          if (liste.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Bekleme listende henüz bir şey yok.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: liste.length,
            separatorBuilder: (context, index) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final oge = liste[index];

              // Sabit kategorilerde varsa ilgili kategori bulunur.
              // Örneğin:
              // giyim      -> Giyim
              // kozmetik  -> Kozmetik & Bakım
              //
              // Sabit listede yoksa null kalır.
              // Örneğin:
              // TRENDYOL   -> null
              Kategori? kategori;

              for (final item in kategoriler) {
                if (item.id == oge.kategoriId) {
                  kategori = item;
                  break;
                }
              }

              return Dismissible(
                key: ValueKey(oge.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) {
                  ref
                      .read(
                    beklemeListesiViewModelProvider.notifier,
                  )
                      .kaldir(oge.id);
                },
                child: BeklemeListKart(
                  oge: oge,
                  kategori: kategori,
                ),
              );
            },
          );
        },
      ),
    );
  }
}