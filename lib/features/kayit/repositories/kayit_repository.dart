import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bagimlilik/features/auth/services/auth_service.dart';

class KayitRepository {
  final AuthService _authService;
  final SupabaseClient _supabase = Supabase.instance.client;

  KayitRepository(this._authService);

  Future<void> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required DateTime birthDate,
    required String gender,
    required String maritalStatus,
    required String livingStatus,
    required String educationLevel,
    required String employmentStatus,
    required String avatar,
  }) async {
    // 1. Authentication kaydı
    final response = await _authService.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception("Kullanıcı oluşturulamadı.");
    }
    final consentDate = DateTime.now();
    // 2. Profil kaydı
    await _supabase.from('profiles').insert({
      'id': user.id,
      'full_name': fullname,
      'username': username,
      'avatar': avatar,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'marital_status': maritalStatus,
      'living_status': livingStatus,
      'education_level': educationLevel,
      'employment_status': employmentStatus,
      'email' : email,
      'kvkk_version': '1.0',
      'kvkk_accepted_at': consentDate.toIso8601String(),

      'consent_version': '1.0',
      'consent_accepted_at': consentDate.toIso8601String(),
    });
  }
}