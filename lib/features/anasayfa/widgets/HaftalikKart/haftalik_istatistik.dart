import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class HaftalikIstatistik extends StatelessWidget {
  const HaftalikIstatistik({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Column(
          children: [
            Text("12",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.accent),),
            const Text("Fark edildi",style: TextStyle(fontSize:16),),
          ],
        )),
        Expanded(child: Column(
          children: [
            Text("8",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.accent),),
            const Text("Ertelendi",style: TextStyle(fontSize:16),),
          ],
        )),
        Expanded(child: Column(
          children: [
            Text("₺1200",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.accent),),
            const Text("Harcanmadı",style: TextStyle(fontSize:16),),
          ],
        )),
      ],
    );
  }
}
