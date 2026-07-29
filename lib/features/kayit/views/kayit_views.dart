import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/kayit/widgets/devam_button.dart';
import 'package:bagimlilik/features/kayit/widgets/kayit_baslik.dart';
import 'package:bagimlilik/features/kayit/widgets/kayit_form.dart';
import 'package:flutter/material.dart';

class KayitViews extends StatelessWidget {
  const KayitViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(title: "Sirius"),
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 8.0),
                child:  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      spacing: 16,
                      children: [
                        KayitBaslik(adim: "1", value: 0.5, title: "Hesap Oluştur", description: "Sirius'a katılın ve kişisel gelişim yolculuğunuza başlayın."),
                        KayitForm(),
                        DevamButton()
                      ],
                    ),
                  ),
              ),
        ),
      ),
    );
  }
}
