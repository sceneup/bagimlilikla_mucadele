import 'package:flutter/material.dart';
import 'package:bagimlilik/core/colors/app_colors.dart';

class BeklemeListBaslik extends StatelessWidget {
  const BeklemeListBaslik({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        const Text("Bekleme Listem",style: TextStyle(fontSize: 24),),
        const Spacer(),
        const Text("Tümünü Gör",style: TextStyle(color:AppColors.accent,fontSize: 18),),
      ],
    );
  }
}
