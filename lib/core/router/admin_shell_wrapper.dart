import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_shell.dart';

class AdminShellWrapper extends StatelessWidget {
  final Widget child;

  const AdminShellWrapper({super.key, required this.child});

  static const List<BottomNavItem> _items = [
    BottomNavItem(
      icon: Icons.fact_check_outlined,
      activeIcon: Icons.fact_check_rounded,
      label: 'Moderasi',
      routePath: '/admin/moderasi',
    ),
    BottomNavItem(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
      label: 'Tindak Lanjut',
      routePath: '/admin/tindak-lanjut',
    ),
    BottomNavItem(
      icon: Icons.camera_alt_outlined,
      activeIcon: Icons.camera_alt_rounded,
      label: 'Antrean IG',
      routePath: '/admin/antrean-ig',
    ),
    BottomNavItem(
      icon: Icons.bar_chart_rounded,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Statistik',
      routePath: '/admin/statistik',
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/admin/moderasi')) return 0;
    if (location.startsWith('/admin/tindak-lanjut')) return 1;
    if (location.startsWith('/admin/antrean-ig')) return 2;
    if (location.startsWith('/admin/statistik')) return 3;
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
