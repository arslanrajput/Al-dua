import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../widget/azkar_language.dart';
import 'azkar_urdu_overlay.dart';

class AzkarRepository {
  AzkarRepository({MuslimRepository? repo}) : _repo = repo ?? MuslimRepository();

  final MuslimRepository _repo;

  Future<List<AzkarCategory>> getCategories({
    required AzkarLanguage language,
  }) async {
    if (language == AzkarLanguage.ur) {
      return _getUrduCategories();
    }
    return _repo.getAzkarCategories(language: language.packageLanguage!);
  }

  Future<List<AzkarChapter>> getChapters({
    required AzkarLanguage language,
    required int categoryId,
  }) async {
    if (language == AzkarLanguage.ur) {
      return _getUrduChapters(categoryId);
    }
    return _repo.getAzkarChapters(
      language: language.packageLanguage!,
      categoryId: categoryId,
    );
  }

  Future<List<AzkarItem>> getItems({
    required AzkarLanguage language,
    required int chapterId,
  }) async {
    if (language == AzkarLanguage.ur) {
      return _getUrduItems(chapterId);
    }
    return _repo.getAzkarItems(
      language: language.packageLanguage!,
      chapterId: chapterId,
    );
  }

  Future<List<AzkarCategory>> _getUrduCategories() async {
    final overlay = await AzkarUrduOverlay.load();
    final english = await _repo.getAzkarCategories(language: Language.en);
    return english.map(overlay.applyCategory).toList();
  }

  Future<List<AzkarChapter>> _getUrduChapters(int categoryId) async {
    final overlay = await AzkarUrduOverlay.load();
    final english = await _repo.getAzkarChapters(
      language: Language.en,
      categoryId: categoryId,
    );
    return english.map(overlay.applyChapter).toList();
  }

  Future<List<AzkarItem>> _getUrduItems(int chapterId) async {
    final overlay = await AzkarUrduOverlay.load();
    final english = await _repo.getAzkarItems(
      language: Language.en,
      chapterId: chapterId,
    );
    return english.map(overlay.applyItem).toList();
  }
}
