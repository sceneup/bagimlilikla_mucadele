import 'package:flutter/foundation.dart';

@immutable
class GirisState {
  final bool isLoading;
  final String? errorMessage;

  const GirisState({
    this.isLoading = false,
    this.errorMessage,
  });

  GirisState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return GirisState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}