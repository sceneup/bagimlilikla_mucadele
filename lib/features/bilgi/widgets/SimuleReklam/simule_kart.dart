import 'package:bagimlilik/features/bilgi/widgets/SimuleReklam/hemen_al_button.dart';
import 'package:bagimlilik/features/bilgi/widgets/SimuleReklam/indirim_kart.dart';
import 'package:bagimlilik/features/bilgi/widgets/SimuleReklam/kampanya_rozet.dart';
import 'package:bagimlilik/features/bilgi/widgets/SimuleReklam/simule_urun_gorsel.dart';
import 'package:bagimlilik/features/bilgi/widgets/SimuleReklam/urun_bilgi_alani.dart';
import 'package:bagimlilik/features/bilgi/widgets/SimuleReklam/zaman_kart_alani.dart';
import 'package:flutter/material.dart';

class SimuleKart extends StatelessWidget {
  const SimuleKart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(16),
         color: Colors.white,
         border: Border.all(color: Colors.orange,width: 2)
       ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              UrunGorselAlani(),
              const Positioned(
                top: 12,
                left: 12,
                child: KampanyaRozet(),
              ),
              const Positioned(
                bottom: 12,
                left: 12,
                child: UrunBilgiAlani(),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: IndirimKart(),
              ),
            ],
          ),
          const SizedBox(height: 16,),
          ZamanKartAlani(),
          const SizedBox(height: 10,),
          HemenAlButton(),

        ],
      ),
    );
  }
}
