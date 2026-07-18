import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BeklemeListKart extends StatelessWidget {
  const BeklemeListKart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(5),
            ),
              child: Icon(Icons.check)
          ),
          const SizedBox(width: 20,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kablosuz Kulaklık",style: TextStyle(fontSize: 18),),
                  Text("18 saat kaldı",style: TextStyle(color: AppColors.primary,fontSize: 14,fontWeight: FontWeight.w600),),
                ],
          ),
          ),
          SizedBox(
            width: 80,
              child: LinearProgressIndicator(
                value: 0.75,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary,
                backgroundColor: AppColors.secondaryContainer,
              )
          ),
        ],
      ),
    );
  }
}
