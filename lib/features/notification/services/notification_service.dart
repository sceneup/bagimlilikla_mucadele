import 'dart:async';

import 'package:notification_listener_service/notification_listener_service.dart';

class NotificationService {

  StreamSubscription? _subscription;

  Future<bool> requestPermission() async {
    return await NotificationListenerService.requestPermission();
  }

  Future<bool> isPermissionGranted() async {
    return await NotificationListenerService.isPermissionGranted();
  }

  void startListening() {

    _subscription =
        NotificationListenerService.notificationsStream.listen(

              (event) {

            print("============");
            print("Package : ${event.packageName}");
            print("Title   : ${event.title}");
            print("Content : ${event.content}");

          },

        );
  }

  void stopListening() {
    _subscription?.cancel();
  }
}