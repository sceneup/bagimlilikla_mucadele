import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/kayit/widgets/kayit_baslik.dart';
import 'package:bagimlilik/features/kayit/widgets/kayit_detay_form.dart';
import 'package:bagimlilik/features/kayit/widgets/kayit_ol_button.dart';
import 'package:bagimlilik/features/kayit/widgets/kvvk_onam.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KayitDetayViews extends StatelessWidget {
  const KayitDetayViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(
        title: "Sirius",
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            context.go("/register");
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                spacing: 16,
                children: [
                  KayitBaslik(
                    adim: "2",
                    value: 1,
                    title: "Bize Kendinizden Bahsedin",
                    description:
                    "Bu bilgiler, deneyiminizi kişiselleştirmeye ve değerlendirme sonuçlarınızı iyileştirmeye yardımcı olur. Verileriniz özenle işlenir.",
                  ),

                  KayitDetayForm(),

                  const KvvkOnam(),

                  const KayitOlButton(),

                  const Text(
                    "© 2026 Sirius. Privacy-focused & secure.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}