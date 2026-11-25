import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/catatan.dart';
import '../services/catatan_db.dart';
import '../services/lokasi_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class _CoverOption {
  const _CoverOption(this.label, this.assetPath);
  final String label;
  final String assetPath;
}

class NoteFormPage extends StatefulWidget {
  const NoteFormPage({super.key});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _spotCtrl = TextEditingController();
  final _latCtrl = TextEditingController(
    text: LokasiService.defaultLat.toStringAsFixed(5),
  );
  final _lngCtrl = TextEditingController(
    text: LokasiService.defaultLng.toStringAsFixed(5),
  );

  static const List<_CoverOption> _covers = [
    _CoverOption('FPS / Esports', 'assets/images/game_fps.jpg'),
    _CoverOption('RPG Fantasy', 'assets/images/game_rpg.jpg'),
    _CoverOption('Cyberpunk', 'assets/images/game_cyber.jpg'),
    _CoverOption('Synthwave', 'assets/images/hero_synthwave.jpg'),
  ];

  String _selectedStatus = 'PLAYING';
  String _selectedCover = _covers.first.assetPath;
  bool _manualLocation = false;
  bool _attachLocation = true;

  double _lat = LokasiService.defaultLat;
  double _lng = LokasiService.defaultLng;
  double _accuracy = 4.5;
  double _altitude = 768;
  bool _fetchingLocation = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _judulCtrl.addListener(() => setState(() {}));
    _isiCtrl.addListener(() => setState(() {}));
    _ambilLokasi(silent: true);
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _spotCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  Future<void> _ambilLokasi({bool silent = false}) async {
    setState(() => _fetchingLocation = true);
    final pos = await LokasiService.instance.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      if (pos != null) {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _accuracy = pos.accuracy;
        if (pos.altitude != 0) {
          _altitude = pos.altitude;
        }
        _latCtrl.text = _lat.toStringAsFixed(5);
        _lngCtrl.text = _lng.toStringAsFixed(5);
      }
      _fetchingLocation = false;
    });
    if (!silent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            pos != null
                ? 'Lokasi bermain berhasil diperbarui!'
                : 'Menggunakan koordinat default (lokasi perangkat tidak tersedia).',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final tag = switch (_selectedStatus) {
        'PLAYING' => 'Sedang Mabar',
        'BACKLOG' => 'Spot Mabar LAN',
        _ => 'Solo Session',
      };

      double? finalLat;
      double? finalLng;
      if (_attachLocation) {
        if (_manualLocation) {
          finalLat = double.tryParse(_latCtrl.text.trim()) ?? _lat;
          finalLng = double.tryParse(_lngCtrl.text.trim()) ?? _lng;
        } else {
          finalLat = _lat;
          finalLng = _lng;
        }
      }

      final spotInput = _spotCtrl.text.trim();
      final spotName = spotInput.isNotEmpty
          ? spotInput
          : (_attachLocation ? 'Spot Gaming / Warnet' : 'Setup Home Battlestation');

      final catatan = Catatan(
        judul: _judulCtrl.text.trim(),
        isi: _isiCtrl.text.trim(),
        waktuBuat: DateTime.now().toIso8601String(),
        lat: finalLat,
        lng: finalLng,
        status: _selectedStatus,
        spotName: spotName,
        sessionTag: tag,
        coverAsset: _selectedCover,
      );
      await CatatanDb.instance.insert(catatan);
      if (!mounted) return;
      if (context.canPop()) {
        context.pop(true);
      } else {
        context.go('/catatan');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pinkText = isDark ? AppColors.neonPinkSoft : cs.primary;
    final cyanText = isDark ? AppColors.laserCyan : cs.tertiary;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Catatan Game Baru',
        subtitle: 'MARKAS GAMER',
        showBack: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          children: [
            // Top step & location badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sports_esports_rounded,
                    size: 15,
                    color: AppColors.neonPink,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'MARKAS GAMER • SESI BERMAIN',
                    style: tt.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                      color: AppColors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.laserCyan.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.laserCyan.withValues(alpha: 0.4),
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
                        'LOKASI AKTIF',
                        style: tt.labelSmall?.copyWith(
                          color: AppColors.laserCyan,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status Selector
            Wrap(
              spacing: 8,
              children: ['PLAYING', 'BACKLOG', 'COMPLETED'].map((st) {
                final selected = _selectedStatus == st;
                return ChoiceChip(
                  label: Text(st),
                  selected: selected,
                  selectedColor: AppColors.neonPink,
                  backgroundColor: cs.surfaceContainerLow,
                  side: BorderSide(
                    color: selected
                        ? AppColors.neonPink
                        : cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                  labelStyle: tt.labelSmall?.copyWith(
                    color: selected ? Colors.white : cs.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                  onSelected: (_) => setState(() => _selectedStatus = st),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Cover Game Picker
            Text(
              'Pilih Gambar Cover Game',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _covers.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final c = _covers[i];
                  final isSel = _selectedCover == c.assetPath;
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => _selectedCover = c.assetPath),
                    child: Container(
                      width: 118,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel
                              ? AppColors.neonPink
                              : AppColors.glassBorder,
                          width: isSel ? 2.2 : 1,
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(c.assetPath, fit: BoxFit.cover),
                          Container(
                            color: AppColors.canvas.withValues(
                              alpha: isSel ? 0.2 : 0.45,
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 8,
                            bottom: 6,
                            child: Text(
                              c.label,
                              style: tt.labelSmall?.copyWith(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Judul Game / Sesi Mabar
            Row(
              children: [
                Text(
                  'Judul Game / Sesi Mabar',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '${_judulCtrl.text.length}/60',
                  style: tt.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _judulCtrl,
              maxLength: 60,
              decoration: const InputDecoration(
                hintText: "Misal: Baldur's Gate 3 - Act 2",
                counterText: '',
              ),
              validator: (val) {
                if (val == null || val.trim().length < 3) {
                  return 'Minimal 3 karakter ya';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Review / Catatan Quest & Performa
            Row(
              children: [
                Text(
                  'Review / Catatan Quest & Performa',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '${_isiCtrl.text.length}/500',
                  style: tt.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText:
                    'Tuliskan catatan quest, performa FPS, atau keseruan mabar...',
                counterText: '',
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Catatan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Info Lokasi Spot Mabar Card (Live atau Input Manual)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.neonPink.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: AppColors.neonPink.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.neonPink,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Info Lokasi Spot Mabar',
                              style: tt.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'TITIK LOKASI BERMAIN',
                              style: tt.labelSmall?.copyWith(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _attachLocation,
                        activeThumbColor: AppColors.neonPink,
                        onChanged: (v) => setState(() => _attachLocation = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama Warnet / Spot Input
                  TextFormField(
                    controller: _spotCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama Warnet / Tempat Bermain',
                      hintText: 'Misal: Warnet Level 9 / Rumah',
                      prefixIcon: Icon(Icons.storefront_outlined, size: 18),
                    ),
                  ),

                  if (_attachLocation) ...[
                    const SizedBox(height: 12),
                    // Toggle Live Location vs Input Manual
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Lokasi Live')),
                            selected: !_manualLocation,
                            selectedColor: AppColors.neonPink,
                            backgroundColor: cs.surfaceContainerLowest,
                            labelStyle: tt.labelSmall?.copyWith(
                              color: !_manualLocation
                                  ? Colors.white
                                  : cs.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                            onSelected: (_) =>
                                setState(() => _manualLocation = false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Input Manual')),
                            selected: _manualLocation,
                            selectedColor: cyanText,
                            backgroundColor: cs.surfaceContainerLowest,
                            labelStyle: tt.labelSmall?.copyWith(
                              color: _manualLocation
                                  ? cs.onTertiary
                                  : cs.onSurfaceVariant,
                              fontWeight: FontWeight.w800,
                            ),
                            onSelected: (_) =>
                                setState(() => _manualLocation = true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_manualLocation) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _latCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    signed: true,
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Latitude',
                                hintText: '-6.91750',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _lngCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    signed: true,
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Longitude',
                                hintText: '107.61910',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cs.outlineVariant.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'KOORDINAT SPOT BERMAIN',
                                    style: tt.labelSmall?.copyWith(
                                      fontSize: 10,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 14,
                                  color: cyanText,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Terhubung',
                                  style: tt.labelSmall?.copyWith(
                                    color: cyanText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_lat.toStringAsFixed(6)}, ${_lng.toStringAsFixed(6)}',
                              style: tt.titleMedium?.copyWith(
                                fontFamily: 'monospace',
                                color: AppColors.neonPink,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.gps_fixed_rounded,
                                  size: 13,
                                  color: cyanText,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Akurasi ± ${_accuracy.toStringAsFixed(1)} meter',
                                    style: tt.labelSmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${_altitude.round()} mdpl',
                                  style: tt.labelSmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: pinkText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _fetchingLocation
                              ? null
                              : () => _ambilLokasi(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: pinkText,
                            side: BorderSide(
                              color: AppColors.neonPink.withValues(alpha: 0.45),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const StadiumBorder(),
                          ),
                          icon: _fetchingLocation
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.neonPink,
                                  ),
                                )
                              : const Icon(
                                  Icons.my_location_rounded,
                                  size: 18,
                                  color: AppColors.neonPink,
                                ),
                          label: const Text(
                            'Ambil Lokasi Saat Ini',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Simpan ke Library CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _simpan,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.neonPink,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text(
                  'Simpan ke Library',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
