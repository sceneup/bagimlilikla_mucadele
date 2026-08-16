import 'package:bagimlilik/core/routers/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bagimlilik/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bagimlilik/features/bekleme_listesi/services/bildirim_service.dart';
import 'package:bagimlilik/features/notification/services/notification_service.dart';
import 'package:bagimlilik/features/notification/services/native_notification_action_sync_service.dart';
import 'package:flutter/foundation.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 2)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.red
    ..textColor = Colors.black87
    ..maskColor = Colors.black45
    ..maskType = EasyLoadingMaskType.black
    ..radius = 14
    ..fontSize = 16
    ..userInteractions = false
    ..dismissOnTap = true;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabaseAnonKey,
  );

  await NativeNotificationActionSyncService().flushPendingActions();

  final notificationService = NotificationService(router: appRouter,);

  await notificationService.initialize();
  await BildirimService().baslat();

  if (!kIsWeb) {
    notificationService.startListening();
  }

  configLoading();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        fontFamily: 'Inter',
      ),

      routerConfig: appRouter,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],

      builder: EasyLoading.init(),
    );
  }
}