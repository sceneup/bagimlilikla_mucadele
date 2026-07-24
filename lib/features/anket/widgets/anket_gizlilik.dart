import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AnketGizlilik extends StatelessWidget {
  const AnketGizlilik({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.energy_savings_leaf,size: 24,color: AppColors.accent,),
        const SizedBox(height: 8,),
        const Text("Yanıtlarınız tamamen gizlidir ve size daha iyi bir yol haritası sunmak için kullanılır.",style: const TextStyle(fontSize: 18,color: Colors.grey),),
      ],
    );
  }
}
