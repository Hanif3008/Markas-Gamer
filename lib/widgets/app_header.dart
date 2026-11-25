import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// AppBar SteamLog Vice Synthwave dengan logo aplikasi SteamLog.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle = 'MARKAS GAMER',
    this.showBack = false,
    this.onSearchTap,
  });

  final String title;
  final String subtitle;
  final bool showBack;
  final VoidCallback? onSearchTap;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      titleSpacing: showBack ? 4 : 16,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            )
          : null,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: AppColors.neonPink.withValues(alpha: 0.6),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPink.withValues(alpha: 0.35),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/steamlog_logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: tt.labelSmall?.copyWith(
                    color: AppColors.neonPink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  title,
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (onSearchTap != null)
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Cari',
            onPressed: onSearchTap,
          ),
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.push('/tentang'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonPink.withValues(alpha: 0.16),
                border: Border.all(
                  color: AppColors.neonPink.withValues(alpha: 0.8),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 19,
                color: AppColors.neonPinkSoft,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
