import 'package:bagimlilik/features/auth/providers/auth_provider.dart';
import 'package:bagimlilik/features/kayit/models/kayit_models.dart';
import 'package:bagimlilik/features/kayit/repositories/kayit_repository.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_viewmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kayitRepositoryProvider = Provider<KayitRepository>((ref) {
  final authService = ref.read(authServiceProvider);

  return KayitRepository(authService);
});

final kayitViewModelProvider =
NotifierProvider<KayitViewModel, KayitState>(
  KayitViewModel.new,
);