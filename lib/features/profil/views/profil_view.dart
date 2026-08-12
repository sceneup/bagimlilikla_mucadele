import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/profil/widgets/profil_app_bar.dart';
import 'package:bagimlilik/features/profil/widgets/profil_avatar_iism_bilgi.dart';
import 'package:bagimlilik/features/profil/widgets/profil_hesap_bilgileri.dart';
import 'package:bagimlilik/features/profil/widgets/profil_hesap_hakkinda.dart';
import 'package:flutter/material.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(
        title: 'Profilim',
        actions: const [
          ProfilAppBar(),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: swidth / 10,
                ),

                const ProfilAvatarIsimBilgi(),

                SizedBox(
                  height: swidth / 10,
                ),

                const ProfilHesapBilgileri(),

                SizedBox(
                  height: swidth / 10,
                ),

                const ProfilHesapHakkinda(),

                SizedBox(
                  height: swidth / 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}