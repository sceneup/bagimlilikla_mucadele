import 'dart:convert';

import 'package:bagimlilik/features/rozetler/models/rozet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RozetService {
  static const _anahtar = 'rozetler';

  Future<List<Rozet>> listeyiGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final ham = prefs.getStringList(_anahtar) ?? [];
    return ham.map((e) => Rozet.fromJson(jsonDecode(e))).toList();
  }

  Future<void> listeyiKaydet(List<Rozet> liste) async {
    final prefs = await SharedPreferences.getInstance();
    final ham = liste.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_anahtar, ham);
  }

  Future<void> rozetEkle(String id, String kategoriId) async {
    final mevcut = await listeyiGetir();
    final yeniRozet = Rozet(
      id: id,
      kategoriId: kategoriId,
      kazanmaTarihi: DateTime.now(),
    );
    await listeyiKaydet([...mevcut, yeniRozet]);
  }
}
