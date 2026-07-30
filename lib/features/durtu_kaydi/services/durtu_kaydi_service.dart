import 'dart:convert';

import 'package:bagimlilik/features/durtu_kaydi/models/durtu_kaydi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DurtuKaydiService {
  static const _anahtar = 'durtu_kayitlari';

  Future<List<DurtuKaydi>> kayitlariGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final ham = prefs.getStringList(_anahtar) ?? [];
    return ham.map((e) => DurtuKaydi.fromJson(jsonDecode(e))).toList();
  }

  Future<void> kayitlariKaydet(List<DurtuKaydi> liste) async {
    final prefs = await SharedPreferences.getInstance();
    final ham = liste.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_anahtar, ham);
  }

  Future<void> kayitEkle(DurtuKaydi kayit) async {
    final mevcut = await kayitlariGetir();
    await kayitlariKaydet([...mevcut, kayit]);
  }
}
