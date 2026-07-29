import 'package:bagimlilik/features/kayit/models/kayit_models.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_viewmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kayitViewModelProvider =
NotifierProvider<KayitViewModel, KayitState>(
  KayitViewModel.new,
);