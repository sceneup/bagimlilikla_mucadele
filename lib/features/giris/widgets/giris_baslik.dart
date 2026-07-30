import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GirisBaslik extends StatelessWidget {
  const GirisBaslik({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const SizedBox(height: 50,),
         Container(
           width: 100,
           height: 100,
           decoration: BoxDecoration(
             color: AppColors.secondaryContainer,
             borderRadius: BorderRadius.circular(20),
           ),
         ),
        Text("SIRIUS",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
        Text("Tekrar Hoş Geldiniz\nBugünkü hedeflerine devam etmeye hazır mısın?",textAlign: TextAlign.center,),
      ],
    );
  }
}
