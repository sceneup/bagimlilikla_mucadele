import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/repositories/bekleme_listesi_repository.dart';
import 'package:bagimlilik/features/bekleme_listesi/services/bildirim_service.dart';
import 'package:bagimlilik/features/odak_kontrolu/services/kategori_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

int _bildirimIdUret(String ogeId) {
  return int.tryParse(ogeId) ??
      (ogeId.hashCode & 0x7FFFFFFF);
}

class BeklemeListesiViewModel
    extends AsyncNotifier<List<BeklemeOgesi>> {
  final _repository = BeklemeListesiRepository();
  final _bildirimService = BildirimService();
  final _kategoriService = KategoriService();

  @override
  Future<List<BeklemeOgesi>> build() async {
    final liste = await _repository.listeyiGetir();

    final aktifler = <BeklemeOgesi>[];
    final silinecekIdler = <String>[];

    for (final oge in liste) {
      if (oge.suresiDoldu) {
        silinecekIdler.add(oge.id);
      } else {
        aktifler.add(oge);
      }
    }

    // Süresi dolmuş kayıtları tek seferde sil.
    if (silinecekIdler.isNotEmpty) {
      await _repository.ogeleriSil(
        silinecekIdler,
      );
    }

    return aktifler;
  }

  Future<void> ekle(
      String kategoriId, {
        String? tetikleyiciId,
        double? fiyat,
      }) async {
    final mevcut = await future;

    final userId = _repository.currentUserId;

    final yeniOge = BeklemeOgesi(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      userId: userId,
      kategoriId: kategoriId,
      tetikleyiciId: tetikleyiciId,
      eklenmeTarihi: DateTime.now(),
      fiyat: fiyat,
    );

    // Önce UI'ı güncelle.
    final guncelListe = [
      ...mevcut,
      yeniOge,
    ];

    state = AsyncData(guncelListe);

    // Veritabanına kaydet.
    await _repository.ogeEkle(
      yeniOge,
    );

    // Hatırlatıcı için kategori adını bul.
    //
    // Örneğin:
    // giyim       → Giyim
    // elektronik → Elektronik
    // TRENDYOL    → TRENDYOL
    //
    // Trendyol sabit kategori listesinde yoksa
    // firstWhere hata vermesin.
    final kategoriler =
    _kategoriService.kategorileriGetir();

    String kategoriIsim = kategoriId;

    for (final kategori in kategoriler) {
      if (kategori.id == kategoriId) {
        kategoriIsim = kategori.isim;
        break;
      }
    }

    await _bildirimService.hatirlaticiKur(
      id: _bildirimIdUret(
        yeniOge.id,
      ),
      kategoriIsim: kategoriIsim,
      tetikTarihi: yeniOge.eklenmeTarihi.add(
        const Duration(
          hours: BeklemeOgesi.bekleSuresiSaat,
        ),
      ),
    );
  }

  Future<void> kaldir(String id) async {
    final mevcut = await future;

    final guncelListe = mevcut
        .where(
          (oge) => oge.id != id,
    )
        .toList();

    // Önce UI'ı güncelle.
    state = AsyncData(guncelListe);

    // Supabase'den sil.
    await _repository.ogeSil(id);

    // Hatırlatıcıyı iptal et.
    await _bildirimService.hatirlaticiIptalEt(
      _bildirimIdUret(id),
    );
  }
}

final beklemeListesiViewModelProvider =
AsyncNotifierProvider<
    BeklemeListesiViewModel,
    List<BeklemeOgesi>>(
  BeklemeListesiViewModel.new,
);