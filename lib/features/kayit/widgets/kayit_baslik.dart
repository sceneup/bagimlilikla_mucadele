import 'package:flutter/material.dart';
import 'package:bagimlilik/core/colors/app_colors.dart';

class KayitBaslik extends StatelessWidget {
  final String adim;
  final double value;
  final String title;
  final String description;
  const KayitBaslik(
      {
        super.key,
        required this.adim,
        required this.value,
        required this.title,
        required this.description,
      }
      );

  @override
  Widget build(BuildContext context) {
    double widths = MediaQuery.sizeOf(context).width;
    return Column(
      spacing: 5,
      children: [
        Text("ADIM $adim",style: const TextStyle(color: AppColors.primary,fontSize: 18,fontWeight: FontWeight.w800),),
        SizedBox(
          width: widths/2,
          child: LinearProgressIndicator(
            color: AppColors.accent,
            value: value,
            minHeight: 8,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w800),),
        Text(description,style: const TextStyle(fontSize: 16),textAlign: TextAlign.center,),
      ],
    );
  }
}
