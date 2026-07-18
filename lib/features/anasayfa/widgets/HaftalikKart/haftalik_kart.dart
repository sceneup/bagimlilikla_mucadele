import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/anasayfa/widgets/HaftalikKart/haftalik_istatistik.dart';
import 'package:flutter/material.dart';

class HaftalikKart extends StatelessWidget {
  const HaftalikKart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child:
          Column(
            children: [
              Row(
                children: [
                  const Text("Bu Haftaki Yolculuğun",style: TextStyle(fontSize: 16),),
                  const Spacer(),
                  const Icon(Icons.calendar_month,size: 30,),
                ],
              ),
              const SizedBox(height: 20,),
              HaftalikIstatistik(),
            ],
          ),
    );
  }
}
