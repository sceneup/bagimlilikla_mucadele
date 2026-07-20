import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/bilgi/widgets/SimuleReklam/simule_kart.dart';
import 'package:bagimlilik/features/bilgi/widgets/bilgi_sayfasi_baslik.dart';
import 'package:bagimlilik/features/bilgi/widgets/farkindalik_card_alani.dart';
import 'package:bagimlilik/features/bilgi/widgets/oneri_card_alani.dart';
import 'package:bagimlilik/features/bilgi/widgets/tuzak_bilgi_alani.dart';
import 'package:flutter/material.dart';

class BilgiView extends StatelessWidget {
  const BilgiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEDE3),
      appBar: CustomAppBar(title:'Bilgi Kutularım'),
      body: SingleChildScrollView(
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              BilgiSayfasiBaslik(),
              const SizedBox(height: 20,),
              SimuleKart(),
              const SizedBox(height: 20,),
              FarkindalikCardAlani(),
              const SizedBox(height: 20,),
              OneriCardAlani(),
              const SizedBox(height: 20,),
              TuzakBilgiAlani(),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
