import 'package:bagimlilik/features/bekleme_listesi/viewmodels/bekleme_listesi_view_model.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
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
  late final AnimationController _nefesController;
  late final Animation<double> _nefesOlcek;

  String _nefesMetni = 'Nefes Al';
  bool _butonlarAktif = false;

  @override
  void initState() {
    super.initState();

    _nefesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _nefesMetni = 'Nefes Ver');
        } else if (status == AnimationStatus.dismissed) {
          setState(() => _nefesMetni = 'Nefes Al');
        }
      })
      ..repeat(reverse: true);

    _nefesOlcek = Tween<double>(
      begin: 0.88,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _nefesController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(
      const Duration(seconds: 4),
          () {
        if (mounted) {
          setState(() => _butonlarAktif = true);
        }
      },
    );
  }

  @override
  void dispose() {
    _nefesController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: AnimatedBuilder(
                    animation: _nefesOlcek,
                    builder: (context, child) {
                      final oran = _nefesOlcek.value;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 110 * oran,
                            height: 110 * oran,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF0F6E56,
                              ).withValues(alpha: 0.16),
                            ),
                          ),
                          Container(
                            width: 78 * oran,
                            height: 78 * oran,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF0F6E56,
                              ).withValues(alpha: 0.32),
                            ),
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0F6E56),
                            ),
                            child: const Icon(
                              Icons.self_improvement,
                              color: Color(0xFFE1F5EE),
                              size: 28,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _nefesMetni,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F6E56),
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  '${widget.state.seciliKategori?.isim} almak istiyorsun',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF04342C),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${widget.state.seciliTetikleyici?.isim} seni tetikledi.\n'
                      'Şimdi almazsan hayatında ne değişir?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF085041),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ============================================================
          // BEKLEME LİSTESİNE EKLE
          // ============================================================

          AnimatedOpacity(
            opacity: _butonlarAktif ? 1 : 0.35,
            duration: const Duration(milliseconds: 400),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _butonlarAktif
                    ? () {
                  final kategoriId =
                      widget.state.seciliKategori?.id;

                  final tetikleyiciId =
                      widget.state.seciliTetikleyici?.id;

                  if (kategoriId != null) {
                    ref
                        .read(
                      beklemeListesiViewModelProvider
                          .notifier,
                    )
                        .ekle(
                      kategoriId,
                      tetikleyiciId: tetikleyiciId,
                    );
                  }

                  // _durtuKaydiniTut(
                  //   DurtuSonucu.beklemeyeEklendi,
                  // );

                  context.pop();
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F6E56),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  const Color(0xFF0F6E56),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Bekleme Listesine Ekle',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ============================================================
          // VAZGEÇ
          // ============================================================

          AnimatedOpacity(
            opacity: _butonlarAktif ? 1 : 0.35,
            duration: const Duration(milliseconds: 400),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _butonlarAktif
                    ? () {
                  // _durtuKaydiniTut(
                  //   DurtuSonucu.vazgecildi,
                  // );

                  context.pop();
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAF3DE),
                  foregroundColor: const Color(0xFF27500A),
                  disabledBackgroundColor:
                  const Color(0xFFEAF3DE),
                  disabledForegroundColor:
                  const Color(0xFF27500A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Vazgeçtim, ihtiyacım yokmuş',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          if (!_butonlarAktif) ...[
            const SizedBox(height: 12),

            Text(
              'Bir nefes al, birazdan devam edebilirsin...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withValues(alpha: 0.45),
              ),
            ),
          ],
        ],
      ),
    );
  }
}