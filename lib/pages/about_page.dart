import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Profil & Pengaturan',
        subtitle: 'PROFIL MARKAS GAMER',
        showBack: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.neonPink.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/steamlog_logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Markas Gamer',
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vice Synthwave Edition • v1.0',
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return Card(
                child: SwitchListTile(
                  title: const Text('Mode Gelap (Vice Synthwave)'),
                  subtitle: const Text(
                    'Tema utama neon synthwave (#0C0E17 & #FF2A85)',
                  ),
                  activeThumbColor: AppColors.neonPink,
                  value: isDark,
                  onChanged: (val) {
                    themeModeNotifier.value = val
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
