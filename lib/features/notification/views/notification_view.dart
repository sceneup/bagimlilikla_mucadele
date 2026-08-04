import 'package:bagimlilik/features/notification/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationView extends ConsumerStatefulWidget {
  const NotificationView({super.key});

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(notificationViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {

    final notificationState =
    ref.watch(notificationViewModelProvider);

    return Scaffold(
      body: Center(
        child: Text(
          notificationState.hasPermission
              ? "Bildirim izni verildi"
              : "Bildirim izni verilmedi",
        ),
      ),
    );
  }
}