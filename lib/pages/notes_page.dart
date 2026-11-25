import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/catatan.dart';
import '../services/catatan_db.dart';
import '../services/lokasi_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_shell.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Catatan> _items = [];
  bool _loading = true;
  double _currentLat = LokasiService.defaultLat;
  double _currentLng = LokasiService.defaultLng;
  String _areaLabel = 'Bandung, Jawa Barat';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final notes = await CatatanDb.instance.getAll();
      if (!mounted) return;
      setState(() {
        _items = notes;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
    _refreshPosition();
  }

  Future<void> _refreshPosition() async {
    final pos = await LokasiService.instance.getCurrentPosition();
    if (!mounted || pos == null) return;
    setState(() {
      _currentLat = pos.latitude;
      _currentLng = pos.longitude;
    });
    final addr = await LokasiService.instance.reverseGeocode(
      pos.latitude,
      pos.longitude,
    );
    if (!mounted) return;
    final parts = addr.split(',').map((e) => e.trim()).toList();
    setState(() {
      _areaLabel = parts.length >= 2 ? '${parts[0]}, ${parts[1]}' : addr;
    });
  }

  Future<void> _deleteItem(Catatan item) async {
    if (item.id == null) return;
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.delete_outline_rounded, color: cs.error),
        title: const Text('Hapus Catatan Game?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${item.judul}" dari library? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.neonPink,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await CatatanDb.instance.delete(item.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catatan "${item.judul}" dihapus.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _loadAll();
  }

  void _openSearchDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController(text: _searchQuery);
        return AlertDialog(
          title: const Text('Cari Game / Catatan'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Ketik judul game atau catatan...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _searchQuery = '');
                Navigator.pop(ctx);
              },
              child: const Text('Reset'),
            ),
            FilledButton(
              onPressed: () {
                setState(() => _searchQuery = ctrl.text.trim());
                Navigator.pop(ctx);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.neonPink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cari'),
            ),
          ],
        );
      },
    );
  }

  String _formatWaktu(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(dt.year, dt.month, dt.day);
    final diffDays = today.difference(dateOnly).inDays;

    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    if (diffDays == 0) return 'Hari ini • $hh:$mm WIB';
    if (diffDays == 1) return 'Kemarin • $hh:$mm WIB';
    return '$diffDays hari lalu';
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PLAYING':
        return AppColors.gpsGreen;
      case 'BACKLOG':
        return AppColors.laserCyan;
      case 'COMPLETED':
        return AppColors.synthPurpleSoft;
      default:
        return AppColors.neonPink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pinkText = isDark ? AppColors.neonPinkSoft : cs.primary;
    final cyanText = isDark ? AppColors.laserCyan : cs.tertiary;

    final filtered = _searchQuery.isEmpty
        ? _items
        : _items
              .where(
                (n) =>
                    n.judul.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    n.isi.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    return Scaffold(
      appBar: AppHeader(
        title: 'Catatan',
        subtitle: 'MARKAS GAMER',
        onSearchTap: _openSearchDialog,
      ),
      body: RefreshIndicator(
        onRefresh: _loadAll,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 96),
          children: [
            // Spot Mabar Aktif Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonPink.withValues(alpha: isDark ? 0.16 : 0.08),
                    cs.surfaceContainerLow,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.neonPink.withValues(alpha: 0.28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      Text(
                        'SPOT MABAR AKTIF',
                        style: tt.labelSmall?.copyWith(
                          color: pinkText,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cyanText.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: cyanText.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          'LIVE RADAR',
                          style: tt.labelSmall?.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            color: cyanText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Arena Gaming & Spot Mabar',
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me_outlined,
                        size: 14,
                        color: AppColors.neonPink,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _areaLabel,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sports_esports_outlined,
                          size: 16,
                          color: AppColors.neonPink,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Esports Hub & Game Center',
                            style: tt.labelMedium?.copyWith(
                              color: cs.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => context.go('/lokasi'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.neonPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          icon: const Icon(Icons.radar_rounded, size: 15),
                          label: const Text(
                            'Cari Spot',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Daftar Tersimpan Header
            Row(
              children: [
                Text(
                  'Daftar Tersimpan',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${filtered.length}',
                    style: tt.labelSmall?.copyWith(
                      color: pinkText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
                      Icon(
                        Icons.bookmark_outline_rounded,
                        size: 13,
                        color: cyanText,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Offline Library',
                        style: tt.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.neonPink),
                ),
              )
            else if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    'Belum ada catatan game tersimpan.',
                    style: tt.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...filtered.map((item) {
                final statusColor = _statusColor(item.status);
                String rightBadge = item.sessionTag;
                if (item.hasLocation) {
                  final meters = LokasiService.instance.hitungJarakMeter(
                    _currentLat,
                    _currentLng,
                    item.lat!,
                    item.lng!,
                  );
                  rightBadge =
                      '${item.sessionTag} • ${LokasiService.instance.formatJarak(meters).replaceFirst('Jarak: ', '')}';
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Game Cover Banner
                        SizedBox(
                          height: 112,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                item.coverAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: AppColors.cardHigh,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.canvas.withValues(alpha: 0.55),
                                      Colors.transparent,
                                      AppColors.cardLow.withValues(alpha: 0.95),
                                    ],
                                    stops: const [0.0, 0.45, 1.0],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 12,
                                right: 10,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.canvas.withValues(
                                          alpha: 0.82,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: statusColor.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            item.status,
                                            style: tt.labelSmall?.copyWith(
                                              color: statusColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _formatWaktu(item.waktuBuat),
                                        style: tt.labelSmall?.copyWith(
                                          color: AppColors.textPrimary,
                                          shadows: const [
                                            Shadow(
                                              blurRadius: 6,
                                              color: Colors.black87,
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Material(
                                      color: AppColors.canvas.withValues(
                                        alpha: 0.78,
                                      ),
                                      shape: const CircleBorder(),
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        onTap: () => _deleteItem(item),
                                        child: const Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.neonPinkSoft,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.judul,
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item.isi,
                                style: tt.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: cs.outlineVariant.withValues(
                                      alpha: 0.45,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      item.hasLocation
                                          ? Icons.location_on_outlined
                                          : Icons.home_outlined,
                                      size: 16,
                                      color: item.hasLocation
                                          ? AppColors.neonPink
                                          : cs.secondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.spotName,
                                        style: tt.labelSmall?.copyWith(
                                          color: cs.onSurface,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(
                                          alpha: 0.14,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: statusColor.withValues(
                                            alpha: 0.35,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        rightBadge,
                                        style: tt.labelSmall?.copyWith(
                                          fontFamily: 'monospace',
                                          fontSize: 10,
                                          color: statusColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await context.push<bool>('/catatan/baru');
          if (created == true) {
            _loadAll();
          }
        },
        backgroundColor: AppColors.neonPink,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Catatan Game',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
