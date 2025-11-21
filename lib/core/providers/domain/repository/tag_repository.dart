import 'package:faithmood_app/core/core_exports.dart';

abstract class TagRepository {
  Future<List<Tag>> getTags(String lang);
}

