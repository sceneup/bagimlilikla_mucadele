import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'notification_filter_service.dart';

class NotificationService {

  StreamSubscription<ServiceNotificationEvent>? _subscription;

  Future<bool> requestPermission() async {
    return NotificationListenerService.requestPermission();
  }

  Future<bool> isPermissionGranted() async {
    return NotificationListenerService.isPermissionGranted();
  }

  void startListening() {

    final filter = NotificationFilterService();

    _subscription =
        NotificationListenerService.notificationsStream.listen(

              (event) {

            final type = filter.detect(
              packageName: event.packageName,
              title: event.title,
              content: event.content,
            );

            print("---------------");
            print("Type      : $type");
            print("Package   : ${event.packageName}");
            print("Title     : ${event.title}");
            print("Content   : ${event.content}");
            print("---------------");

          },

        );

  }

  void stopListening() {
    _subscription?.cancel();
  }

}