import 'package:flutter/material.dart';
import 'package:bagimlilik/core/colors/app_colors.dart';

class OneriCardAlani extends StatelessWidget {
  const OneriCardAlani({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.energy_savings_leaf,color: AppColors.accent,size: 30,),
              const SizedBox(width: 20,),
              Expanded(child: const Text("Mindful Öneri",style: TextStyle(color: AppColors.accent,fontSize: 24),))
            ],
          ),
          const SizedBox(height: 8,),
          Text(
              "\"Bir dahaki sefere bu sayaçları gördüğünüzde, derin bir nefes alın ve kendinize gerçekten ihtiyacınız olup olmadığını sorun.\"",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
