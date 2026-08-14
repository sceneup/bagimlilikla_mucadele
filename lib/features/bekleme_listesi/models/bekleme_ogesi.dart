class BeklemeOgesi {
  /// TEST MODU: Test için true yapılırsa bekleme süresi 2 dakika olur.
  /// Canlı ortam için false yapılırsa bekleme süresi 24 saat (1440 dk) olur.
  static const bool isTestMode = true;

  static int get bekleSuresiDakika => isTestMode ? 2 : 24 * 60;
  static int get bekleSuresiSaat => isTestMode ? 0 : 24;

  final String id;
  final String? userId;
  final String kategoriId;
  final String? tetikleyiciId;
  final DateTime eklenmeTarihi;
  final double? fiyat;
  final String? sourceType;

  final String status;
  final String? decision;

  const BeklemeOgesi({
    required this.id,
    this.userId,
    required this.kategoriId,
    this.tetikleyiciId,
    required this.eklenmeTarihi,
    this.fiyat,
    this.sourceType = 'manuel',
    this.status = 'waiting',
    this.decision,
  });

  BeklemeOgesi copyWith({
    String? id,
    String? userId,
    String? kategoriId,
    String? tetikleyiciId,
    DateTime? eklenmeTarihi,
    double? fiyat,
    String? sourceType,
    String? status,
    String? decision,
  }) {
    return BeklemeOgesi(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      kategoriId: kategoriId ?? this.kategoriId,
      tetikleyiciId: tetikleyiciId ?? this.tetikleyiciId,
      eklenmeTarihi: eklenmeTarihi ?? this.eklenmeTarihi,
      fiyat: fiyat ?? this.fiyat,
      sourceType: sourceType ?? this.sourceType,
      status: status ?? this.status,
      decision: decision ?? this.decision,
    );
  }

  DateTime get bitisZamani {
    return eklenmeTarihi.add(
      Duration(minutes: bekleSuresiDakika),
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

    final toplamDakika = bekleSuresiDakika;

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
      'created_at': eklenmeTarihi.toUtc().toIso8601String(),
      'price': fiyat,
      'source_type': sourceType ?? 'manuel',
      'status': status,
      'decision': decision,
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
      ).toLocal(),
      fiyat: rawPrice == null
          ? null
          : (rawPrice as num).toDouble(),
      sourceType: json['source_type']?.toString() ?? 'manuel',
      status: json['status']?.toString() ?? 'waiting',
      decision: json['decision']?.toString(),
    );
  }
}