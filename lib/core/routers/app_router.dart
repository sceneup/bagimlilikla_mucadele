import 'package:bagimlilik/core/routers/main_shell.dart';
import 'package:bagimlilik/features/analiz/views/analiz_view.dart';
import 'package:bagimlilik/features/anasayfa/views/anasayfa_view.dart';
import 'package:bagimlilik/features/anket/views/anket_views.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/views/bekleme_listesi_view.dart';
import 'package:bagimlilik/features/bekleme_listesi/views/yeniden_degerlendirme_view.dart';
import 'package:bagimlilik/features/bilgi/views/bilgi_view.dart';
import 'package:bagimlilik/features/giris/views/giris_views.dart';
import 'package:bagimlilik/features/kayit/views/kayit_detay_views.dart';
import 'package:bagimlilik/features/kayit/views/kayit_views.dart';
import 'package:bagimlilik/features/notification/views/notification_view.dart';
import 'package:bagimlilik/features/odak_kontrolu/views/odak_kontrolu_view.dart';
import 'package:bagimlilik/features/profil/views/hakkinda_view.dart';
import 'package:bagimlilik/features/profil/views/profil_view.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String _getInitialLocation() {
  try {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return '/anasayfa';
    }
  } catch (_) {}
  return '/giris';
}

final GoRouter appRouter = GoRouter(
  initialLocation: _getInitialLocation(),
  redirect: (context, state) {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuthRoute = state.matchedLocation == '/giris' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/register-detay' ||
          state.matchedLocation == '/anket';

      // Zaten giriş yapmış kullanıcı /giris sayfasına gitmeye çalışırsa anasayfaya yönlendir
      if (session != null && state.matchedLocation == '/giris') {
        return '/anasayfa';
      }

      // Giriş yapmamış kullanıcı korumalı sayfaya erişmeye çalışırsa giriş ekranına yönlendir
      if (session == null && !isAuthRoute) {
        return '/giris';
      }
    } catch (_) {}
    return null;
  },
  routes: [
    GoRoute(
      path: '/giris',
      builder: (context, state) => const GirisViews(),
    ),
    GoRoute(
      path: '/anket',
      builder: (context, state) => const AnketViews(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const KayitViews(),
    ),
    GoRoute(
      path: '/register-detay',
      builder: (context, state) => const KayitDetayViews(),
    ),
    GoRoute(
      path: '/odak-kontrolu',
      builder: (context, state) {
        return const OdakKontroluView();
      },
    ),
    GoRoute(
      path: '/bekleme-listesi',
      builder: (context, state) {
        return const BeklemeListesiView();
      },
    ),
    GoRoute(
      path: '/hakkinda',
      builder: (context, state) {
        return const HakkindaView();
      },
    ),
    GoRoute(
      path: '/yeniden-degerlendirme',
      builder: (context, state) {
        final oge = state.extra as BeklemeOgesi?;
        return YenidenDegerlendirmeView(oge: oge);
      },
    ),
    GoRoute(
      path: '/erisim-bildirim',
      builder: (context, state) {
        return const NotificationView();
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/anasayfa',
              builder: (context, state) {
                return const AnasayfaView();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bilgi',
              builder: (context, state) {
                return const BilgiView();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/analiz',
              builder: (context, state) {
                return const AnalizView();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profil',
              builder: (context, state) {
                return const ProfilView();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);