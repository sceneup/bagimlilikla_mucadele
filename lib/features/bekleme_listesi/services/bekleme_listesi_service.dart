import 'dart:convert';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BeklemeListesiService {
  static const _anahtar = 'bekleme_listesi';
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Yerel önbellekten listeyi okur.
  Future<List<BeklemeOgesi>> yerelListeyiGetir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ham = prefs.getStringList(_anahtar) ?? [];
      return ham
          .map((e) => BeklemeOgesi.fromJson(jsonDecode(e)))
          .toList();
    } catch (e) {
      debugPrint("Bekleme listesi yerel okuma hatası: $e");
      return [];
    }
  }

  /// Supabase veritabanından ve/veya yerel depolamadan listeyi getirir.
  Future<List<BeklemeOgesi>> listeyiGetir() async {
    // 1. Yerel önbellekten hızlıca oku
    final yerelListe = await yerelListeyiGetir();

    final userId = currentUserId;
    if (userId == null) {
      return yerelListe;
    }

    // 2. Kullanıcı giriş yapmışsa Supabase'den çek
    try {
      final response = await _supabase
          .from('bekleme_listesi')
          .select()
          .eq('user_id', userId);

      final supabaseListe = (response as List)
          .map((e) => BeklemeOgesi.fromJson(e as Map<String, dynamic>))
          .toList();

      // Yerel önbelleği güncelle
      await listeyiKaydet(supabaseListe);

      return supabaseListe;
    } catch (e) {
      debugPrint("Supabase bekleme listesi çekme hatası (yerel veri kullanılacak): $e");
      return yerelListe;
    }
  }

  /// Yerel önbelleğe listeyi kaydeder.
  Future<void> listeyiKaydet(List<BeklemeOgesi> liste) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ham = liste.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_anahtar, ham);
    } catch (e) {
      debugPrint("Bekleme listesi yerel kaydetme hatası: $e");
    }
  }

  /// Yeni ögeyi hem yerel hem Supabase veritabanına ekler.
  Future<void> ogeEkle(BeklemeOgesi oge) async {
    final userId = currentUserId;
    final ogeWithUser = userId != null && oge.userId == null
        ? BeklemeOgesi(
            id: oge.id,
            userId: userId,
            kategoriId: oge.kategoriId,
            eklenmeTarihi: oge.eklenmeTarihi,
            fiyat: oge.fiyat,
          )
        : oge;

    // Yerel önbelleği güncelle
    final mevcut = await yerelListeyiGetir();
    final guncel = [...mevcut, ogeWithUser];
    await listeyiKaydet(guncel);

    // Supabase'e ekle
    if (userId != null) {
      try {
        await _supabase.from('bekleme_listesi').insert(ogeWithUser.toSupabaseMap());
      } catch (e) {
        debugPrint("Supabase bekleme ögesi ekleme hatası: $e");
      }
    }
  }

  /// Ögeyi hem yerel hem Supabase veritabanından siler.
  Future<void> ogeSil(String id) async {
    // Yerel önbellekten sil
    final mevcut = await yerelListeyiGetir();
    final guncel = mevcut.where((e) => e.id != id).toList();
    await listeyiKaydet(guncel);

    // Supabase'den sil
    final userId = currentUserId;
    if (userId != null) {
      try {
        await _supabase
            .from('bekleme_listesi')
            .delete()
            .eq('id', id)
            .eq('user_id', userId);
      } catch (e) {
        debugPrint("Supabase bekleme ögesi silme hatası: $e");
      }
    }
  }
}

