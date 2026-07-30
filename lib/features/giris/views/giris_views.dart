import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/giris/widgets/giris_baslik.dart';
import 'package:bagimlilik/features/giris/widgets/giris_form.dart';
import 'package:flutter/material.dart';

class GirisViews extends StatelessWidget {
  const GirisViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 10,
              children: [
                Center(child: GirisBaslik()),
                GirisForm(),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.health_and_safety_rounded,color: AppColors.textSecondary,),
                    const Text("Verileriniz güvende ve gizli tutulur.",style: TextStyle(color: AppColors.textSecondary),),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
