import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Layanan GPS (Geolocator) dan reverse geocoding (OpenStreetMap Nominatim).
class LokasiService {
  LokasiService._();
  static final LokasiService instance = LokasiService._();

  // Default fallback coordinate (Bandung Center) saat emulator/browser belum mengirim fix GPS.
  static const double defaultLat = -6.91750;
  static const double defaultLng = 107.61910;

  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final ok = await ensurePermission();
      if (!ok) return null;
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  double hitungJarakMeter(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  String formatJarak(double meter) {
    if (meter < 5) {
      return '@ 0 m (di lokasi ini)';
    }
    if (meter < 1000) {
      return 'Jarak: ${meter.toStringAsFixed(0)} m';
    }
    return 'Jarak: ${(meter / 1000).toStringAsFixed(2)} km';
  }

  Future<String> reverseGeocode(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lng&accept-language=id',
      );
      final headers = <String, String>{
        if (!kIsWeb) 'User-Agent': 'AssociateMobileProgrammer/1.0',
      };
      final res = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
          return displayName;
        }
      }
    } catch (_) {
      // Fallback ketika offline atau Nominatim tidak terjangkau.
    }
    return 'Koordinat ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
  }
}
