import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import 'package:muslim_data_flutter/src/data/database/muslim_dao.dart';
import 'package:muslim_data_flutter/src/data/database/muslim_db.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('debug arabic keys', () async {
    final repo = MuslimRepository(
      dao: MuslimDao(db: MuslimDb(connection: _openTestConnection())),
    );
    final raw = await rootBundle.loadString('assets/azkar/urdu_by_arabic.json');
    final map = (jsonDecode(raw) as Map).map((k, v) => MapEntry(k.toString(), v.toString()));

    final items = await repo.getAzkarItems(language: Language.en, chapterId: 1);
    var matched = 0;
    for (final item in items.take(15)) {
      final key = _normalizeArabic(item.item);
      final hit = map.containsKey(key);
      if (hit) matched++;
      // ignore: avoid_print
      print('HIT=$hit | KEY=$key | RAW=${item.item.substring(0, item.item.length.clamp(0, 60))}');
    }
    // ignore: avoid_print
    print('matched $matched / ${items.length} in chapter 1');
  });
}

String _normalizeArabic(String text) {
  return text
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '')
      .replaceAll(RegExp(r'[﴿﴾«»()（）\[\]{}،.،؛:!؟\-–—\s\n\r\t*]+'), '')
      .replaceAll('آ', 'ا')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('ٱ', 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
}

LazyDatabase _openTestConnection() {
  return LazyDatabase(() async {
    final blob = await rootBundle.load(
      'packages/muslim_data_flutter/assets/db/muslim_db_v2.7.0.db',
    );
    final data = blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes);
    final tempFile = File('${Directory.systemTemp.path}/azkar_dbg_db.db');
    await tempFile.writeAsBytes(data);
    final sqliteDb = sqlite3.openInMemory();
    sqliteDb.execute('ATTACH DATABASE ? AS file_db', [tempFile.path]);
    final tables = sqliteDb.select(
      "SELECT name FROM file_db.sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );
    for (final table in tables) {
      final tableName = table['name'] as String;
      sqliteDb.execute('CREATE TABLE $tableName AS SELECT * FROM file_db.$tableName;');
    }
    sqliteDb.execute('DETACH DATABASE file_db;');
    await tempFile.delete();
    return NativeDatabase.opened(sqliteDb);
  });
}
