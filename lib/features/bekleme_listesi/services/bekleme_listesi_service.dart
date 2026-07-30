import 'dart:convert';

import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeklemeListesiService {
  static const _anahtar = 'bekleme_listesi';

  Future<List<BeklemeOgesi>> listeyiGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final ham = prefs.getStringList(_anahtar) ?? [];
    return ham
        .map((e) => BeklemeOgesi.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> listeyiKaydet(List<BeklemeOgesi> liste) async {
    final prefs = await SharedPreferences.getInstance();
    final ham = liste.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_anahtar, ham);
  }
}
