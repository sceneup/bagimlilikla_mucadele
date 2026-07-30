import 'package:bagimlilik/core/routers/app_router.dart';
import 'package:bagimlilik/features/bekleme_listesi/services/bildirim_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  await BildirimService().baslat();
  runApp(
      const ProviderScope( child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      routerConfig: appRouter,
      builder: EasyLoading.init(),
    );
  }
}

