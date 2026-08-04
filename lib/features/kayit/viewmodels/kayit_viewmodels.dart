import 'package:bagimlilik/features/auth/providers/auth_provider.dart';
import 'package:bagimlilik/features/auth/services/auth_service.dart';
import 'package:bagimlilik/features/kayit/models/kayit_models.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KayitViewModel extends Notifier<KayitState> {
  late final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final detailFormKey = GlobalKey<FormState>();

  final adsoyadController = TextEditingController();
  final kullaniciAdiController = TextEditingController();
  final emailController = TextEditingController();
  final sifreController = TextEditingController();
  final sifreTekrarController = TextEditingController();

  DateTime? birthDate;
  String? selectedGender;
  String? selectedMaritalStatus;
  String? selectedEducation;
  String? selectedEmploymentStatus;
  String? selectedIncomeLevel;
  String? selectedPhoneUsage;


  void setBirthDate(DateTime date) {
    state = state.copyWith(
      birthDate: date,
    );
  }

  void setGender(String? gender) {
    state = state.copyWith(
      selectedGender: gender,
    );
  }

  void setMaritalStatus(String? status) {
    state = state.copyWith(
      selectedMaritalStatus: status,
    );
  }

  void setEducation(String? education) {
    state = state.copyWith(
      selectedEducation: education,
    );
  }

  void setEmploymentStatus(String? status) {
    state = state.copyWith(
      selectedEmploymentStatus: status,
    );
  }

  void setIncomeLevel(String? income) {
    state = state.copyWith(
      selectedIncomeLevel: income,
    );
  }

  void setDailyPhoneUsage(String? usage) {
    state = state.copyWith(
      selectedDailyPhoneUsage: usage,
    );
  }
  void setAvatar(String avatarPath) {
    state = state.copyWith(
      selectedAvatar: avatarPath,
    );
  }
  String get email => emailController.text.trim();
  String get password => sifreController.text;
  Future<bool> register() async {
    EasyLoading.show(
      status: "Kayıt oluşturuluyor...",
    );

    try {
      await _authService.signUp(
        email: email,
        password: password,
      );

      EasyLoading.dismiss();

      return true;
    } on AuthException catch (e) {
      EasyLoading.showError(e.message);
      return false;
    } catch (e) {
      EasyLoading.showError(
        "Beklenmeyen bir hata oluştu.",
      );
      return false;
    }
  }

  @override
  KayitState build() {

    _authService = ref.read(authServiceProvider);

    ref.onDispose(() {
      adsoyadController.dispose();
      kullaniciAdiController.dispose();
      emailController.dispose();
      sifreController.dispose();
      sifreTekrarController.dispose();
    });

    return const KayitState();
  }
}