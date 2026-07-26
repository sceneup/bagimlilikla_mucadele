import 'package:bagimlilik/features/anket/models/anket_state.dart';
import 'package:bagimlilik/features/anket/services/anket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnketViewModel extends AsyncNotifier<AnketState> {
  final _service = AnketService();

  @override
  Future<AnketState> build() async {
    final bolumler = await _service.anketiYukle();

    return AnketState(
      bolumler: bolumler,
      cevaplar: {},
      aktifBolumIndex: 0,
    );
  }
  void cevapSec(int soruNo, int cevap) {
    final mevcutState = state.value;

    if (mevcutState == null) {
      return;
    }

    state = AsyncData(
      mevcutState.copyWith(
        cevaplar: {
          ...mevcutState.cevaplar,
          soruNo: cevap,
        },
      ),
    );
  }
  void sonrakiBolumeGec() {
    final mevcutState = state.value;

    if (mevcutState == null) {
      return;
    }

    final sonBolumIndex = mevcutState.bolumler.length - 1;

    if (mevcutState.aktifBolumIndex < sonBolumIndex) {
      state = AsyncData(
        mevcutState.copyWith(
          aktifBolumIndex: mevcutState.aktifBolumIndex + 1,
        ),
      );
    }
  }
  bool aktifBolumTamamlandiMi() {
    final mevcutState = state.value;

    if (mevcutState == null || mevcutState.bolumler.isEmpty) {
      return false;
    }

    final aktifBolum =
    mevcutState.bolumler[mevcutState.aktifBolumIndex];

    return aktifBolum.sorular.every(
          (soru) => mevcutState.cevaplar.containsKey(soru.id),
    );
  }
}

final anketViewModelProvider =
AsyncNotifierProvider<AnketViewModel, AnketState>(
  AnketViewModel.new,
);