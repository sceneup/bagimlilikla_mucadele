import 'package:bagimlilik/features/anasayfa/widgets/HedefKart/hedef_kart_baslik.dart';
import 'package:bagimlilik/features/anasayfa/widgets/HedefKart/hedef_progressbar.dart';
import 'package:bagimlilik/features/anasayfa/widgets/HedefKart/hedef_sonuc.dart';
import 'package:flutter/material.dart';

class HedefKart extends StatelessWidget {
  const HedefKart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
           HedefKartBaslik(),
           const SizedBox(height: 16,),
           HedefProgressbar(),
           const SizedBox(height: 16,),
           HedefSonuc(),
        ],
      ),
    );
  }
}
