import 'package:bagimlilik/features/durtu_kaydi/models/durtu_kaydi.dart';
import 'package:bagimlilik/features/durtu_kaydi/services/durtu_kaydi_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DurtuKaydiViewModel extends AsyncNotifier<List<DurtuKaydi>> {
  final _service = DurtuKaydiService();

  @override
  Future<List<DurtuKaydi>> build() {
    return _service.kayitlariGetir();
  }

  Future<void> kaydet({
    required String kategoriId,
    required String tetikleyiciId,
    required DurtuSonucu sonuc,
  }) async {
    final mevcut = await future;
    final yeniKayit = DurtuKaydi(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      kategoriId: kategoriId,
      tetikleyiciId: tetikleyiciId,
      zaman: DateTime.now(),
      sonuc: sonuc,
    );
    final guncelListe = [...mevcut, yeniKayit];

    state = AsyncData(guncelListe);
    await _service.kayitlariKaydet(guncelListe);
  }
}

final durtuKaydiViewModelProvider =
    AsyncNotifierProvider<DurtuKaydiViewModel, List<DurtuKaydi>>(
      DurtuKaydiViewModel.new,
    );
