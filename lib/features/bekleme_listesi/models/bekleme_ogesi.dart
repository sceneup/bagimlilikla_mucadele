class BeklemeOgesi {
  static const int bekleSuresiSaat = 24;

  final String id;
  final String? userId;
  final String kategoriId;
  final String? tetikleyiciId;
  final DateTime eklenmeTarihi;
  final double? fiyat;

  const BeklemeOgesi({
    required this.id,
    this.userId,
    required this.kategoriId,
    this.tetikleyiciId,
    required this.eklenmeTarihi,
    this.fiyat,
  });

  DateTime get bitisZamani {
    return eklenmeTarihi.add(
      const Duration(hours: bekleSuresiSaat),
    );
  }

  Duration get kalanSure {
    final kalan =
    bitisZamani.difference(DateTime.now());

    if (kalan.isNegative) {
      return Duration.zero;
    }

    return kalan;
  }

  double get ilerlemeOrani {
    final gecenDakika = DateTime.now()
        .difference(eklenmeTarihi)
        .inMinutes;

    const toplamDakika =
        bekleSuresiSaat * 60;

    return (gecenDakika / toplamDakika)
        .clamp(0.0, 1.0);
  }

  bool get suresiDoldu {
    return DateTime.now().isAfter(
      bitisZamani,
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': kategoriId,
      'trigger_id': tetikleyiciId,
      'created_at': eklenmeTarihi.toIso8601String(),
      'price': fiyat,
    };
  }

  factory BeklemeOgesi.fromSupabase(
      Map<String, dynamic> json,
      ) {
    final rawPrice = json['price'];

    return BeklemeOgesi(
      id: json['id'].toString(),
      userId: json['user_id']?.toString(),
      kategoriId:
      json['category_id'].toString(),
      tetikleyiciId:
      json['trigger_id']?.toString(),
      eklenmeTarihi:
      DateTime.parse(
        json['created_at'].toString(),
      ),
      fiyat: rawPrice == null
          ? null
          : (rawPrice as num).toDouble(),
    );
  }
}