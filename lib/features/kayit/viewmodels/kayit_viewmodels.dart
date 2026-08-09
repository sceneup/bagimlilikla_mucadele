import 'package:bagimlilik/features/kayit/models/kayit_models.dart';
import 'package:bagimlilik/features/kayit/repositories/kayit_repository.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KayitViewModel extends Notifier<KayitState> {
  late final KayitRepository _kayitRepository;

  final formKey = GlobalKey<FormState>();
  final detailFormKey = GlobalKey<FormState>();

  final adsoyadController = TextEditingController();
  final kullaniciAdiController = TextEditingController();
  final emailController = TextEditingController();
  final sifreController = TextEditingController();
  final sifreTekrarController = TextEditingController();

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

  void setEmploymentStatus(String? employment) {
    state = state.copyWith(
      selectedEmploymentStatus: employment,
    );
  }

  void setLivingStatus(String? status) {
    state = state.copyWith(
      selectedLivingStatus: status,
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
      await _kayitRepository.register(
        fullname: adsoyadController.text.trim(),
        username: kullaniciAdiController.text.trim(),
        email: emailController.text.trim(),
        password: sifreController.text,
        birthDate: state.birthDate!,
        gender: state.selectedGender!,
        maritalStatus: state.selectedMaritalStatus!,
        livingStatus: state.selectedLivingStatus!,
        educationLevel: state.selectedEducation!,
        employmentStatus: state.selectedEmploymentStatus!,
        avatar: state.selectedAvatar,
      );

      EasyLoading.dismiss();

      return true;
    } on AuthException catch (e) {
      String message;

      if (e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('already exists')) {
        message = 'Bu e-posta adresi zaten kayıtlı.';
      } else {
        message = 'Kayıt sırasında bir hata oluştu.';
      }

      EasyLoading.showError(message);
      return false;
    }
  }

  @override
  KayitState build() {
    _kayitRepository = ref.read(kayitRepositoryProvider);

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