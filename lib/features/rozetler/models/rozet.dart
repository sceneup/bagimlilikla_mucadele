class Rozet {
  final String id;
  final String kategoriId;
  final DateTime kazanmaTarihi;

  const Rozet({
    required this.id,
    required this.kategoriId,
    required this.kazanmaTarihi,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'kategoriId': kategoriId,
    'kazanmaTarihi': kazanmaTarihi.toIso8601String(),
  };

  factory Rozet.fromJson(Map<String, dynamic> json) {
    return Rozet(
      id: json['id'] as String,
      kategoriId: json['kategoriId'] as String,
      kazanmaTarihi: DateTime.parse(json['kazanmaTarihi'] as String),
    );
  }
}
