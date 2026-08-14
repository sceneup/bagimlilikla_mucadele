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
      adim: OdakAdimi.fiyat,
      seciliKategori: state.seciliKategori,
      seciliTetikleyici: tetikleyici,
    );
  }

  void fiyatBelirle(double? fiyat) {
    state = OdakKontroluState(
      adim: OdakAdimi.sonuc,
      seciliKategori: state.seciliKategori,
      seciliTetikleyici: state.seciliTetikleyici,
      fiyat: fiyat,
      nefesSayfaIndex: 0,
    );
  }

  void fiyatMetniIleKaydet(String text) {
    final cleanText = text.trim().replaceAll(',', '.');
    if (cleanText.isEmpty) {
      fiyatBelirle(null);
      return;
    }
    final double? parsedPrice = double.tryParse(cleanText);
    fiyatBelirle(parsedPrice);
  }

  void nefesSayfaIndexDegistir(int index) {
    if (index >= 0 && index <= 4) {
      state = state.copyWith(nefesSayfaIndex: index);
    }
  }

  void sonrakiNefesSayfasinaGec() {
    if (state.nefesSayfaIndex < 4) {
      state = state.copyWith(nefesSayfaIndex: state.nefesSayfaIndex + 1);
    }
  }

  void istekSeviyesiGuncelle(int seviye) {
    state = state.copyWith(istekSeviyesi: seviye);
  }

  void urunAnlamiSec(String anlam) {
    state = state.copyWith(urunAnlami: anlam);
  }

  void geriDon() {
    if (state.adim == OdakAdimi.tetikleyici) {
      state = const OdakKontroluState(adim: OdakAdimi.kategori);
    } else if (state.adim == OdakAdimi.fiyat) {
      state = OdakKontroluState(
        adim: OdakAdimi.tetikleyici,
        seciliKategori: state.seciliKategori,
      );
    } else if (state.adim == OdakAdimi.sonuc) {
      if (state.nefesSayfaIndex > 0) {
        state = state.copyWith(nefesSayfaIndex: state.nefesSayfaIndex - 1);
      } else {
        state = OdakKontroluState(
          adim: OdakAdimi.fiyat,
          seciliKategori: state.seciliKategori,
          seciliTetikleyici: state.seciliTetikleyici,
          fiyat: state.fiyat,
        );
      }
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
