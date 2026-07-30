import 'package:bagimlilik/features/rozetler/models/rozet.dart';
import 'package:bagimlilik/features/rozetler/services/rozet_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RozetViewModel extends AsyncNotifier<List<Rozet>> {
  final _service = RozetService();

  @override
  Future<List<Rozet>> build() {
    return _service.listeyiGetir();
  }
}

final rozetViewModelProvider = AsyncNotifierProvider<RozetViewModel, List<Rozet>>(
  RozetViewModel.new,
);
