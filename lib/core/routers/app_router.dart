import 'package:bagimlilik/core/routers/main_shell.dart';
import 'package:bagimlilik/features/analiz/views/analiz_view.dart';
import 'package:bagimlilik/features/anasayfa/views/anasayfa_view.dart';
import 'package:bagimlilik/features/anket/views/anket_views.dart';
import 'package:bagimlilik/features/bekleme_listesi/models/bekleme_ogesi.dart';
import 'package:bagimlilik/features/bekleme_listesi/views/bekleme_listesi_view.dart';
import 'package:bagimlilik/features/bekleme_listesi/views/yeniden_degerlendirme_view.dart';
import 'package:bagimlilik/features/giris/views/giris_views.dart';
import 'package:bagimlilik/features/kayit/views/kayit_detay_views.dart';
import 'package:bagimlilik/features/kayit/views/kayit_views.dart';
import 'package:bagimlilik/features/notification/views/notification_view.dart';
import 'package:bagimlilik/features/odak_kontrolu/views/odak_kontrolu_view.dart';
import 'package:bagimlilik/features/profil/views/hakkinda_view.dart';
import 'package:bagimlilik/features/profil/views/profil_view.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/giris',
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
                return const NotificationView();
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