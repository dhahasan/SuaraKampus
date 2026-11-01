import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_shell.dart';

class StudentShellWrapper extends StatelessWidget {
  final Widget child;

  const StudentShellWrapper({super.key, required this.child});

  static const List<BottomNavItem> _items = [
    BottomNavItem(
      icon: Icons.dynamic_feed_outlined,
      activeIcon: Icons.dynamic_feed_rounded,
      label: 'Feed',
      routePath: '/feed',
    ),
    BottomNavItem(
      icon: Icons.campaign_outlined,
      activeIcon: Icons.campaign_rounded,
      label: 'Tulis',
      routePath: '/compose',
    ),
    BottomNavItem(
      icon: Icons.history_rounded,
      activeIcon: Icons.history_rounded,
      label: 'Riwayat',
      routePath: '/riwayat',
    ),
    BottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      routePath: '/profil',
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/feed')) return 0;
    if (location.startsWith('/compose')) return 1;
    if (location.startsWith('/riwayat')) return 2;
    if (location.startsWith('/profil')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    context.go(_items[index].routePath);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: _calculateSelectedIndex(context),
      onIndexChanged: (index) => _onItemTapped(index, context),
      items: _items,
      child: child,
    );
  }
}
