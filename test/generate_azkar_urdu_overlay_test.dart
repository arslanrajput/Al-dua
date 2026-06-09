// Run: flutter test test/generate_azkar_urdu_overlay_test.dart
// Regenerates assets/azkar/urdu_overlay.json from muslim_data IDs + urdu_by_arabic.json

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import 'package:muslim_data_flutter/src/data/database/muslim_dao.dart';
import 'package:muslim_data_flutter/src/data/database/muslim_db.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate urdu overlay json', () async {
    final repo = MuslimRepository(
      dao: MuslimDao(db: MuslimDb(connection: _openTestConnection())),
    );
    final urduByArabic = await _loadUrduByArabicMap();
    final chapterEnToUr = await _loadChapterEnToUr();

    final categories = await repo.getAzkarCategories(language: Language.en);
    final overlayCategories = <String, String>{};
    final overlayChapters = <String, String>{};
    final overlayItems = <String, String>{};
    final overlayReferences = <String, String>{};

    for (final category in categories) {
      final urduCat = _categoryUrdu[category.id];
      if (urduCat != null) {
        overlayCategories['${category.id}'] = urduCat;
      }

      final chapters = await repo.getAzkarChapters(
        language: Language.en,
        categoryId: category.id,
      );
      for (final chapter in chapters) {
        final urduChapter =
            chapterEnToUr[chapter.name.trim().toLowerCase()] ??
                _fuzzyChapterUrdu(chapter.name);
        if (urduChapter != null && urduChapter.isNotEmpty) {
          overlayChapters['${chapter.id}'] = urduChapter;
        }

        final items = await repo.getAzkarItems(
          language: Language.en,
          chapterId: chapter.id,
        );
        for (final item in items) {
          final key = _normalizeArabic(item.item);
          final urdu = urduByArabic[key];
          if (urdu != null && urdu.isNotEmpty) {
            overlayItems['${item.id}'] = urdu;
          }
        }
      }
    }

    final output = {
      'categories': overlayCategories,
      'chapters': overlayChapters,
      'items': overlayItems,
      'references': overlayReferences,
      '_meta': {
        'source': 'assets/azkar/urdu_by_arabic.json',
        'categories': overlayCategories.length,
        'chapters': overlayChapters.length,
        'items': overlayItems.length,
        'references': overlayReferences.length,
      },
    };

    final outFile = File('assets/azkar/urdu_overlay.json');
    await outFile.parent.create(recursive: true);
    await outFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(output),
    );

    // ignore: avoid_print
    print(
      'Wrote ${outFile.path}: '
      '${overlayCategories.length} categories, '
      '${overlayChapters.length} chapters, '
      '${overlayItems.length} items',
    );

    expect(overlayCategories.length, 11);
    expect(overlayItems.isNotEmpty, isTrue);
  });
}

String _normalizeArabic(String text) {
  return text
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '')
      .replaceAll(RegExp(r'[﴿﴾«»()（）\[\]{}،.،؛:!؟\-–—\s\n\r\t*]+'), '')
      .replaceAll(',', '')
      .replaceAll('آ', 'ا')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('ٱ', 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
}

Future<Map<String, String>> _loadUrduByArabicMap() async {
  final raw = await rootBundle.loadString('assets/azkar/urdu_by_arabic.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return json.map(
    (k, v) => MapEntry(_normalizeArabic(k.toString()), v.toString()),
  );
}

Future<Map<String, String>> _loadChapterEnToUr() async {
  final raw = await rootBundle.loadString('assets/azkar/chapter_en_to_ur.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return json.map(
    (k, v) => MapEntry(k.toString().trim().toLowerCase(), v.toString()),
  );
}

String? _fuzzyChapterUrdu(String enName) {
  final lower = enName.toLowerCase();
  for (final entry in _chapterEnToUrFallback.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }
  return null;
}

LazyDatabase _openTestConnection() {
  return LazyDatabase(() async {
    final blob = await rootBundle.load(
      'packages/muslim_data_flutter/assets/db/muslim_db_v2.7.0.db',
    );
    final data = blob.buffer.asUint8List(
      blob.offsetInBytes,
      blob.lengthInBytes,
    );

    final tempFile = File('${Directory.systemTemp.path}/azkar_gen_db.db');
    await tempFile.writeAsBytes(data);

    final sqliteDb = sqlite3.openInMemory();
    sqliteDb.execute('ATTACH DATABASE ? AS file_db', [tempFile.path]);

    final tables = sqliteDb.select(
      "SELECT name FROM file_db.sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );
    for (final table in tables) {
      final tableName = table['name'] as String;
      sqliteDb.execute(
        'CREATE TABLE $tableName AS SELECT * FROM file_db.$tableName;',
      );
    }

    sqliteDb.execute('DETACH DATABASE file_db;');
    await tempFile.delete();

    return NativeDatabase.opened(sqliteDb);
  });
}

const Map<int, String> _categoryUrdu = {
  1: 'جب آپ جاگیں',
  2: 'لباس پہنتے وقت',
  3: 'وضو سے پہلے اور بعد',
  4: 'گھر سے نکلتے اور گھر میں داخل ہوتے وقت',
  5: 'مسجد سے متعلق',
  6: 'نماز سے متعلق',
  7: 'قرآن سے متعلق',
  8: 'سونے سے پہلے اور بعد',
  9: 'پریشانی اور مصیبت کے وقت',
  10: 'سفر اور دیگر مواقع',
  11: 'نبی کریم ﷺ کی فضیلت اور دیگر احکام',
};

const Map<String, String> _chapterEnToUrFallback = {
  'wake': 'جاگنے پر دعائیں',
  'dress': 'کپڑے پہنتے وقت',
  'clothes': 'نیا کپڑا پہنتے وقت',
  'restroom': 'بیت الخلا',
  'ablution': 'وضو',
  'leaving the home': 'گھر سے نکلتے وقت',
  'entering the home': 'گھر میں داخل ہوتے وقت',
  'mosque': 'مسجد',
  'athan': 'اذان',
  'prayer': 'نماز',
  'ruku': 'رکوع',
  'sujud': 'سجدہ',
  'sleep': 'سونے',
  'morning and evening': 'صبح و شام کے اذکار',
  'travel': 'سفر',
  'food': 'کھانا',
  'istikhara': 'استخارہ',
};
