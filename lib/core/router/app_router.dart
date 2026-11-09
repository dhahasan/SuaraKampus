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
import '../data/mock_repository.dart';
import '../models/app_models.dart';
import 'admin_shell_wrapper.dart';
import 'student_shell_wrapper.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _studentShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'studentShell');
final GlobalKey<NavigatorState> _adminShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'adminShell');

/// Rute-rute yang dapat diakses tanpa login
const _publicRoutes = ['/', '/login-glass', '/auth/masuk', '/auth/daftar'];

/// Rute-rute yang hanya boleh diakses user student yang sudah login
const _studentProtectedPrefixes = ['/feed', '/compose', '/riwayat', '/profil'];

/// Rute-rute yang hanya boleh diakses admin yang sudah login
const _adminProtectedPrefixes = ['/admin'];

/// Memeriksa apakah user sudah login (bukan guest)
bool _isLoggedIn(AppUser user) =>
    user.id != 'guest' && user.email.isNotEmpty;

final appRouterProvider = Provider<GoRouter>((ref) {
  final userListenable = ValueNotifier<AppUser>(
    const AppUser(
      id: 'guest',
      email: '',
      role: UserRole.student,
      verificationStatus: VerificationStatus.pending,
      monthlyQuotaUsed: 0,
      monthlyQuotaMax: 5,
    ),
  );

  // Pantau perubahan user agar router bisa refresh redirect
  ref.listen<AppUser>(currentUserProvider, (_, next) {
    userListenable.value = next;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    refreshListenable: userListenable,

    /// ─── ROUTE GUARD ──────────────────────────────────────────────────────
    /// Jika user belum login dan mencoba akses halaman yang dilindungi,
    /// redirect ke halaman login.
    redirect: (context, state) {
      final user = userListenable.value;
      final loggedIn = _isLoggedIn(user);
      final location = state.matchedLocation;

      // Halaman publik: boleh diakses kapan saja
      final isPublicRoute = _publicRoutes.any((r) => location == r);

      // Halaman student yang dilindungi
      final isStudentRoute = _studentProtectedPrefixes
          .any((prefix) => location.startsWith(prefix));

      // Halaman admin yang dilindungi
      final isAdminRoute = _adminProtectedPrefixes
          .any((prefix) => location.startsWith(prefix));

      // Belum login → paksa ke halaman login jika bukan halaman publik
      if (!loggedIn && (isStudentRoute || isAdminRoute)) {
        return '/login-glass';
      }

      // Sudah login sebagai student → tidak boleh akses admin
      if (loggedIn && user.role == UserRole.student && isAdminRoute) {
        return '/feed';
      }

      // Sudah login sebagai admin → tidak boleh akses student area
      if (loggedIn && user.role == UserRole.admin && isStudentRoute) {
        return '/admin/moderasi';
      }

      // Sudah login tapi masih di halaman login/splash → redirect ke halaman utama
      if (loggedIn && (isPublicRoute || location == '/')) {
        if (user.role == UserRole.admin) {
          return '/admin/moderasi';
        }
        return '/feed';
      }

      return null; // Tidak ada redirect
    },
    // ────────────────────────────────────────────────────────────────────────

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

      // Student Shell Navigation (4 tabs) — dilindungi route guard
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

      // Admin Shell Navigation (4 tabs) — dilindungi route guard
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
