import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_degerlendirme.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BeklemeListesiRepository {
  BeklemeListesiRepository({
    SupabaseClient? supabase,
  }) : _supabase =
      supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  String? get currentUserId {
    return _supabase.auth.currentUser?.id;
  }

  /// Kullanıcının bekleme listesini getirir.
  Future<List<BeklemeOgesi>> listeyiGetir() async {
    final userId = currentUserId;

    if (userId == null) {
      return [];
    }

    final response = await _supabase
        .from('bekleme_listesi')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (item) => BeklemeOgesi.fromSupabase(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  /// Yeni bekleme öğesi ekler.
  /// Yeni bekleme öğesi ekler ve veritabanından dönen gerçek öğeyi verir.
  Future<BeklemeOgesi> ogeEkle(
    BeklemeOgesi oge,
  ) async {
    final userId = currentUserId;

    if (userId == null) {
      throw StateError(
        'Bekleme listesine eklemek için kullanıcı giriş yapmış olmalı.',
      );
    }

    final data = oge.toSupabaseMap();
    data['user_id'] = userId;

    final response = await _supabase
        .from('bekleme_listesi')
        .insert(data)
        .select()
        .single();

    return BeklemeOgesi.fromSupabase(response);
  }

  /// Birden fazla öğenin durumunu tek sorguda günceller.
  Future<void> durumlariGuncelle(
    List<String> ids,
    String status,
  ) async {
    final userId = currentUserId;

    if (userId == null || ids.isEmpty) {
      return;
    }

    await _supabase
        .from('bekleme_listesi')
        .update({'status': status})
        .eq('user_id', userId)
        .inFilter('id', ids);
  }

  /// Öğenin durumunu ve kullanıcının nihai kararını günceller.
  Future<void> kararGuncelle({
    required String id,
    required String status,
    String? decision,
    DateTime? yeniEklenmeTarihi,
  }) async {
    final userId = currentUserId;

    if (userId == null) {
      return;
    }

    final updateData = <String, dynamic>{
      'status': status,
      'decision': decision,
    };

    if (yeniEklenmeTarihi != null) {
      updateData['created_at'] = yeniEklenmeTarihi.toUtc().toIso8601String();
    }

    try {
      final response = await _supabase
          .from('bekleme_listesi')
          .update(updateData)
          .eq('id', id)
          .eq('user_id', userId)
          .select();

      if ((response as List).isEmpty) {
        final numId = int.tryParse(id);
        if (numId != null) {
          await _supabase
              .from('bekleme_listesi')
              .update(updateData)
              .eq('id', numId)
              .eq('user_id', userId)
              .select();
        }
      }
    } catch (_) {
      final numId = int.tryParse(id);
      if (numId != null) {
        try {
          await _supabase
              .from('bekleme_listesi')
              .update(updateData)
              .eq('id', numId)
              .eq('user_id', userId)
              .select();
        } catch (_) {}
      }
    }
  }

  /// Bekleme değerlendirme kaydı ekler (bekleme_degerlendirmeleri tablosu).
  Future<void> degerlendirmeEkle(BeklemeDegerlendirme degerlendirme) async {
    final userId = currentUserId;
    if (userId == null) return;

    final data = degerlendirme.toSupabaseMap();
    data['user_id'] = userId;

    try {
      await _supabase.from('bekleme_degerlendirmeleri').upsert(
            data,
            onConflict: 'waitlist_id, evaluation_type',
          );
    } catch (e) {
      debugPrint('❌ Degerlendirme ekleme hatası: $e');
    }
  }

  /// Bekleme listesinden tek öğe siler.
  Future<void> ogeSil(
    String id,
  ) async {
    final userId = currentUserId;

    if (userId == null) {
      return;
    }

    await _supabase
        .from('bekleme_listesi')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  /// Birden fazla öğeyi tek sorguda siler.
  Future<void> ogeleriSil(
    List<String> ids,
  ) async {
    final userId = currentUserId;

    if (userId == null || ids.isEmpty) {
      return;
    }

    await _supabase
        .from('bekleme_listesi')
        .delete()
        .eq('user_id', userId)
        .inFilter('id', ids);
  }
}