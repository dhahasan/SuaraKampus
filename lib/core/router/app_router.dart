import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/antrean_instagram_screen.dart';
import '../../features/admin/moderasi_screen.dart';
import '../../features/admin/statistik_screen.dart';
import '../../features/admin/tindak_lanjut_screen.dart';
import '../../features/auth/auth_tab_screen.dart';
import '../../features/auth/login_glass_screen.dart';
import '../../features/auth/verifikasi_akun_screen.dart';
import '../../features/compose/compose_screen.dart';
import '../../features/feed/feed_screen.dart';
import '../../features/profil/profil_screen.dart';
import '../../features/riwayat/riwayat_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'admin_shell_wrapper.dart';
import 'student_shell_wrapper.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _studentShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'studentShell');
final GlobalKey<NavigatorState> _adminShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'adminShell');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Flow
      GoRoute(
        path: '/login-glass',
        builder: (context, state) => const LoginGlassScreen(),
      ),
      GoRoute(
        path: '/auth/masuk',
        builder: (context, state) =>
            const AuthTabScreen(initialTabIndex: 0),
      ),
      GoRoute(
        path: '/auth/daftar',
        builder: (context, state) =>
            const AuthTabScreen(initialTabIndex: 1),
      ),
      GoRoute(
        path: '/auth/verifikasi-ditolak',
        builder: (context, state) =>
            const VerifikasiAkunScreen(isRejectedInitial: true),
      ),
      GoRoute(
        path: '/auth/verifikasi-menunggu',
        builder: (context, state) =>
            const VerifikasiAkunScreen(isRejectedInitial: false),
      ),

      // Student Shell Navigation (4 tabs)
      ShellRoute(
        navigatorKey: _studentShellNavigatorKey,
        builder: (context, state, child) {
          return StudentShellWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/feed',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FeedScreen(),
            ),
          ),
          GoRoute(
            path: '/compose',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ComposeScreen(),
            ),
          ),
          GoRoute(
            path: '/riwayat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RiwayatScreen(),
            ),
          ),
          GoRoute(
            path: '/profil',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilScreen(),
            ),
          ),
        ],
      ),

      // Admin Shell Navigation (4 tabs)
      ShellRoute(
        navigatorKey: _adminShellNavigatorKey,
        builder: (context, state, child) {
          return AdminShellWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/admin/moderasi',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ModerasiScreen(),
            ),
          ),
          GoRoute(
            path: '/admin/tindak-lanjut',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TindakLanjutScreen(),
            ),
          ),
          GoRoute(
            path: '/admin/antrean-ig',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AntreanInstagramScreen(),
            ),
          ),
          GoRoute(
            path: '/admin/statistik',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatistikScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
