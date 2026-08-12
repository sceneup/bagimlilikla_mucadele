import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/anasayfa/widgets/BeklemeOzet/bekleme_list_baslik.dart';
import 'package:bagimlilik/features/anasayfa/widgets/BeklemeOzet/bekleme_listesi_bolumu.dart';
import 'package:bagimlilik/features/anasayfa/widgets/HaftalikKart/haftalik_kart.dart';
import 'package:bagimlilik/features/anasayfa/widgets/HedefKart/hedef_kart.dart';
import 'package:bagimlilik/features/anasayfa/widgets/alisveris_durtu_kontrol.dart';
import 'package:bagimlilik/features/anasayfa/widgets/appbar_actions.dart';
import 'package:bagimlilik/features/anasayfa/widgets/GunlukDurumKart/gunluk_durum_kart.dart';
import 'package:flutter/material.dart';
import 'package:bagimlilik/features/profil/providers/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnasayfaView extends ConsumerWidget{
  const AnasayfaView({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(
        title: profileAsync.when(
          data: (profile) {
            final name = profile?.fullName ?? 'Kullanıcı';

            return 'Merhaba ${name.split(' ').first}';
          },
          loading: () => 'Merhaba',
          error: (_, __) => 'Merhaba',
        ),
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
              HedefKart(),
              const SizedBox(height: 16,),
              KontrolKart(),
              const SizedBox(height: 16,),
              BeklemeListBaslik(),
              const SizedBox(height: 16,),
              BeklemeListesiBolumu(),
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
