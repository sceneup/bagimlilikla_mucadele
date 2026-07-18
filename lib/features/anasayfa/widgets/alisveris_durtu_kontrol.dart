import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class KontrolKart extends StatelessWidget {
  const KontrolKart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30,),
          Container(
            alignment: Alignment.center,
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent, // Set your border color here
                width: 2.0,         // Set the thickness
              ),
            ),
            child: const Icon(Icons.brightness_auto,color: AppColors.accent,size: 30,),
          ),
          const SizedBox(height: 30,),
          const Text(
            "Bir şey satın almak mı istiyorsun?",
            style: TextStyle(color: AppColors.accent,fontSize: 20,fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20,),
          const Text(
            "Kararını birlikte değerlendirelim\n"
                "gerçek ihtiyacını beraber bulalım",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30,),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: (){},
                child: const Text("Odak Kontrolünü Başlat",style: TextStyle(fontSize: 20),),
              style:ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

            ),
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
