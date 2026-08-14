import 'package:bagimlilik/features/anket/models/anket_state.dart';
import 'package:bagimlilik/features/anket/models/survey_result.dart';
import 'package:bagimlilik/features/anket/repositories/survey_repository.dart';
import 'package:bagimlilik/features/anket/services/anket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnketViewModel extends AsyncNotifier<AnketState> {
  final _service = AnketService();
  final SurveyRepository _repository =
  SurveyRepository();

  @override
  Future<AnketState> build() async {
    final bolumler = await _service.anketiYukle();

    return AnketState(
      bolumler: bolumler,
      cevaplar: {},
      aktifBolumIndex: 0,
    );
  }
  void cevapSec(int soruNo, int cevap) {
    final mevcutState = state.value;

    if (mevcutState == null) {
      return;
    }

    state = AsyncData(
      mevcutState.copyWith(
        cevaplar: {
          ...mevcutState.cevaplar,
          soruNo: cevap,
        },
      ),
    );
  }
  void sonrakiBolumeGec() {
    final mevcutState = state.value;

    if (mevcutState == null) {
      return;
    }

    final sonBolumIndex = mevcutState.bolumler.length - 1;

    if (mevcutState.aktifBolumIndex < sonBolumIndex) {
      state = AsyncData(
        mevcutState.copyWith(
          aktifBolumIndex: mevcutState.aktifBolumIndex + 1,
        ),
      );
    }
  }
  bool aktifBolumTamamlandiMi() {
    final mevcutState = state.value;

    if (mevcutState == null || mevcutState.bolumler.isEmpty) {
      return false;
    }

    final aktifBolum =
    mevcutState.bolumler[mevcutState.aktifBolumIndex];

    return aktifBolum.sorular.every(
          (soru) => mevcutState.cevaplar.containsKey(soru.id),
    );
  }
  Future<void> anketiTamamla() async {
    final mevcutState = state.value;

    if (mevcutState == null) {
      throw Exception(
        'Anket verileri bulunamadı.',
      );
    }

    if (mevcutState.cevaplar.length != 17) {
      throw Exception(
        'Lütfen tüm soruları cevaplayın.',
      );
    }

    final user =
        Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Kullanıcı giriş yapmamış.',
      );
    }

    final attemptNo =
    await _repository.getNextAttemptNo();

    final now = DateTime.now();

    // Şimdilik 1 ay sonra tekrar anket
    final nextSurveyAt = DateTime(
      now.year,
      now.month + 1,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );

    final soru1 = 5 - mevcutState.cevaplar[1]!;
    final soru2 = 5 - mevcutState.cevaplar[2]!;
    final soru3 = 5 - mevcutState.cevaplar[3]!;
    final soru4 = 5 - mevcutState.cevaplar[4]!;
    final soru5 = 5 - mevcutState.cevaplar[5]!;
    final soru6 = 5 - mevcutState.cevaplar[6]!;
    final soru7 = 5 - mevcutState.cevaplar[7]!;
    final soru8 = 5 - mevcutState.cevaplar[8]!;
    final soru9 = 5 - mevcutState.cevaplar[9]!;
    final soru10 = 5 - mevcutState.cevaplar[10]!;
    final soru11 = 5 - mevcutState.cevaplar[11]!;
    final soru12 = 5 - mevcutState.cevaplar[12]!;
    final soru13 = 5 - mevcutState.cevaplar[13]!;
    final soru14 = 5 - mevcutState.cevaplar[14]!;
    final soru15 = 5 - mevcutState.cevaplar[15]!;
    final soru16 = 5 - mevcutState.cevaplar[16]!;
    final soru17 = 5 - mevcutState.cevaplar[17]!;

    final toplamPuan =
        soru1 +
            soru2 +
            soru3 +
            soru4 +
            soru5 +
            soru6 +
            soru7 +
            soru8 +
            soru9 +
            soru10 +
            soru11 +
            soru12 +
            soru13 +
            soru14 +
            soru15 +
            soru16 +
            soru17;

    final result = SurveyResult(
      userId: user.id,
      attemptNo: attemptNo,

      question1: soru1,
      question2: soru2,
      question3: soru3,
      question4: soru4,
      question5: soru5,
      question6: soru6,
      question7: soru7,
      question8: soru8,
      question9: soru9,
      question10: soru10,
      question11: soru11,
      question12: soru12,
      question13: soru13,
      question14: soru14,
      question15: soru15,
      question16: soru16,
      question17: soru17,

      totalScore: toplamPuan,

      takenAt: now,
      nextSurveyAt: nextSurveyAt,
    );

    await _repository.saveSurveyResult(
      result,
    );
  }
}

final anketViewModelProvider =
AsyncNotifierProvider<AnketViewModel, AnketState>(
  AnketViewModel.new,
);