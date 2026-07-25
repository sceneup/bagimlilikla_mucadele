import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/anket/widgets/anket_baslik_alani.dart';
import 'package:bagimlilik/features/anket/widgets/anket_gizlilik.dart';
import 'package:bagimlilik/features/anket/widgets/anketcard/anket_soru_card.dart';
import 'package:flutter/material.dart';

class AnketViews extends StatelessWidget {
  const AnketViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(title: "Bölüm 1/6"),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
              child: Column(
                children: [
                  AnketBaslikAlani(value: 0.3,),
                  const SizedBox(height: 16,),
                  AnketSoruCard(soruNo:1 ,soruMetni: "lorem ipsum lorem",),
                  const SizedBox(height: 16,),
                  AnketSoruCard(soruNo:2 ,soruMetni: "lorem ipsum lorem",),
                  const SizedBox(height: 16,),
                  AnketSoruCard(soruNo:3 ,soruMetni: "lorem ipsum lorem",),
                  const SizedBox(height: 16,),
                  const AnketGizlilik(),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: (){},
                        child: const Text("Devam Et",style:  const TextStyle(fontSize: 30),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple2,
                          foregroundColor: Colors.white
                        ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                ],
              ),
            ),
          )
      ),
    );
  }
}
