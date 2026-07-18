import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/anasayfa/widgets/gunluk_progress_indicator.dart';
import 'package:flutter/material.dart';

class GunlukDurumKart extends StatelessWidget {
  const GunlukDurumKart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("BUGÜNKİ DURUMUM",style: TextStyle(color: Colors.white,fontSize:20),),
                  const SizedBox(height: 8,),
                  const Text("Odak kontrolü:",style: TextStyle(color: Colors.white,fontSize: 16),),
                  const SizedBox(width: 4),
                  Text("Dengeli",style: TextStyle(color: Colors.white,fontSize: 16),),
                  Text("Son kontrolünden bu yana 3 bilinçli karar verdin",style: TextStyle(color: AppColors.secondaryContainer,fontSize: 16),),
                ],
              ),
          ),
          GunlukProgressIndicator(value: 0.75,),
        ],
      ),
    );
  }
}