import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/catatan.dart';

/// Repository SQLite lokal (`db_steam_v1.db`) untuk operasi CRUD catatan game Steam.
/// Pada platform Web (atau saat sqflite tidak tersedia), otomatis memakai penyimpanan memori.
class CatatanDb {
  CatatanDb._();
  static final CatatanDb instance = CatatanDb._();

  static const String dbName = 'db_steam_v1.db';
  static const String _table = 'catatan';

  Database? _db;
  List<Catatan>? _memoryStore;
  int _nextMemoryId = 4;

  List<Catatan> _createSeedItems() {
    final now = DateTime.now();
    return [
      Catatan(
        id: 1,
        judul: 'Elden Ring: Shadow of the Erdtree',
        isi:
            'Progress boss Messmer, frame rate stabil 90 FPS di setting High tanpa stutter.',
        waktuBuat: DateTime(
          now.year,
          now.month,
          now.day,
          20,
          15,
        ).toIso8601String(),
        lat: -6.91750,
        lng: 107.61910,
        status: 'PLAYING',
        spotName: 'PC Room VIP #04 (Rig RTX 4070)',
        sessionTag: 'Sedang Mabar',
        coverAsset: 'assets/images/game_rpg.jpg',
      ),
      Catatan(
        id: 2,
        judul: 'Cyberpunk 2077: Phantom Liberty',
        isi:
            'Siap dimainkan weekend bareng squad di spot LAN warnet esports. Ray tracing overdrive tested 75 FPS.',
        waktuBuat: now.subtract(const Duration(days: 1)).toIso8601String(),
        lat: -6.90248,
        lng: 107.61869,
        status: 'BACKLOG',
        spotName: 'Warnet Level 9 Esports Arena',
        sessionTag: 'Spot Mabar LAN',
        coverAsset: 'assets/images/game_cyber.jpg',
      ),
      Catatan(
        id: 3,
        judul: 'Counter-Strike 2',
        isi:
            'Review aim training & setup crosshair monitor 144Hz. Win streak 5 match Premier mode.',
        waktuBuat: now.subtract(const Duration(days: 3)).toIso8601String(),
        status: 'COMPLETED',
        spotName: 'Setup Home Battlestation',
        sessionTag: 'Solo Session',
        coverAsset: 'assets/images/game_fps.jpg',
      ),
    ];
  }

  List<Catatan> _ensureMemoryStore() {
    return _memoryStore ??= _createSeedItems();
  }

  Future<Database?> _getDbOrNull() async {
    if (kIsWeb) return null;
    if (_db != null) return _db!;
    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, dbName);
      _db = await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_table (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              judul TEXT NOT NULL,
              isi TEXT NOT NULL,
              waktu_buat TEXT NOT NULL,
              lat REAL,
              lng REAL,
              status TEXT NOT NULL DEFAULT 'PLAYING',
              spot_name TEXT NOT NULL DEFAULT 'PC Room / Home Rig',
              session_tag TEXT NOT NULL DEFAULT 'Gaming Session',
              cover_asset TEXT NOT NULL DEFAULT 'assets/images/game_fps.jpg'
            )
          ''');
          for (final item in _createSeedItems().reversed) {
            await db.insert(_table, item.toMap()..remove('id'));
          }
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
              "ALTER TABLE $_table ADD COLUMN cover_asset TEXT NOT NULL DEFAULT 'assets/images/game_fps.jpg'",
            );
          }
        },
      );
      return _db;
    } catch (_) {
      return null;
    }
  }

  Future<List<Catatan>> getAll() async {
    final db = await _getDbOrNull();
    if (db == null) {
      return List<Catatan>.from(_ensureMemoryStore());
    }
    final rows = await db.query(_table, orderBy: 'id DESC');
    return rows.map(Catatan.fromMap).toList();
  }

  Future<int> insert(Catatan catatan) async {
    final db = await _getDbOrNull();
    if (db == null) {
      final store = _ensureMemoryStore();
      final id = _nextMemoryId++;
      store.insert(
        0,
        Catatan(
          id: id,
          judul: catatan.judul,
          isi: catatan.isi,
          waktuBuat: catatan.waktuBuat,
          lat: catatan.lat,
          lng: catatan.lng,
          status: catatan.status,
          spotName: catatan.spotName,
          sessionTag: catatan.sessionTag,
          coverAsset: catatan.coverAsset,
        ),
      );
      return id;
    }
    return db.insert(_table, catatan.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _getDbOrNull();
    if (db == null) {
      final store = _ensureMemoryStore();
      final before = store.length;
      store.removeWhere((item) => item.id == id);
      return before - store.length;
    }
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final db = await _getDbOrNull();
    if (db == null) {
      return _ensureMemoryStore().length;
    }
    final res = await db.rawQuery('SELECT COUNT(*) as total FROM $_table');
    return Sqflite.firstIntValue(res) ?? 0;
  }
}
