import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/anket/viewmodels/anket_view_models.dart';
import 'package:bagimlilik/features/anket/widgets/anket_baslik_alani.dart';
import 'package:bagimlilik/features/anket/widgets/anket_gizlilik.dart';
import 'package:bagimlilik/features/anket/widgets/anketcard/anket_soru_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnketViews extends ConsumerWidget {
  const AnketViews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAnketState = ref.watch(anketViewModelProvider);
    return asyncAnketState.when(
      loading: () {
        return Scaffold(
          backgroundColor: AppColors.secondaryContainer2,
          appBar: CustomAppBar(
            title: "Anket yükleniyor",
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

      error: (error, stackTrace) {
        return Scaffold(
          backgroundColor: AppColors.secondaryContainer2,
          appBar: CustomAppBar(
            title: "Anket",
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Anket yüklenirken bir hata oluştu:\n$error",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },

      data: (anketState) {
        if (anketState.bolumler.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.secondaryContainer2,
            appBar: CustomAppBar(
              title: "Anket",
            ),
            body: const Center(
              child: Text("Anket soruları bulunamadı."),
            ),
          );
        }

        final aktifBolum =
        anketState.bolumler[anketState.aktifBolumIndex];

        return Scaffold(
          backgroundColor: AppColors.secondaryContainer2,
          appBar: CustomAppBar(
            title: "Bölüm ${anketState.aktifBolumIndex + 1}/${anketState.bolumler.length}",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    AnketBaslikAlani(
                      value:
                      (anketState.aktifBolumIndex + 1) /
                          anketState.bolumler.length,
                    ),

                    const SizedBox(height: 16),

                    ...aktifBolum.sorular.map((soru) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AnketSoruCard(
                          soruNo: soru.id,
                          soruMetni: soru.metin,
                          seciliDeger: anketState.cevaplar[soru.id],
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }

                            ref
                                .read(anketViewModelProvider.notifier)
                                .cevapSec(soru.id, value);
                          },
                        ),
                      );
                    }),

                    const AnketGizlilik(),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        backgroundColor: AppColors.purple2,
                        fontSize: 26,
                        text: anketState.aktifBolumIndex ==
                            anketState.bolumler.length - 1
                            ? "Tamamla"
                            : "Devam Et",
                        onPressed: () {
                          final viewModel =
                          ref.read(anketViewModelProvider.notifier);

                          final tamamlandiMi =
                          viewModel.aktifBolumTamamlandiMi();

                          if (!tamamlandiMi) {
                            EasyLoading.showError(
                              "Lütfen tüm soruları cevaplayınız.",
                            );
                            return;
                          }

                          viewModel.sonrakiBolumeGec();
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}