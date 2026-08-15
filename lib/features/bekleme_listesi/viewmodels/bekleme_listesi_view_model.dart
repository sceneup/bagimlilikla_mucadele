import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_degerlendirme.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/repositories/bekleme_listesi_repository.dart';
import 'package:bagimlilik/features/bekleme_listesi/services/bildirim_service.dart';
import 'package:bagimlilik/features/odak_kontrolu/services/kategori_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

int _bildirimIdUret(String ogeId) {
  final parsed = int.tryParse(ogeId);
  if (parsed != null) {
    // millisecondsSinceEpoch 32-bit sınırını aşıyor → maskele
    return parsed & 0x7FFFFFFF;
  }
  return ogeId.hashCode & 0x7FFFFFFF;
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
    final guncellenecekIdler = <String>[];

    for (final oge in liste) {
      // Sadece iptal/tamamlanmamış ve karara bağlanmamış aktif öğeleri filtrele
      if (oge.status == 'cancelled' ||
          oge.status == 'completed' ||
          oge.decision == 'abandoned' ||
          oge.decision == 'purchased') {
        continue;
      }

      // Süresi dolmuş ve hala 'waiting' durumunda olan öğeleri 'ready_for_evaluation' yap
      if (oge.suresiDoldu && oge.status == 'waiting') {
        guncellenecekIdler.add(oge.id);
        aktifler.add(
          oge.copyWith(status: 'ready_for_evaluation'),
        );
      } else {
        aktifler.add(oge);
      }
    }

    // Süresi dolan 'waiting' öğelerinin durumunu Supabase'de güncelle
    if (guncellenecekIdler.isNotEmpty) {
      await _repository.durumlariGuncelle(
        guncellenecekIdler,
        'ready_for_evaluation',
      );
    }

    return aktifler;
  }

  Future<void> ekle(
    String kategoriId, {
    String? tetikleyiciId,
    double? fiyat,
    String sourceType = 'manuel',
    int? initialUrgeScore,
    String? initialPurchaseReason,
  }) async {
    debugPrint('🟢 [ekle] başladı: kategoriId=$kategoriId');
    try {
      final mevcut = await future;
      debugPrint('🟢 [ekle] mevcut liste alındı: ${mevcut.length} öğe');

      final userId = _repository.currentUserId;
      debugPrint('🟢 [ekle] userId=$userId');

      final yeniOge = BeklemeOgesi(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        userId: userId,
        kategoriId: kategoriId,
        tetikleyiciId: tetikleyiciId,
        eklenmeTarihi: DateTime.now(),
        fiyat: fiyat,
        sourceType: sourceType,
        status: 'waiting',
      );

      // Veritabanına kaydet ve Supabase'deki gerçek ID'ye sahip öğeyi al
      debugPrint('🟢 [ekle] Supabase\'e ekleniyor...');
      final eklenenOge = await _repository.ogeEkle(yeniOge);
      debugPrint('🟢 [ekle] Supabase\'e eklendi, ID=${eklenenOge.id}');

      if (userId != null) {
        final initialDegerlendirme = BeklemeDegerlendirme(
          waitlistId: eklenenOge.id,
          userId: userId,
          evaluationType: 'initial',
          urgeScore: initialUrgeScore ?? 5,
          purchaseReason: initialPurchaseReason,
        );
        await _repository.degerlendirmeEkle(initialDegerlendirme);
        debugPrint('🟢 [ekle] initial degerlendirme eklendi');
      }

      final guncelListe = [...mevcut, eklenenOge];
      state = AsyncData(guncelListe);

      final kategoriler = _kategoriService.kategorileriGetir();
      String kategoriIsim = kategoriId;
      for (final kategori in kategoriler) {
        if (kategori.id == kategoriId) {
          kategoriIsim = kategori.isim;
          break;
        }
      }

      final tetikTarihi = yeniOge.eklenmeTarihi.add(
        Duration(minutes: BeklemeOgesi.bekleSuresiDakika),
      );
      debugPrint('🟢 [ekle] hatirlaticiKur çağrılıyor... tetikTarihi=$tetikTarihi (${BeklemeOgesi.bekleSuresiDakika} dk sonra)');

      await _bildirimService.hatirlaticiKur(
        id: _bildirimIdUret(yeniOge.id),
        kategoriIsim: kategoriIsim,
        tetikTarihi: tetikTarihi,
      );
      debugPrint('🟢 [ekle] hatirlaticiKur tamamlandı');
    } catch (e, stack) {
      debugPrint('❌ [ekle] HATA: $e');
      debugPrint('❌ [ekle] StackTrace: $stack');
    }
  }

  /// Kullanıcının nihai kararını kaydeder (abandoned, purchased, wait_more)
  Future<void> kararVer(String id, String decision) async {
    final mevcut = await future;

    final ogeIndex = mevcut.indexWhere((o) => o.id == id);
    if (ogeIndex == -1) return;

    final oge = mevcut[ogeIndex];

    if (decision == 'wait_more') {
      // 24 saat (test modunda 2 dk) daha bekle: eklenme tarihini yenile ve durumu 'waiting' yap
      final simdi = DateTime.now();
      final guncelOge = oge.copyWith(
        eklenmeTarihi: simdi,
        status: 'waiting',
        decision: 'wait_more',
      );

      final guncelListe = List<BeklemeOgesi>.from(mevcut);
      guncelListe[ogeIndex] = guncelOge;
      state = AsyncData(guncelListe);

      await _repository.kararGuncelle(
        id: id,
        status: 'waiting',
        decision: 'wait_more',
        yeniEklenmeTarihi: simdi,
      );

      // Hatırlatıcıyı yeniden kur
      final kategoriler = _kategoriService.kategorileriGetir();
      String kategoriIsim = oge.kategoriId;
      for (final k in kategoriler) {
        if (k.id == oge.kategoriId) {
          kategoriIsim = k.isim;
          break;
        }
      }

      await _bildirimService.hatirlaticiKur(
        id: _bildirimIdUret(id),
        kategoriIsim: kategoriIsim,
        tetikTarihi: simdi.add(
          Duration(minutes: BeklemeOgesi.bekleSuresiDakika),
        ),
      );
    } else {
      // 'abandoned' veya 'purchased': durumu 'completed' yap ve aktif listeden kaldır
      final guncelListe = mevcut.where((o) => o.id != id).toList();
      state = AsyncData(guncelListe);

      await _repository.kararGuncelle(
        id: id,
        status: 'completed',
        decision: decision,
      );

      await _bildirimService.hatirlaticiIptalEt(_bildirimIdUret(id));
    }
  }

  /// Bekleme değerlendirmesi ekler (bekleme_degerlendirmeleri)
  Future<void> degerlendirmeKaydet(BeklemeDegerlendirme degerlendirme) async {
    await _repository.degerlendirmeEkle(degerlendirme);
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

    // Supabase'de durumu 'cancelled' olarak güncelle.
    await _repository.kararGuncelle(
      id: id,
      status: 'cancelled',
    );

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