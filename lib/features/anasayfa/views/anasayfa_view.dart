import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/anasayfa/widgets/appbar_actions.dart';
import 'package:bagimlilik/features/anasayfa/widgets/gunluk_durum_kart.dart';
import 'package:flutter/material.dart';

class AnasayfaView extends StatelessWidget {
  const AnasayfaView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
              DailyStatusCard(),
              SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }
}
