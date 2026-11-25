/// Model data untuk catatan/backlog game PC Steam di SQLite lokal.
class Catatan {
  const Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.waktuBuat,
    this.lat,
    this.lng,
    this.status = 'PLAYING',
    this.spotName = 'PC Room / Home Rig',
    this.sessionTag = 'Gaming Session',
    this.coverAsset = 'assets/images/game_fps.jpg',
  });

  final int? id;
  final String judul;
  final String isi;
  final String waktuBuat;
  final double? lat;
  final double? lng;
  final String status;
  final String spotName;
  final String sessionTag;
  final String coverAsset;

  bool get hasLocation => lat != null && lng != null;

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'judul': judul,
      'isi': isi,
      'waktu_buat': waktuBuat,
      'lat': lat,
      'lng': lng,
      'status': status,
      'spot_name': spotName,
      'session_tag': sessionTag,
      'cover_asset': coverAsset,
    };
  }

  factory Catatan.fromMap(Map<String, Object?> map) {
    return Catatan(
      id: map['id'] as int?,
      judul: (map['judul'] as String?) ?? '',
      isi: (map['isi'] as String?) ?? '',
      waktuBuat: (map['waktu_buat'] as String?) ?? '',
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
      status: (map['status'] as String?) ?? 'PLAYING',
      spotName: (map['spot_name'] as String?) ?? 'PC Room / Home Rig',
      sessionTag: (map['session_tag'] as String?) ?? 'Gaming Session',
      coverAsset:
          (map['cover_asset'] as String?) ?? 'assets/images/game_fps.jpg',
    );
  }
}
