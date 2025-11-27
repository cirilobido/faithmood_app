import 'package:selah_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/tag_repository.dart';
import '../data_sources/remote/tag_service.dart';
import '../data_sources/local/tag_dao.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepositoryImpl(
    tagService: ref.watch(tagServiceProvider),
    tagDao: ref.watch(tagDaoProvider),
  );
});

class TagRepositoryImpl implements TagRepository {
  final TagService tagService;
  final TagDao tagDao;

  TagRepositoryImpl({
    required this.tagService,
    required this.tagDao,
  });

  @override
  Future<List<Tag>> getTags(String lang) async {
    try {
      // Always try to fetch from backend first
      final result = await tagService.getTags(lang);
      
      // Save the new tags for future use (cache)
      if (result.isNotEmpty) {
        await tagDao.saveTags(result, lang);
      }
      
      return result;
    } catch (apiError) {
      // If API call fails, fall back to cached tags
      final cachedTags = await tagDao.getTags(lang);
      if (cachedTags != null && cachedTags.isNotEmpty) {
        return cachedTags;
      }
      // If no cached tags and API fails, rethrow the error
      throw Exception('Error getting tags from RIMP!');
    }
  }
}

