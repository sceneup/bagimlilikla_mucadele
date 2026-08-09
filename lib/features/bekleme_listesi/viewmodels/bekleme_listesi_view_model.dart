import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/services/bekleme_listesi_service.dart';
import 'package:bagimlilik/features/bekleme_listesi/services/bildirim_service.dart';
import 'package:bagimlilik/features/odak_kontrolu/services/kategori_service.dart';
import 'package:bagimlilik/features/rozetler/services/rozet_service.dart';
import 'package:bagimlilik/features/rozetler/viewmodels/rozet_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

int _bildirimIdUret(String ogeId) => ogeId.hashCode & 0x7FFFFFFF;

class BeklemeListesiViewModel extends AsyncNotifier<List<BeklemeOgesi>> {
  final _service = BeklemeListesiService();
  final _rozetService = RozetService();
  final _bildirimService = BildirimService();
  final _kategoriService = KategoriService();

  @override
  Future<List<BeklemeOgesi>> build() async {
    final liste = await _service.listeyiGetir();
    final aktifler = <BeklemeOgesi>[];
    var rozetKazanildi = false;

    for (final oge in liste) {
      if (oge.suresiDoldu) {
        await _rozetService.rozetEkle('rozet_${oge.id}', oge.kategoriId);
        await _service.ogeSil(oge.id);
        rozetKazanildi = true;
      } else {
        aktifler.add(oge);
      }
    }

    if (rozetKazanildi) {
      ref.invalidate(rozetViewModelProvider);
    }

    return aktifler;
  }

  Future<void> ekle(String kategoriId) async {
    final mevcut = await future;
    final userId = _service.currentUserId;
    final yeniOge = BeklemeOgesi(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      kategoriId: kategoriId,
      eklenmeTarihi: DateTime.now(),
    );
    final guncelListe = [...mevcut, yeniOge];

    state = AsyncData(guncelListe);
    await _service.ogeEkle(yeniOge);

    final kategori = _kategoriService
        .kategorileriGetir()
        .firstWhere((k) => k.id == kategoriId);

    await _bildirimService.hatirlaticiKur(
      id: _bildirimIdUret(yeniOge.id),
      kategoriIsim: kategori.isim,
      tetikTarihi: yeniOge.eklenmeTarihi.add(
        const Duration(hours: BeklemeOgesi.bekleSuresiSaat),
      ),
    );
  }

  Future<void> kaldir(String id) async {
    final mevcut = await future;
    final guncelListe = mevcut.where((oge) => oge.id != id).toList();

    state = AsyncData(guncelListe);
    await _service.ogeSil(id);
    await _bildirimService.hatirlaticiIptalEt(_bildirimIdUret(id));
  }
}

final beklemeListesiViewModelProvider =
    AsyncNotifierProvider<BeklemeListesiViewModel, List<BeklemeOgesi>>(
      BeklemeListesiViewModel.new,
    );

