import 'package:bagimlilik/features/anket/models/survey_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SurveyRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<void> saveSurveyResult(
      SurveyResult result,
      ) async {
    await _supabase
        .from('survey_results')
        .insert(result.toMap());
  }

  Future<int> getNextAttemptNo() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Kullanıcı giriş yapmamış.',
      );
    }

    final response = await _supabase
        .from('survey_results')
        .select('attempt_no')
        .eq('user_id', user.id)
        .order(
      'attempt_no',
      ascending: false,
    )
        .limit(1);

    if (response.isEmpty) {
      return 1;
    }

    return (response.first['attempt_no'] as int) + 1;
  }

  Future<SurveyResult?> getLatestSurveyResult() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response = await _supabase
        .from('survey_results')
        .select()
        .eq('user_id', user.id)
        .order(
      'attempt_no',
      ascending: false,
    )
        .limit(1);

    if (response.isEmpty) {
      return null;
    }

    return SurveyResult.fromMap(
      Map<String, dynamic>.from(
        response.first,
      ),
    );
  }
  Future<bool> isSurveyDue() async {
    final latestSurvey = await getLatestSurveyResult();

    // Kullanıcı daha önce hiç anket yapmamış.
    // İlk anket gerekli.
    if (latestSurvey == null) {
      return true;
    }

    // Son anketin tekrar zamanı geldiyse
    // yeni anket gerekli.
    return DateTime.now().isAfter(
      latestSurvey.nextSurveyAt,
    );
  }
}