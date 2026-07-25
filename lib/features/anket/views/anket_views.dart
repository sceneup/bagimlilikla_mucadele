import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/anket/widgets/anket_baslik_alani.dart';
import 'package:bagimlilik/features/anket/widgets/anket_gizlilik.dart';
import 'package:bagimlilik/features/anket/widgets/anketcard/anket_soru_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bagimlilik/features/anket/viewmodels/anket_view_models.dart';

class AnketViews extends ConsumerWidget {
  const AnketViews({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final cevaplar = ref.watch(anketViewModelProvider);
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
                  AnketSoruCard(
                    soruNo:1 ,
                    soruMetni: "lorem ipsum lorem",
                    seciliDeger:cevaplar[1],
                    onChanged: (value){
                      if (value != null) {
                        ref
                            .read(anketViewModelProvider.notifier)
                            .cevapSec(1, value);
                      }
                    },
                  ),
                  const SizedBox(height: 16,),
                  AnketSoruCard(
                    soruNo:2 ,
                    soruMetni: "lorem ipsum lorem",
                    seciliDeger:cevaplar[2],
                    onChanged: (value){
                      if (value != null) {
                        ref
                            .read(anketViewModelProvider.notifier)
                            .cevapSec(2, value);
                      }
                    },
                  ),const SizedBox(height: 16,),
                  AnketSoruCard(
                    soruNo:3 ,
                    soruMetni: "lorem ipsum lorem",
                    seciliDeger:cevaplar[3],
                    onChanged: (value){
                      if (value != null) {
                        ref
                            .read(anketViewModelProvider.notifier)
                            .cevapSec(3, value);
                      }
                    },
                  ),const SizedBox(height: 16,),
                  const AnketGizlilik(),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple2,
                          foregroundColor: Colors.white
                        ),
                       child: const Text("Devam Et",style: TextStyle(fontSize: 30),),
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
