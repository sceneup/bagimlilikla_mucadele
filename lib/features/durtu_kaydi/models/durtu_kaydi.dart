enum DurtuSonucu { beklemeyeEklendi, vazgecildi }

class DurtuKaydi {
  final String id;
  final String kategoriId;
  final String tetikleyiciId;
  final DateTime zaman;
  final DurtuSonucu sonuc;

  const DurtuKaydi({
    required this.id,
    required this.kategoriId,
    required this.tetikleyiciId,
    required this.zaman,
    required this.sonuc,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'kategoriId': kategoriId,
    'tetikleyiciId': tetikleyiciId,
    'zaman': zaman.toIso8601String(),
    'sonuc': sonuc.name,
  };

  factory DurtuKaydi.fromJson(Map<String, dynamic> json) {
    return DurtuKaydi(
      id: json['id'] as String,
      kategoriId: json['kategoriId'] as String,
      tetikleyiciId: json['tetikleyiciId'] as String,
      zaman: DateTime.parse(json['zaman'] as String),
      sonuc: DurtuSonucu.values.byName(json['sonuc'] as String),
    );
  }
}
