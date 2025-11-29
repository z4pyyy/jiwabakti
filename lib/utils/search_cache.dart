import 'package:jiwa_bakti/models/article.dart';

class SearchCache {
  Future<List<Article>>? lastSearchFuture;
  String lastQuery = '';
}