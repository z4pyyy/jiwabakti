import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:html/parser.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/services/api_service.dart';

class ArticleStore{

  DateTime refreshTime = DateTime.now().subtract(const Duration(minutes: 10));
  final int refreshInterval = 30;

  List<Article> articles = [];
  List<Article> savedArticles = [];
  List<int> savedArticleId = [];
  List<Article> searchArticles = [];

  Map<int, List<Article>> articlesByCategory = {};
  Map<DateTime, List<Article>> articlesByMonth = {};

  List<int> categoryIds = [];
  Map<int, String> categoryIdToName = {};

  final ApiService apiService = GetIt.I<ApiService>();
  final User user = GetIt.I<User>();

  final Dio client;
  final String apiUrl = "https://jiwabakti.com.my/wp-json/wp/v2";

  ArticleStore({required this.client});

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

  Future<void> loadCategories() async {
    try {
      Response response = await client.get("$apiUrl/categories?_fields=name,id,parent&per_page=99");
      List<dynamic> data = response.data;

      categoryIdToName.clear();
      for (var e in data) {
        String categoryName = parse(e["name"]).body!.text;
        categoryIdToName[e["id"]] = categoryName;
        categoryIds.add(int.parse(e["id"].toString()));
      }

    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        print("ERROR Loading Category ${e.response!.data['message']}");
      }
      print("ERROR Loading Category $e");
    }
  }

  Future<Article?> getArticleById(int id) async {
    // 1) If we already have it, return it
    try {
      final existing = articles.firstWhere((a) => a.id == id);
      return existing;
    } catch (_) {
      // not in the current list
    }

    // 2) Fetch a single post from WordPress and map it
    try {
      if (categoryIdToName.isEmpty) {
        // ensure category names exist for mapping
        await loadCategories();
      }

      final resp = await client.get(
        "$apiUrl/posts/$id",
        queryParameters: {
          '_fields':
              'id,title,date,featured_media,featured_image_urls,content,categories,tags,link',
        },
      );

      final data = resp.data;          // single object
      if (data == null) return null;

      final article = processWordpressApiResponse(data);

      // (optional) cache it so subsequent calls are instant
      if(article != null){
        articles.insert(0, article);
      }

      return article;
    } on DioException catch (e) {
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        // ignore: avoid_print
        print("ERROR fetch article $id: ${e.response!.data['message']}");
      } else {
        // ignore: avoid_print
        print("ERROR fetch article $id: $e");
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("ERROR fetch article $id: $e");
      return null;
    }
  }


  Future<void> getArticles(bool forceRefresh) async {
    await loadCategories();

    DateTime now = DateTime.now();
    if(now.difference(refreshTime).inMinutes >= refreshInterval || forceRefresh || articles.isEmpty) {
      refreshTime = now;

      try {
        articles.clear();
        Response response = await client.get("$apiUrl/posts?_fields=id,title,date,featured_media,featured_image_urls,content,categories,tags,link&per_page=30");
        List<dynamic> data = response.data;

        for (var e in data){ 
          Article? article = processWordpressApiResponse(e);
          if(article != null){
            articles.add(article);
          }
        }

      } on DioException catch (e) {
        if (e.response?.data['message'] != null) {
          print("ERROR Getting Articles ${e.response!.data['message']}");
        }
        print("ERROR Getting Articles $e");
      }

    }
  }

  Future<void> getArticlesByCategory(bool forceRefresh, int categoryId) async {
    DateTime now = DateTime.now();
    if(now.difference(refreshTime).inMinutes >= refreshInterval || forceRefresh || !articlesByCategory.containsKey(categoryId) ||
        (articlesByCategory[categoryId]?.isEmpty ?? true) ) {
      refreshTime = now;

      try {
        articlesByCategory[categoryId]?.clear();
        Response response = await client.get("$apiUrl/posts?_fields=id,title,date,featured_media,featured_image_urls,content,categories,tags,link&per_page=10&categories=$categoryId");
        List<dynamic> data = response.data;

        List<Article> articlesByCat = [];
        for (var e in data){
          Article? article = processWordpressApiResponse(e);
          if(article != null){
            articlesByCat.add(article);
          }
        }

        articlesByCategory[categoryId] = articlesByCat;

      } on DioException catch (e) {
        if (e.response?.data['message'] != null) {
          print("ERROR Getting Articles ${e.response!.data['message']}");
        }
        print("ERROR Getting Articles $e");
      } on Exception catch (ex){
        print("ERROR Getting Articles $ex");
      }

    }
  }

  Future<void> getArticlesByMonth(bool forceRefresh) async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(2023, 11);
    List<DateTime> monthKeys = [];

    DateTime cursor = start;
    while (cursor.isBefore(DateTime(now.year, now.month + 1))) {
      monthKeys.add(DateTime(cursor.year, cursor.month));
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    monthKeys = monthKeys.reversed.toList();

    for (var month in monthKeys) {
      articlesByMonth[month] ??= [];
    }

    try {
      for (var month in monthKeys) {
        if (now.difference(refreshTime).inMinutes >= refreshInterval ||
            forceRefresh ||
            (articlesByMonth[month]?.isEmpty ?? true)) {
          refreshTime = now;

          DateTime after = month;
          DateTime before = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

          String afterStr = after.toIso8601String();
          String beforeStr = before.toIso8601String();

          Response response = await client.get(
            "$apiUrl/posts?_fields=id,title,date,featured_media,featured_image_urls,content,categories,tags,link"
                "&per_page=10"
                "&after=$afterStr"
                "&before=$beforeStr",
          );

          List<dynamic> data = response.data;

          List<Article> monthlyArticles = [];
          for (var e in data) {
            Article? article = processWordpressApiResponse(e);
            if (article != null) {
              monthlyArticles.add(article);
            }
          }

          articlesByMonth[month] = monthlyArticles;
        }
      }
    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        print("ERROR Getting Articles ${e.response!.data['message']}");
      }
      print("ERROR Getting Articles $e");
    } on Exception catch (ex) {
      print("ERROR Getting Articles $ex");
    }
  }


  Future<List<Article>> loadSearchArticles(String title) async{
    String safeTitle = title.replaceAll(RegExp(r"""[:–—!?.,"@#$&()/]"""), '');
    String encodedTitle = Uri.encodeQueryComponent(safeTitle);
    int searchCountToShow = 10;
    int count = 0;

    Response response = await client.get("$apiUrl/posts?search=\"$encodedTitle\"&_fields=id,title,date,featured_media,featured_image_urls,content,categories,tags,link&per_page=99");
    List<dynamic> data = response.data;

    List<Article> articles = [];
    searchArticles.clear();

    final regex = RegExp(r'\b' + RegExp.escape(safeTitle) + r'\b', caseSensitive: false);
    for(var e in data){
      if(count < searchCountToShow){
        final content = e["content"]["rendered"];
        final title = e["title"]["rendered"];

        if (regex.hasMatch(title) || regex.hasMatch(content)) {
          Article? article = processWordpressApiResponse(e);
          if(article != null){
            articles.add(article);
            searchArticles.add(article);
          }
          count++;
        }
      }
    }

    return articles;
  }

  Future<void> getSavedArticles() async{

    if(user.isLogin){

      List<dynamic> data = await apiService.getSavedNews(user.userId!);
      if(data.isNotEmpty){
        savedArticleId.clear();
        for(var news in data){
          if(news["news_id"] != null){
            savedArticleId.add(int.parse(news["news_id"]));
          }
        }
      }

      try {
        final includeParam = savedArticleId.join(',');
        savedArticles.clear();

        Response response = await client.get(
          '$apiUrl/posts',
          queryParameters: {
            '_fields': 'id,title,date,featured_media,featured_image_urls,content,categories,tags,link',
            'per_page': savedArticleId.length > 99 ? '99' : "${savedArticleId.length}",
            'include': includeParam,
          },
        );

        List<dynamic> data = response.data;

        for (var e in data){
          Article? article = processWordpressApiResponse(e);
          if(article != null) {
            savedArticles.add(article);
          }
        }

      } on DioException catch (e) {
        if (e.response?.data['message'] != null) {
          print("ERROR Getting Saved Articles ${e.response!.data['message']}");
        }
        print("ERROR Getting Saved Articles $e");
      }

    }

  }

  void addSavedArticles(int newsId) async{
    if(user.isLogin){
      print("--- STARTING TO SAVE $newsId ---");
      dynamic data = await apiService.saveNews(user.userId!, newsId);
      print("--- DATA FROM GETSAVEDNEWS: $data");
    }
  }

  void deleteSavedArticles(int newsId) async{
    try {
      if (user.isLogin) {
        dynamic data = await apiService.deleteSavedNews(user.userId!, newsId);
        print("--- DATA FROM DELETE SAVED NEWS: $data");
      }
    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        print("ERROR While Deleting Saved News ${e.response!.data['message']}");
      }
      print("ERROR While Deleting Saved News $e");

    }
  }

  Article? processWordpressApiResponse(dynamic wpPost){
    try{
      var document = parse(wpPost["title"]["rendered"]);
      String title = removeAllHtmlTags(document.body!.text);

      String paragraph = wpPost["content"]["rendered"];
      List<Map<String, String>> content = [{
        "paragraph" : paragraph,
      }];

      int startIndex = paragraph.indexOf("<p");
      int endIndex = paragraph.indexOf("</p>") + 4;
      if(startIndex != -1){
        content[0]["summary"] = paragraph.substring(startIndex, endIndex);
      }else{
        content[0]["summary"] = "";
      }

      String date = wpPost["date"];
      int index = date.indexOf("T");
      String formattedDate = "${date.substring(0, index)} ${date.substring(index + 1)}";
      DateTime published = DateTime.parse(formattedDate);

      var categoryId = wpPost["categories"][0];

      String category = categoryIdToName[categoryId]!;

      final image = wpPost["featured_image_urls"]["medium_large"];
      String imagePath = "";
      if( image is List && image.isNotEmpty ){
        imagePath = wpPost["featured_image_urls"]["medium_large"][0];
      }

      int articleMinRead = (paragraph.length/1500).round();

      List<int> tags = [];
      if(wpPost["tags"] != null){
        List<dynamic> tagsRawData = wpPost["tags"];
        for(var e in tagsRawData){
          tags.add(int.parse(e.toString()));
        }
      }

      bool isTagLink = false;
      String link = wpPost["link"];
      int linkStartIndex = link.indexOf("utusansarawak.com.my/") + 21;
      int linkEndIndex = link.length;
      String subStr = link.substring(linkStartIndex, linkEndIndex);
      if(subStr.contains("?tag=")){
        isTagLink = true;
      }

      int id = wpPost["id"];

      Article article = Article(
        id: id,
        title: title,
        shortTitle: title,
        content: content,
        imagePath: imagePath,
        category: category,
        minRead: articleMinRead,
        published: published,
        tags: tags,
        isTagLink: isTagLink,
      );

      return article;
    } on Exception catch (e){
      print("ERROR processing articles $e");
      return null;
    }

  }

}

