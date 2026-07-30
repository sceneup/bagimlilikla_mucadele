import 'package:bagimlilik/features/kayit/models/kayit_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class KayitViewModel extends Notifier<KayitState> {

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

  @override
  KayitState build() {

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