import 'package:bagimlilik/features/notification/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state =
    ref.watch(notificationViewModelProvider);

    final vm =
    ref.read(notificationViewModelProvider.notifier);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Bildirim Testi"),
      ),

      body: Center(

        child: state.hasPermission

            ? const Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),

            SizedBox(height: 20),

            Text(
              "Bildirim erişimi aktif",
              style: TextStyle(
                fontSize: 18,
              ),
            ),

          ],
        )

            : ElevatedButton(

          onPressed: () async {

            await vm.enableNotifications();

          },

          child: const Text(
            "Bildirim Erişimi Ver",
          ),
        ),

      ),

    );
  }
}