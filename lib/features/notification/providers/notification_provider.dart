import 'package:bagimlilik/features/notification/models/notification_state.dart';
import 'package:bagimlilik/features/notification/viewmodels/notification_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationViewModelProvider =
NotifierProvider<NotificationViewModel, NotificationState>(
  NotificationViewModel.new,
);