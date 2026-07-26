import 'package:bagimlilik/features/anket/models/anket_bolumu.dart';

class AnketState {
  final List<AnketBolum> bolumler;
  final Map<int, int> cevaplar;
  final int aktifBolumIndex;

  const AnketState({
    required this.bolumler,
    required this.cevaplar,
    required this.aktifBolumIndex,
  });

  AnketState copyWith({
    List<AnketBolum>? bolumler,
    Map<int, int>? cevaplar,
    int? aktifBolumIndex,
  }) {
    return AnketState(
      bolumler: bolumler ?? this.bolumler,
      cevaplar: cevaplar ?? this.cevaplar,
      aktifBolumIndex: aktifBolumIndex ?? this.aktifBolumIndex,
    );
  }
}