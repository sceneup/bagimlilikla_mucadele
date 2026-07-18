import 'package:bagimlilik/core/routers/main_shell.dart';
import 'package:bagimlilik/features/analiz/analiz_view.dart';
import 'package:bagimlilik/features/anasayfa/views/anasayfa_view.dart';
import 'package:bagimlilik/features/bilgi/bilgi_view.dart';
import 'package:bagimlilik/features/profil/views/profil_view.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/anasayfa',
  routes: [
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