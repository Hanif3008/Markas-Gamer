import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Bottom Navigation Bar Vice Synthwave 3 tab: Beranda, Catatan, Lokasi.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.neonPink.withValues(alpha: 0.16),
        elevation: 0,
        onDestinationSelected: (index) {
          if (index == currentIndex) return;
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/catatan');
            case 2:
              context.go('/lokasi');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(
              Icons.sports_esports_rounded,
              color: AppColors.neonPink,
            ),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(
              Icons.menu_book_rounded,
              color: AppColors.neonPink,
            ),
            label: 'Catatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(
              Icons.explore_rounded,
              color: AppColors.neonPink,
            ),
            label: 'Lokasi',
          ),
        ],
      ),
    );
  }
}
