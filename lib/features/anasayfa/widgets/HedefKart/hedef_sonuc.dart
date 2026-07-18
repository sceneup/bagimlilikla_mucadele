import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class HedefSonuc extends StatelessWidget {
  const HedefSonuc({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.call_made_sharp,color: AppColors.accent,),
          const SizedBox(width: 5,),
          Expanded(child: Text("Bu hafta ₺540 korudun",style: TextStyle(fontSize: 18),))
        ],
      ),
    );
  }
}
