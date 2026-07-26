class AnketSorusu {
  final int id;
  final String metin;

  const AnketSorusu({
    required this.id,
    required this.metin,
  });
  factory AnketSorusu.fromJson(Map<String, dynamic> json) {
    return AnketSorusu(
      id: json["id"],
      metin: json["metin"],
    );
  }
}