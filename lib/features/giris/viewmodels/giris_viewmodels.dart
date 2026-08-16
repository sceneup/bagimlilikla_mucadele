import 'package:bagimlilik/features/auth/providers/auth_provider.dart';
import 'package:bagimlilik/features/auth/services/auth_service.dart';
import 'package:bagimlilik/features/giris/viewmodels/giris_state.dart';
import 'package:bagimlilik/features/notification/repositories/daily_behavior_stats_repository.dart';
import 'package:bagimlilik/features/notification/providers/notification_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bagimlilik/features/anket/repositories/survey_repository.dart';

class GirisViewModel extends Notifier<GirisState> {
  late final AuthService _authService;

  final SurveyRepository _surveyRepository =
  SurveyRepository();

  final DailyBehaviorStatsRepository _notificationRepository =
  DailyBehaviorStatsRepository();

  final formKey = GlobalKey<FormState>();

  final usernameController =
  TextEditingController();

  final passwordController =
  TextEditingController();

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

  Future<String?> login() async {
    setLoading(true);

    EasyLoading.show(
      status: "Giriş yapılıyor...",
    );

    try {
      final username =
      usernameController.text.trim();

      final password =
          passwordController.text;

      // ==================================================
      // KULLANICI ADINDAN EMAIL BUL
      // ==================================================

      final email =
      await Supabase.instance.client.rpc(
        'get_email_by_username',
        params: {
          'input_username': username,
        },
      );

      if (email == null) {
        EasyLoading.showError(
          "Kullanıcı adı veya şifre hatalı.",
        );

        return null;
      }

      // ==================================================
      // SUPABASE AUTH
      // ==================================================

      final response =
      await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        EasyLoading.showError(
          "Kullanıcı adı veya şifre hatalı.",
        );

        return null;
      }

      // ==================================================
      // ANKET KONTROLÜ
      // ==================================================

      final anketGerekli =
      await _surveyRepository.isSurveyDue();

      if (anketGerekli) {
        EasyLoading.dismiss();

        return '/anket';
      }

      // ==================================================
      // BİLDİRİM KONTROLÜ
      // ==================================================

      final notificationService =
      ref.read(notificationServiceProvider);

      // Android'deki GERÇEK bildirim erişimi
      final bildirimIzniVar =
      await notificationService.isPermissionGranted();

      // Kullanıcı daha önce ekranı tamamladı mı?
      final bildirimTamamlandi =
      await _notificationRepository
          .isNotificationAccessConfirmed();

      EasyLoading.dismiss();

      // Gerçek Android izni yoksa VEYA
      // kullanıcı daha önce tamamlamadıysa
      // bildirim erişim ekranına gönder.
      if (!bildirimIzniVar || !bildirimTamamlandi) {
        return '/erisim-bildirim';
      }

      return '/anasayfa';

    } on AuthException catch (e) {
      debugPrint(
        "AUTH ERROR: ${e.message}",
      );

      EasyLoading.showError(
        "Kullanıcı adı veya şifre hatalı.",
      );

      return null;

    } catch (e) {
      debugPrint(
        "LOGIN ERROR: $e",
      );

      EasyLoading.showError(
        "Giriş yapılırken bir hata oluştu.",
      );

      return null;

    } finally {
      setLoading(false);
    }
  }

  @override
  GirisState build() {
    _authService =
        ref.read(authServiceProvider);

    ref.onDispose(() {
      usernameController.dispose();
      passwordController.dispose();
    });

    return const GirisState();
  }
}