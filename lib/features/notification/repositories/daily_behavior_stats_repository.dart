import 'package:supabase_flutter/supabase_flutter.dart';

class DailyBehaviorStatsRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<void> incrementVerification() async {
    await _increment('verification');
  }

  Future<void> incrementWaitingList() async {
    await _increment('waiting_list');
  }

  Future<void> incrementSkip() async {
    await _increment('skip');
  }

  Future<void> incrementMicroIntervention() async {
    await _increment('micro_intervention');
  }

  Future<void> _increment(String type) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    await _supabase.rpc(
      'increment_daily_behavior_stat',
      params: {
        'stat_type': type,
      },
    );
  }
}