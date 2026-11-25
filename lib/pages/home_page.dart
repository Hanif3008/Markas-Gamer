import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../services/catatan_db.dart';
import '../services/lokasi_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_shell.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _lat = LokasiService.defaultLat;
  double _lng = LokasiService.defaultLng;
  double _accuracy = 4.2;
  bool _gpsGranted = true;
  int _noteCount = 3;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _refreshTelemetry(silent: true);
  }

  Future<void> _refreshTelemetry({bool silent = false}) async {
    setState(() => _syncing = true);
    var count = _noteCount;
    try {
      count = await CatatanDb.instance.count();
    } catch (_) {}
    final pos = await LokasiService.instance.getCurrentPosition();

    if (!mounted) return;
    setState(() {
      _noteCount = count;
      if (pos != null) {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _accuracy = pos.accuracy;
        _gpsGranted = true;
      }
      _syncing = false;
    });

    if (!silent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data & lokasi Markas Gamer berhasil diperbarui.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _copyCoords() {
    final text = '${_lat.toStringAsFixed(5)}, ${_lng.toStringAsFixed(5)}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Koordinat disalin: $text'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pinkText = isDark ? AppColors.neonPinkSoft : cs.primary;
    final cyanText = isDark ? AppColors.laserCyan : cs.tertiary;

    return Scaffold(
      appBar: AppHeader(
        title: 'Beranda',
        subtitle: 'MARKAS GAMER',
        onSearchTap: () => context.go('/catatan'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshTelemetry(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            // Top Status Ticker Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.neonPink.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.neonPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'MARKAS GAMER // GAMING HUB',
                      style: tt.labelSmall?.copyWith(
                        fontFamily: 'monospace',
                        color: pinkText,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'OFFLINE READY • v1.0',
                    style: tt.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                      color: cs.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Hero Banner Card with Vice Synthwave Artwork
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.cardLow,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.neonPink.withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.synthPurple.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 190,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/hero_synthwave.jpg',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.canvas.withValues(alpha: 0.35),
                                Colors.transparent,
                                AppColors.cardLow.withValues(alpha: 0.96),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.canvas.withValues(
                                        alpha: 0.78,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            color: AppColors.laserCyan,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Steam PC Companion',
                                          style: tt.labelSmall?.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.canvas.withValues(
                                        alpha: 0.78,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: AppColors.neonPink.withValues(
                                          alpha: 0.45,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Library Lokal',
                                      style: tt.labelSmall?.copyWith(
                                        color: AppColors.neonPinkSoft,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.neonPink,
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.neonPink.withValues(
                                            alpha: 0.45,
                                          ),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'LOKASI AKTIF',
                                          style: tt.labelSmall?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.canvas.withValues(
                                        alpha: 0.78,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: AppColors.laserCyan.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Peta Siap',
                                      style: tt.labelSmall?.copyWith(
                                        color: AppColors.laserCyan,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Markas Gamer',
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Catat progress game PC favoritmu, pantau riwayat mabar, dan temukan spot warnet gaming terdekat dalam satu aplikasi.',
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () async {
                                  final created = await context.push<bool>(
                                    '/catatan/baru',
                                  );
                                  if (created == true) {
                                    _refreshTelemetry(silent: true);
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.neonPink,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                ),
                                label: const Text(
                                  '+ Catatan Game Baru',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              color: AppColors.cardHigh,
                              shape: const CircleBorder(
                                side: BorderSide(color: AppColors.glassBorder),
                              ),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: _syncing
                                    ? null
                                    : () => _refreshTelemetry(),
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: _syncing
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.laserCyan,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.sync_rounded,
                                          color: AppColors.laserCyan,
                                          size: 20,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Section: Fitur Utama
            Row(
              children: [
                const Icon(
                  Icons.sports_esports_rounded,
                  size: 18,
                  color: AppColors.neonPink,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fitur Utama',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.neonPink.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    '2 Fitur Siap',
                    style: tt.labelSmall?.copyWith(
                      color: pinkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _ModuleCard(
              icon: Icons.sports_esports_rounded,
              accent: AppColors.neonPink,
              modulLabel: 'LIBRARY',
              title: 'Backlog & Catatan Game',
              description: 'Simpan catatan quest, review FPS, dan lokasi bermain.',
              chip1Icon: Icons.bookmark_outline_rounded,
              chip1Label: 'Catatan Offline',
              chip2Icon: Icons.videogame_asset_outlined,
              chip2Label: '$_noteCount Game Tersimpan',
              onTap: () => context.go('/catatan'),
            ),
            const SizedBox(height: 12),

            _ModuleCard(
              icon: Icons.map_outlined,
              accent: cyanText,
              modulLabel: 'RADAR',
              title: 'Spot Gaming & Peta',
              description:
                  'Cari warnet gaming, arena esports, dan jarak dari lokasimu.',
              chip1Icon: Icons.explore_outlined,
              chip1Label: 'Peta Interaktif',
              chip2Icon: Icons.location_on_outlined,
              chip2Label: 'Info Alamat',
              onTap: () => context.go('/lokasi'),
            ),
            const SizedBox(height: 22),

            // Status Aplikasi
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: cyanText,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status Aplikasi',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gpsGreen.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.gpsGreen.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'SIAP',
                    style: tt.labelSmall?.copyWith(
                      color: AppColors.gpsGreen,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: _DiagTile(
                          icon: Icons.bookmark_added_outlined,
                          iconColor: AppColors.neonPink,
                          label: 'PENYIMPANAN',
                          value: 'Siap',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DiagTile(
                          icon: Icons.near_me_outlined,
                          iconColor: cyanText,
                          label: 'LOKASI',
                          value: _gpsGranted ? 'Aktif' : 'Terbatas',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DiagTile(
                          icon: Icons.verified_outlined,
                          iconColor: cs.secondary,
                          label: 'VERSI',
                          value: '1.0.0',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.radar_rounded,
                          size: 16,
                          color: AppColors.neonPink,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Lokasi terdeteksi • Akurasi ±${_accuracy.toStringAsFixed(1)}m',
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: _copyCoords,
                          child: Icon(
                            Icons.copy_rounded,
                            size: 16,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _syncing ? null : () => _refreshTelemetry(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.onSurface,
                  backgroundColor: cs.surfaceContainerLow,
                  side: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.55),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.sync_rounded, color: AppColors.neonPink),
                label: const Text(
                  'Perbarui Lokasi & Data',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.icon,
    required this.accent,
    required this.modulLabel,
    required this.title,
    required this.description,
    required this.chip1Icon,
    required this.chip1Label,
    required this.chip2Icon,
    required this.chip2Label,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final String modulLabel;
  final String title;
  final String description;
  final IconData chip1Icon;
  final String chip1Label;
  final IconData chip2Icon;
  final String chip2Label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: accent.withValues(alpha: 0.4)),
                    ),
                    child: Icon(icon, color: accent, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                modulLabel,
                                style: tt.labelSmall?.copyWith(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  color: accent,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: cs.onSurfaceVariant,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _MiniBadge(
                    icon: chip1Icon,
                    label: chip1Label,
                    accent: accent,
                  ),
                  _MiniBadge(
                    icon: chip2Icon,
                    label: chip2Label,
                    accent: cs.tertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagTile extends StatelessWidget {
  const _DiagTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(height: 6),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              fontSize: 10,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
