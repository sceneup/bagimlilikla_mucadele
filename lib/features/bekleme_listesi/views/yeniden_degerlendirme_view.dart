import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_degerlendirme.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/viewmodels/bekleme_listesi_view_model.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/degerlendir_adimi.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/dusun_adimi.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/istek_degisimi_adimi.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/karar_adimi.dart';
import 'package:bagimlilik/features/bekleme_listesi/widgets/ozet_adimi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class YenidenDegerlendirmeView extends ConsumerStatefulWidget {
  final BeklemeOgesi? oge;

  const YenidenDegerlendirmeView({
    this.oge,
    super.key,
  });

  @override
  ConsumerState<YenidenDegerlendirmeView> createState() =>
      _YenidenDegerlendirmeViewState();
}

class _YenidenDegerlendirmeViewState
    extends ConsumerState<YenidenDegerlendirmeView> {
  late final PageController _pageController;
  final TextEditingController _dusunceController = TextEditingController();

  int _mevcutSayfa = 0;
  int? _seciliIstekPuani;
  String? _seciliIhtiyac;
  String? _seciliKarar;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dusunceController.dispose();
    super.dispose();
  }

  void _sonrakiSayfa() {
    if (_mevcutSayfa < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onukaydetVeTamamla() async {
    String? ogeId = widget.oge?.id;

    if (ogeId == null) {
      final liste = ref.read(beklemeListesiViewModelProvider).value;
      if (liste != null && liste.isNotEmpty) {
        final readyOge = liste.firstWhere(
          (o) => o.suresiDoldu || o.status == 'ready_for_evaluation',
          orElse: () => liste.first,
        );
        ogeId = readyOge.id;
      }
    }

    if (ogeId != null && _seciliKarar != null) {
      final userId = widget.oge?.userId;

      final degerlendirme = BeklemeDegerlendirme(
        waitlistId: ogeId,
        userId: userId ?? '',
        evaluationType: '24h',
        urgeScore: _seciliIstekPuani ?? 5,
        purchaseReason: _seciliIhtiyac,
        thought: _dusunceController.text.trim().isNotEmpty
            ? _dusunceController.text.trim()
            : null,
      );

      await ref
          .read(beklemeListesiViewModelProvider.notifier)
          .degerlendirmeKaydet(degerlendirme);

      await ref
          .read(beklemeListesiViewModelProvider.notifier)
          .kararVer(ogeId, _seciliKarar!);
    }

    if (mounted) {
      String mesaj;
      if (_seciliKarar == 'abandoned') {
        mesaj = 'Tebrikler! Bilinçli bir karar verdin ve vazgeçtin. 🍃';
      } else if (_seciliKarar == 'wait_more') {
        mesaj = 'Bekleme süren uzatıldı. ⏳';
      } else {
        mesaj = 'Kararın kaydedildi. 🛍️';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mesaj),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: const CustomAppBar(
        title: 'Yeniden Değerlendirme',
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _mevcutSayfa = index);
                },
                children: [
                  OzetAdimi(
                    oge: widget.oge,
                  ),
                  IstekDegisimiAdimi(
                    seciliPuan: _seciliIstekPuani,
                    onPuanSecildi: (puan) {
                      setState(() => _seciliIstekPuani = puan);
                    },
                  ),
                  DusunAdimi(
                    controller: _dusunceController,
                  ),
                  DegerlendirAdimi(
                    seciliIhtiyac: _seciliIhtiyac,
                    onIhtiyacSecildi: (secim) {
                      setState(() => _seciliIhtiyac = secim);
                    },
                  ),
                  KararAdimi(
                    seciliKarar: _seciliKarar,
                    onKararSecildi: (secim) {
                      setState(() => _seciliKarar = secim);
                    },
                  ),
                ],
              ),
            ),

            // Alt Sabit Gösterge ve Buton Alanı
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 5 Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final aktif = index == _mevcutSayfa;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: aktif ? 14 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: aktif
                              ? AppColors.primary
                              : AppColors.border.withValues(alpha: .5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Action Button
                  if (_mevcutSayfa == 0)
                    CustomButton(
                      text: 'Devam Et →',
                      backgroundColor: AppColors.primary,
                      onPressed: _sonrakiSayfa,
                    )
                  else if (_mevcutSayfa == 1)
                    CustomButton(
                      text: 'Devam Et →',
                      backgroundColor: AppColors.primary,
                      enabled: _seciliIstekPuani != null,
                      onPressed: _sonrakiSayfa,
                    )
                  else if (_mevcutSayfa == 2)
                    CustomButton(
                      text: 'Devam Et →',
                      backgroundColor: AppColors.primary,
                      onPressed: _sonrakiSayfa,
                    )
                  else if (_mevcutSayfa == 3)
                    CustomButton(
                      text: 'Devam Et →',
                      backgroundColor: AppColors.primary,
                      enabled: _seciliIhtiyac != null,
                      onPressed: _sonrakiSayfa,
                    )
                  else
                    CustomButton(
                      text: 'Kararı Tamamla →',
                      backgroundColor: AppColors.primary,
                      enabled: _seciliKarar != null,
                      onPressed: _onukaydetVeTamamla,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
