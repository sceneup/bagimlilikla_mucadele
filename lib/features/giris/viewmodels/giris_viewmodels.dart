import 'package:bagimlilik/features/auth/providers/auth_provider.dart';
import 'package:bagimlilik/features/auth/services/auth_service.dart';
import 'package:bagimlilik/features/giris/viewmodels/giris_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GirisViewModel extends Notifier<GirisState> {
  late final AuthService _authService;

  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void setLoading(bool value) {
    state = state.copyWith(
      isLoading: value,
    );
  }

  void setError(String? message) {
    state = state.copyWith(
      errorMessage: message,
    );
  }

  Future<bool> login() async {
    setLoading(true);

    EasyLoading.show(
      status: "Giriş yapılıyor...",
    );

    try {
      final username = usernameController.text.trim();
      final password = passwordController.text;

      // 1. Kullanıcı adına göre profili bul
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('email')
          .eq('username', username)
          .maybeSingle();

      if (profile == null) {
        EasyLoading.showError(
          "Kullanıcı adı veya şifre hatalı.",
        );

        return false;
      }

      final email = profile['email'] as String;

      // 2. Supabase Auth ile giriş yap
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        EasyLoading.showError(
          "Kullanıcı adı veya şifre hatalı.",
        );

        return false;
      }

      EasyLoading.dismiss();

      return true;
    } on AuthException {
      EasyLoading.showError(
        "Kullanıcı adı veya şifre hatalı.",
      );

      return false;
    } catch (e) {
      EasyLoading.showError(
        "Giriş yapılırken bir hata oluştu.",
      );

      return false;
    } finally {
      setLoading(false);
    }
  }

  @override
  GirisState build() {
    _authService = ref.read(authServiceProvider);

    ref.onDispose(() {
      usernameController.dispose();
      passwordController.dispose();
    });

    return const GirisState();
  }
}