import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:bagimlilik/features/odak_kontrolu/viewmodels/odak_kontrolu_view_model.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/kategori_adimi.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/sonuc_adimi.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/tetikleyici_adimi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OdakKontroluView extends ConsumerStatefulWidget {
  const OdakKontroluView({super.key});

  @override
  ConsumerState<OdakKontroluView> createState() => _OdakKontroluViewState();
}

class _OdakKontroluViewState extends ConsumerState<OdakKontroluView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(odakKontroluViewModelProvider.notifier).sifirla();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(odakKontroluViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(
        title: _baslik(state.adim),
        centerTitle: false,
        leading: state.adim == OdakAdimi.kategori
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.read(odakKontroluViewModelProvider.notifier).geriDon();
                },
              ),
      ),
      body: SafeArea(
        child: switch (state.adim) {
          OdakAdimi.kategori => const KategoriAdimi(),
          OdakAdimi.tetikleyici => const TetikleyiciAdimi(),
          OdakAdimi.sonuc => SonucAdimi(state: state),
        },
      ),
    );
  }

  String _baslik(OdakAdimi adim) {
    return switch (adim) {
      OdakAdimi.kategori => 'Ne almak istiyorsun?',
      OdakAdimi.tetikleyici => 'Seni ne tetikledi?',
      OdakAdimi.sonuc => 'Bir Nefes Al',
    };
  }
}
