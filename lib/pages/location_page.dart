import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/lokasi_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_shell.dart';

class _GamingSpot {
  const _GamingSpot({
    required this.name,
    required this.shortName,
    required this.area,
    required this.lat,
    required this.lng,
    required this.pcCount,
    required this.rate,
    required this.specs,
    required this.accent,
  });

  final String name;
  final String shortName;
  final String area;
  final double lat;
  final double lng;
  final int pcCount;
  final String rate;
  final List<String> specs;
  final Color accent;
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MapController _mapCtrl = MapController();

  double _lat = LokasiService.defaultLat;
  double _lng = LokasiService.defaultLng;
  double _zoom = 14.2;
  String _nominatimAddress = 'Memuat alamat dari OSM Nominatim...';
  int _selectedSpotIndex = 0;
  bool _loading = false;

  static const List<_GamingSpot> _spots = [
    _GamingSpot(
      name: 'CyberZone Esports Arena & PC Lounge',
      shortName: 'CyberZone LAN',
      area: 'Sumur Bandung',
      lat: -6.91750,
      lng: 107.61910,
      pcCount: 12,
      rate: 'Buka 24 Jam • Tarif: Rp 8.000 / Jam • High-End Rig',
      specs: [
        'RTX 4070 Ti',
        '240Hz Monitor',
        'Private VIP Room',
        'Gigabit LAN Fiber',
        'Snack & Coffee Bar',
      ],
      accent: AppColors.gpsGreen,
    ),
    _GamingSpot(
      name: 'Level 9 Esports Arena',
      shortName: 'Level 9 Esports',
      area: 'Dago Bawah',
      lat: -6.90248,
      lng: 107.61869,
      pcCount: 6,
      rate: 'Buka 24 Jam • Tarif: Rp 10.000 / Jam • RTX 4080 VIP',
      specs: ['RTX 4080', '240Hz OLED', 'Bootcamp Room', 'Fiber 1Gbps'],
      accent: AppColors.laserCyan,
    ),
    _GamingSpot(
      name: 'BattleStation Cafe & LAN',
      shortName: 'BattleStation',
      area: 'Riau Area',
      lat: -6.90920,
      lng: 107.61350,
      pcCount: 9,
      rate: '09:00 - 02:00 • Tarif: Rp 12.000 / Jam • ROG Lounge',
      specs: ['RTX 4070', '165Hz IPS', 'Snack & PC', 'Discord Booth'],
      accent: AppColors.neonPink,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _updatePosition(silent: true);
  }

  Future<void> _updatePosition({bool silent = false}) async {
    setState(() => _loading = true);
    final pos = await LokasiService.instance.getCurrentPosition();
    if (!mounted) return;
    if (pos != null) {
      _lat = pos.latitude;
      _lng = pos.longitude;
      _mapCtrl.move(LatLng(_lat, _lng), _zoom);
    }

    final addr = await LokasiService.instance.reverseGeocode(_lat, _lng);
    if (!mounted) return;
    setState(() {
      _nominatimAddress = addr;
      _loading = false;
    });

    if (!silent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Radar Spot Gaming & posisi GPS diperbarui.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _selectSpot(int index) {
    final spot = _spots[index];
    setState(() => _selectedSpotIndex = index);
    _mapCtrl.move(LatLng(spot.lat, spot.lng), _zoom);
  }

  void _copyCoords(_GamingSpot spot) {
    final text = '${spot.lat.toStringAsFixed(5)}, ${spot.lng.toStringAsFixed(5)}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Koordinat ${spot.shortName} disalin: $text'),
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
    final userCenter = LatLng(_lat, _lng);
    final selectedSpot = _spots[_selectedSpotIndex];
    final distanceMeters = LokasiService.instance.hitungJarakMeter(
      _lat,
      _lng,
      selectedSpot.lat,
      selectedSpot.lng,
    );
    final distanceText = distanceMeters < 50
        ? '0 m (di lokasimu)'
        : '${(distanceMeters / 1000).toStringAsFixed(1)} km dari lokasimu';

    return Scaffold(
      appBar: const AppHeader(
        title: 'Radar Spot Warnet',
        subtitle: 'MARKAS GAMER • RADAR SPOT',
      ),
      body: Column(
        children: [
          // Top Interactive Map
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapCtrl,
                  options: MapOptions(
                    initialCenter: userCenter,
                    initialZoom: _zoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.modul_1_application',
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: userCenter,
                          radius: 42,
                          color: AppColors.neonPink.withValues(alpha: 0.16),
                          borderColor: AppColors.neonPink.withValues(
                            alpha: 0.55,
                          ),
                          borderStrokeWidth: 1.5,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: userCenter,
                          width: 44,
                          height: 44,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neonPink,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonPink.withValues(
                                    alpha: 0.6,
                                  ),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.sports_esports_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        ...List.generate(_spots.length, (i) {
                          final s = _spots[i];
                          final isSel = i == _selectedSpotIndex;
                          return Marker(
                            point: LatLng(s.lat, s.lng),
                            width: 36,
                            height: 36,
                            child: GestureDetector(
                              onTap: () => _selectSpot(i),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: isSel ? AppColors.laserCyan : s.accent,
                                size: isSel ? 36 : 28,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),

                // Top-left floating gaming zone & active spot pill
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.canvas.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.gpsGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${selectedSpot.shortName} • ${selectedSpot.pcCount} PC',
                          style: tt.labelSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top-right recenter button
                Positioned(
                  top: 12,
                  right: 12,
                  child: _MapIconBtn(
                    icon: Icons.my_location_rounded,
                    onTap: () => _mapCtrl.move(userCenter, _zoom),
                  ),
                ),

                // Right-side Zoom + / -
                Positioned(
                  right: 12,
                  bottom: 14,
                  child: Column(
                    children: [
                      _MapIconBtn(
                        icon: Icons.add_rounded,
                        onTap: () {
                          _zoom = (_zoom + 1).clamp(3.0, 18.0);
                          _mapCtrl.move(
                            LatLng(selectedSpot.lat, selectedSpot.lng),
                            _zoom,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _MapIconBtn(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          _zoom = (_zoom - 1).clamp(3.0, 18.0);
                          _mapCtrl.move(
                            LatLng(selectedSpot.lat, selectedSpot.lng),
                            _zoom,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Radar Spot Sheet
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Radar status & ping row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gpsGreen.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.gpsGreen.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.gpsGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Radar Aktif (${_spots.length} Spot)',
                                  style: tt.labelSmall?.copyWith(
                                    color: AppColors.gpsGreen,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: cyanText.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: cyanText.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          'Koneksi Stabil',
                          style: tt.labelSmall?.copyWith(
                            color: cyanText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Featured Nearest Spot Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.neonPink.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: AppColors.neonPink,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'SPOT UTAMA TERDEKAT',
                                style: tt.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: pinkText,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gpsGreen.withValues(
                                  alpha: 0.16,
                                ),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppColors.gpsGreen.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Text(
                                '${selectedSpot.pcCount} PC Tersedia',
                                style: tt.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: AppColors.gpsGreen,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedSpot.name,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_nominatimAddress • $distanceText',
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedSpot.rate,
                          style: tt.labelSmall?.copyWith(
                            color: cyanText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: selectedSpot.specs
                              .map(
                                (spec) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cs.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: cs.outlineVariant.withValues(
                                        alpha: 0.45,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    spec,
                                    style: tt.labelSmall?.copyWith(
                                      fontSize: 10,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _copyCoords(selectedSpot),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.neonPink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: const StadiumBorder(),
                            ),
                            icon: const Icon(Icons.directions_rounded, size: 18),
                            label: const Text(
                              'Petunjuk Arah ke Arena',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Spot Alternatif Terdekat
                  Text(
                    'SPOT ALTERNATIF TERDEKAT',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _spots.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final s = _spots[i];
                        final isSel = i == _selectedSpotIndex;
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _selectSpot(i),
                          child: Container(
                            width: 190,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSel
                                    ? AppColors.neonPink
                                    : cs.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        s.shortName,
                                        style: tt.labelMedium?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${s.pcCount} PC',
                                      style: tt.labelSmall?.copyWith(
                                        color: s.accent,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  s.area,
                                  style: tt.labelSmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: _loading ? null : () => _updatePosition(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.onSurface,
                      backgroundColor: cs.surfaceContainerLow,
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const StadiumBorder(),
                    ),
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.neonPink,
                            ),
                          )
                        : const Icon(
                            Icons.radar_rounded,
                            size: 18,
                            color: AppColors.neonPink,
                          ),
                    label: const Text(
                      'Perbarui Radar Spot',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}

class _MapIconBtn extends StatelessWidget {
  const _MapIconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.canvas.withValues(alpha: 0.9),
      shape: const CircleBorder(side: BorderSide(color: AppColors.glassBorder)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
