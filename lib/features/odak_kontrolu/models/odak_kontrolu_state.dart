import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/tetikleyici.dart';

enum OdakAdimi { kategori, tetikleyici, sonuc }

class OdakKontroluState {
  final OdakAdimi adim;
  final Kategori? seciliKategori;
  final Tetikleyici? seciliTetikleyici;

  const OdakKontroluState({
    this.adim = OdakAdimi.kategori,
    this.seciliKategori,
    this.seciliTetikleyici,
  });
}
