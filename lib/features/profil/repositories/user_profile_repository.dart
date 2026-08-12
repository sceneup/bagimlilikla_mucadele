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

  Future<UserProfile?> updateProfile({
    String? fullName,
    String? username,
    String? avatar,
    DateTime? birthDate,
    String? gender,
    String? maritalStatus,
    String? livingStatus,
    String? educationLevel,
    String? employmentStatus,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Kullanıcı oturumu bulunamadı.');
    }

    final updates = <String, dynamic>{};

    if (fullName != null) {
      updates['full_name'] = fullName;
    }

    if (username != null) {
      updates['username'] = username;
    }

    if (avatar != null) {
      updates['avatar'] = avatar;
    }

    if (birthDate != null) {
      updates['birth_date'] =
          birthDate.toIso8601String().split('T').first;
    }

    if (gender != null) {
      updates['gender'] = gender;
    }

    if (maritalStatus != null) {
      updates['marital_status'] = maritalStatus;
    }

    if (livingStatus != null) {
      updates['living_status'] = livingStatus;
    }

    if (educationLevel != null) {
      updates['education_level'] = educationLevel;
    }

    if (employmentStatus != null) {
      updates['employment_status'] = employmentStatus;
    }

    // Güncellenecek alan yoksa tekrar istek atma.
    if (updates.isEmpty) {
      return getCurrentProfile();
    }

    final data = await _supabase
        .from('profiles')
        .update(updates)
        .eq('id', user.id)
        .select()
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserProfile.fromJson(data);
  }
}