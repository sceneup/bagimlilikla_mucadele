import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BilgiSayfasiBaslik extends StatelessWidget {
  const BilgiSayfasiBaslik({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Alışveriş Tetikleyicilerini Tanı",style: TextStyle(color: AppColors.accent,fontSize: 24,fontWeight: FontWeight.w800),),
        Text("Dürtüsel harcamaların ardındaki psikolojiyi keşfedin",style: TextStyle(color: Colors.brown,fontSize: 20),)
      ],
    );
  }
}
