import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
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
  Future<void> ogeEkle(
      BeklemeOgesi oge,
      ) async {
    final userId = currentUserId;

    if (userId == null) {
      throw StateError(
        'Bekleme listesine eklemek için kullanıcı giriş yapmış olmalı.',
      );
    }

    final data = oge.toSupabaseMap();

    // Güvenlik açısından user_id'yi
    // aktif kullanıcıdan alıyoruz.
    data['user_id'] = userId;

    await _supabase
        .from('bekleme_listesi')
        .insert(data);
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