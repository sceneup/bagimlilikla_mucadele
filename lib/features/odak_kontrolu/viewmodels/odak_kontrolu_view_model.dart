import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/tetikleyici.dart';
import 'package:bagimlilik/features/odak_kontrolu/services/kategori_service.dart';
import 'package:bagimlilik/features/odak_kontrolu/services/tetikleyici_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OdakKontroluViewModel extends Notifier<OdakKontroluState> {
  final _kategoriService = KategoriService();
  final _tetikleyiciService = TetikleyiciService();

  @override
  OdakKontroluState build() {
    return const OdakKontroluState();
  }

  List<Kategori> get kategoriler => _kategoriService.kategorileriGetir();

  List<Tetikleyici> get tetikleyiciler =>
      _tetikleyiciService.tetikleyicileriGetir();

  void kategoriSec(Kategori kategori) {
    state = OdakKontroluState(
      adim: OdakAdimi.tetikleyici,
      seciliKategori: kategori,
    );
  }

  void tetikleyiciSec(Tetikleyici tetikleyici) {
    state = OdakKontroluState(
      adim: OdakAdimi.sonuc,
      seciliKategori: state.seciliKategori,
      seciliTetikleyici: tetikleyici,
    );
  }

  void geriDon() {
    if (state.adim == OdakAdimi.tetikleyici) {
      state = const OdakKontroluState(adim: OdakAdimi.kategori);
    } else if (state.adim == OdakAdimi.sonuc) {
      state = OdakKontroluState(
        adim: OdakAdimi.tetikleyici,
        seciliKategori: state.seciliKategori,
      );
    }
  }

  void sifirla() {
    state = const OdakKontroluState();
  }
}

final odakKontroluViewModelProvider =
    NotifierProvider<OdakKontroluViewModel, OdakKontroluState>(
      OdakKontroluViewModel.new,
    );
