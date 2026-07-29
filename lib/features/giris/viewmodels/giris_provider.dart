import 'package:bagimlilik/features/giris/viewmodels/giris_state.dart';
import 'package:bagimlilik/features/giris/viewmodels/giris_viewmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final girisViewModelProvider =
NotifierProvider<GirisViewModel, GirisState>(
      GirisViewModel.new,
);