import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/tetikleyici.dart';

enum OdakAdimi { kategori, tetikleyici, fiyat, sonuc }

class OdakKontroluState {
  final OdakAdimi adim;
  final Kategori? seciliKategori;
  final Tetikleyici? seciliTetikleyici;
  final double? fiyat;
  final int nefesSayfaIndex;
  final int istekSeviyesi;
  final String? urunAnlami;

  const OdakKontroluState({
    this.adim = OdakAdimi.kategori,
    this.seciliKategori,
    this.seciliTetikleyici,
    this.fiyat,
    this.nefesSayfaIndex = 0,
    this.istekSeviyesi = 3,
    this.urunAnlami,
  });

  OdakKontroluState copyWith({
    OdakAdimi? adim,
    Kategori? seciliKategori,
    Tetikleyici? seciliTetikleyici,
    double? fiyat,
    int? nefesSayfaIndex,
    int? istekSeviyesi,
    String? urunAnlami,
  }) {
    return OdakKontroluState(
      adim: adim ?? this.adim,
      seciliKategori: seciliKategori ?? this.seciliKategori,
      seciliTetikleyici: seciliTetikleyici ?? this.seciliTetikleyici,
      fiyat: fiyat ?? this.fiyat,
      nefesSayfaIndex: nefesSayfaIndex ?? this.nefesSayfaIndex,
      istekSeviyesi: istekSeviyesi ?? this.istekSeviyesi,
      urunAnlami: urunAnlami ?? this.urunAnlami,
    );
  }
}

