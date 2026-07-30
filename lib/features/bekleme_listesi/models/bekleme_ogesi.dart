class BeklemeOgesi {
  static const int bekleSuresiSaat = 24;

  final String id;
  final String kategoriId;
  final DateTime eklenmeTarihi;

  const BeklemeOgesi({
    required this.id,
    required this.kategoriId,
    required this.eklenmeTarihi,
  });

  Duration get kalanSure {
    final hedefZaman = eklenmeTarihi.add(
      const Duration(hours: bekleSuresiSaat),
    );
    final kalan = hedefZaman.difference(DateTime.now());
    return kalan.isNegative ? Duration.zero : kalan;
  }

  double get ilerlemeOrani {
    final gecenDakika = DateTime.now().difference(eklenmeTarihi).inMinutes;
    final toplamDakika = bekleSuresiSaat * 60;
    return (gecenDakika / toplamDakika).clamp(0.0, 1.0);
  }

  bool get suresiDoldu => kalanSure == Duration.zero;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kategoriId': kategoriId,
    'eklenmeTarihi': eklenmeTarihi.toIso8601String(),
  };

  factory BeklemeOgesi.fromJson(Map<String, dynamic> json) {
    return BeklemeOgesi(
      id: json['id'] as String,
      kategoriId: json['kategoriId'] as String,
      eklenmeTarihi: DateTime.parse(json['eklenmeTarihi'] as String),
    );
  }
}