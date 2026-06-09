import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

/// Bundled Urdu translations keyed by muslim_data azkar IDs.
class AzkarUrduOverlay {
  AzkarUrduOverlay._();

  static const _assetPath = 'assets/azkar/urdu_overlay.json';

  static AzkarUrduOverlayData? _cache;

  static Future<AzkarUrduOverlayData> load() async {
    _cache ??= AzkarUrduOverlayData.fromJson(
      jsonDecode(await rootBundle.loadString(_assetPath)) as Map<String, dynamic>,
    );
    return _cache!;
  }
}

class AzkarUrduOverlayData {
  const AzkarUrduOverlayData({
    required this.categories,
    required this.chapters,
    required this.items,
    required this.references,
  });

  final Map<int, String> categories;
  final Map<int, String> chapters;
  final Map<int, String> items;
  final Map<int, String> references;

  factory AzkarUrduOverlayData.fromJson(Map<String, dynamic> json) {
    Map<int, String> parseMap(String key) {
      final raw = json[key];
      if (raw is! Map) return {};
      return raw.map(
        (k, v) => MapEntry(int.parse(k.toString()), v.toString()),
      );
    }

    return AzkarUrduOverlayData(
      categories: parseMap('categories'),
      chapters: parseMap('chapters'),
      items: parseMap('items'),
      references: parseMap('references'),
    );
  }

  AzkarCategory applyCategory(AzkarCategory category) {
    final urdu = categories[category.id];
    if (urdu == null || urdu.isEmpty) return category;
    return AzkarCategory(id: category.id, name: urdu);
  }

  AzkarChapter applyChapter(AzkarChapter chapter) {
    final urdu = chapters[chapter.id];
    if (urdu == null || urdu.isEmpty) return chapter;
    return AzkarChapter(
      id: chapter.id,
      categoryId: chapter.categoryId,
      categoryName: chapter.categoryName,
      name: urdu,
    );
  }

  AzkarItem applyItem(AzkarItem item) {
    final urduTranslation = items[item.id] ?? '';
    final urduReference = references[item.id];
    return AzkarItem(
      id: item.id,
      chapterId: item.chapterId,
      item: item.item,
      translation: urduTranslation,
      reference: urduReference ?? item.reference,
    );
  }
}
