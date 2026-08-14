import 'package:bagimlilik/features/bekleme_listesi/viewmodels/bekleme_listesi_view_model.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:bagimlilik/features/odak_kontrolu/viewmodels/odak_kontrolu_view_model.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/istek_seviyesi_sayfasi.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/karar_sayfasi.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/nefes_sayfasi.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/tetikleyici_farkindalik_sayfasi.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/urun_anlami_sayfasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SonucAdimi extends ConsumerStatefulWidget {
  final OdakKontroluState state;

  const SonucAdimi({
    required this.state,
    super.key,
  });

  @override
  ConsumerState<SonucAdimi> createState() => _SonucAdimiState();
}

class _SonucAdimiState extends ConsumerState<SonucAdimi>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _nefesController;
  late final Animation<double> _nefesOlcek;

  String _nefesMetni = 'Nefes al...';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.state.nefesSayfaIndex,
    );

    _nefesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) setState(() => _nefesMetni = 'Nefes ver...');
        } else if (status == AnimationStatus.dismissed) {
          if (mounted) setState(() => _nefesMetni = 'Nefes al...');
        }
      })
      ..repeat(reverse: true);

    _nefesOlcek = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _nefesController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant SonucAdimi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pageController.hasClients &&
        _pageController.page?.round() != widget.state.nefesSayfaIndex) {
      _pageController.animateToPage(
        widget.state.nefesSayfaIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nefesController.dispose();
    super.dispose();
  }

  void _sonrakiSayfa() {
    ref
        .read(odakKontroluViewModelProvider.notifier)
        .sonrakiNefesSayfasinaGec();
  }

  void _beklemeyeEkle() {
    final kategoriId = widget.state.seciliKategori?.id;
    final tetikleyiciId = widget.state.seciliTetikleyici?.id;

    if (kategoriId != null) {
      ref.read(beklemeListesiViewModelProvider.notifier).ekle(
            kategoriId,
            tetikleyiciId: tetikleyiciId,
            fiyat: widget.state.fiyat,
            initialUrgeScore: widget.state.istekSeviyesi,
            initialPurchaseReason: widget.state.urunAnlami,
          );
    }
    context.pop();
  }

  void _vazgec() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(odakKontroluViewModelProvider);

    return Column(
      children: [
        const SizedBox(height: 12),

        // ============================================================
        // ÜST SAYFA İNDİKATÖRÜ (5 NOKTA)
        // ============================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final isActive = index == state.nefesSayfaIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFF0F6E56)
                    : const Color(0xFFD0E3DB),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // ============================================================
        // KAYDIRMALI SAYFALAR (PAGEVIEW)
        // ============================================================
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              ref
                  .read(odakKontroluViewModelProvider.notifier)
                  .nefesSayfaIndexDegistir(index);
            },
            children: [
              NefesSayfasi(
                state: state,
                nefesOlcek: _nefesOlcek,
                nefesMetni: _nefesMetni,
                onDevamEt: _sonrakiSayfa,
              ),
              IstekSeviyesiSayfasi(
                state: state,
                onDevamEt: _sonrakiSayfa,
              ),
              UrunAnlamiSayfasi(
                state: state,
                onDevamEt: _sonrakiSayfa,
              ),
              TetikleyiciFarkindalikSayfasi(
                state: state,
                onDevamEt: _sonrakiSayfa,
              ),
              KararSayfasi(
                state: state,
                onBeklemeyeEkle: _beklemeyeEkle,
                onVazgec: _vazgec,
              ),
            ],
          ),
        ),
      ],
    );
  }
}