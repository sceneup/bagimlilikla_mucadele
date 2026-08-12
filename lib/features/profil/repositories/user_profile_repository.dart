import 'package:bagimlilik/features/profil/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileRepository {
  final SupabaseClient _supabase;

  UserProfileRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  Future<UserProfile?> getCurrentProfile() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserProfile.fromJson(data);
  }

  Future<UserProfile?> getProfileById(String userId) async {
    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserProfile.fromJson(data);
  }
}