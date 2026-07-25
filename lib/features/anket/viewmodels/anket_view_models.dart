import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnketViewModel extends Notifier<Map<int, int>> {
  @override
  Map<int, int> build() {
    return {};
  }
  void cevapSec(int soruNo, int cevap) {
    state = {
      ...state,
      soruNo: cevap,
    };
  }
}
final anketViewModelProvider =
NotifierProvider<AnketViewModel, Map<int, int>>(
  AnketViewModel.new,
);