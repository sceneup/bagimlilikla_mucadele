import 'package:bagimlilik/features/anket/models/anket_sorusu.dart';

class AnketBolum {
  final int bolumNo;
  final String kod;
  final String baslik;
  final List<AnketSorusu> sorular;

  const AnketBolum({
    required this.bolumNo,
    required this.kod,
    required this.baslik,
    required this.sorular,
  });

  factory AnketBolum.fromJson(Map<String, dynamic> json) {
    return AnketBolum(
      bolumNo: json["bolumNo"],
      kod: json["kod"],
      baslik: json["baslik"],
      sorular: (json["sorular"] as List)
          .map((e) => AnketSorusu.fromJson(e))
          .toList(),
    );
  }
}