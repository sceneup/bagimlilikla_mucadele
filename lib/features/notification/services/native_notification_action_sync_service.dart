import 'dart:convert';

import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/repositories/bekleme_listesi_repository.dart';
import 'package:bagimlilik/features/notification/repositories/daily_behavior_stats_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NativeNotificationActionSyncService {
  static const String _pendingVerificationCountKey = 'pending_verification_count';
  static const String _pendingMicroInterventionCountKey = 'pending_micro_intervention_count';
  static const String _pendingSkipCountKey = 'pending_skip_count';
  static const String _pendingWaitingListItemsKey = 'pending_waiting_list_items';

  final DailyBehaviorStatsRepository _statsRepository =
      DailyBehaviorStatsRepository();
  final BeklemeListesiRepository _waitingListRepository =
      BeklemeListesiRepository();

  Future<void> flushPendingActions() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await _flushCount(
      prefs: prefs,
      key: _pendingVerificationCountKey,
      handler: _statsRepository.incrementVerification,
    );

    await _flushCount(
      prefs: prefs,
      key: _pendingMicroInterventionCountKey,
      handler: _statsRepository.incrementMicroIntervention,
    );

    await _flushCount(
      prefs: prefs,
      key: _pendingSkipCountKey,
      handler: _statsRepository.incrementSkip,
    );

    await _flushWaitingListItems(prefs);
  }

  Future<void> _flushCount({
    required SharedPreferences prefs,
    required String key,
    required Future<void> Function() handler,
  }) async {
    final count = prefs.getInt(key) ?? 0;
    if (count <= 0) {
      return;
    }

    for (var index = 0; index < count; index++) {
      await handler();
    }

    await prefs.remove(key);
  }

  Future<void> _flushWaitingListItems(SharedPreferences prefs) async {
    final items = prefs.getStringList(_pendingWaitingListItemsKey) ?? const [];
    if (items.isEmpty) {
      return;
    }

    final remainingItems = <String>[];

    for (final rawItem in items) {
      try {
        final data = jsonDecode(rawItem) as Map<String, dynamic>;
        final merchantName = data['merchantName']?.toString().trim();
        if (merchantName == null || merchantName.isEmpty) {
          continue;
        }

        final amount = data['amount']?.toString().trim();
        double? price;
        if (amount != null && amount.isNotEmpty) {
          final cleaned = amount
              .replaceAll('₺', '')
              .replaceAll('TL', '')
              .replaceAll(' ', '')
              .replaceAll('.', '')
              .replaceAll(',', '.');
          price = double.tryParse(cleaned);
        }

        final entry = BeklemeOgesi(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: _waitingListRepository.currentUserId,
          kategoriId: merchantName,
          tetikleyiciId: merchantName,
          eklenmeTarihi: DateTime.now(),
          fiyat: price,
          sourceType: 'notification',
        );

        await _waitingListRepository.ogeEkle(entry);
        await _statsRepository.incrementWaitingList();
      } catch (e) {
        debugPrint('❌ Native waiting list sync failed: $e');
        remainingItems.add(rawItem);
      }
    }

    if (remainingItems.isEmpty) {
      await prefs.remove(_pendingWaitingListItemsKey);
    } else {
      await prefs.setStringList(_pendingWaitingListItemsKey, remainingItems);
    }
  }
}
