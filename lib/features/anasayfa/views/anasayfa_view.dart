import 'package:bagimlilik/core/widgets/BottomBar/custom_bottom_bar.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/anasayfa/widgets/HaftalikKart/haftalik_kart.dart';
import 'package:bagimlilik/features/anasayfa/widgets/HedefKart/hedef_kart.dart';
import 'package:bagimlilik/features/anasayfa/widgets/alisveris_durtu_kontrol.dart';
import 'package:bagimlilik/features/anasayfa/widgets/appbar_actions.dart';
import 'package:bagimlilik/features/anasayfa/widgets/BeklemeKart/bekleme_list_baslik.dart';
import 'package:bagimlilik/features/anasayfa/widgets/BeklemeKart/bekleme_list_kart.dart';
import 'package:bagimlilik/features/anasayfa/widgets/GunlukDurumKart/gunluk_durum_kart.dart';
import 'package:flutter/material.dart';

class AnasayfaView extends StatelessWidget {
  const AnasayfaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEDE3),
      appBar: CustomAppBar(
        title: 'Merhaba İrem',
        centerTitle: false,
        actions: [
         AppBarActions()
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16,),
              GunlukDurumKart(),
              const SizedBox(height: 16,),
              KontrolKart(),
              const SizedBox(height: 16,),
              BeklemeListBaslik(),
              const SizedBox(height: 16,),
              BeklemeListKart(),
              const SizedBox(height: 16,),
              HedefKart(),
              const SizedBox(height: 16,),
              HaftalikKart(),
              const SizedBox(height: 16,),
            ],
          ),
        ),
      ),
    );
  }
}
