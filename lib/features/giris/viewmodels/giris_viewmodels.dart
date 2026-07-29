import 'package:bagimlilik/features/giris/viewmodels/giris_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GirisViewModel extends Notifier<GirisState> {
  final formKey = GlobalKey<FormState>();

  final adController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  GirisState build() {
    ref.onDispose(() {
      adController.dispose();
      passwordController.dispose();
    });

    return const GirisState();
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }
}