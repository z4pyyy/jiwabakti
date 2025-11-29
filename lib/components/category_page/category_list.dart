import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:jiwa_bakti/stores/article_store.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CategoryListState();
}

class CategoryListState extends State<CategoryList>{

  ArticleStore articleStore = GetIt.I<ArticleStore>();
  Map<int, String> categoryIdToName = {};
  List<int> categories = [];
  Map<int, List<Article>> articlesByCategory = {};

  late Future<Map<int, List<Article>>> future;

  Future<Map<int, List<Article>>> loadArticle() async{
    if(articleStore.categoryIds.isEmpty){
      await articleStore.loadCategories();
      categories = articleStore.categoryIds;
    }
    categoryIdToName = articleStore.categoryIdToName;

    categories = articleStore.categoryIds;
    for(int id in articleStore.categoryIds){
      await articleStore.getArticlesByCategory(false, id);
    }
    articlesByCategory = articleStore.articlesByCategory;

    return articleStore.articlesByCategory;
  }

  @override
  void initState(){
    super.initState();
    future = loadArticle();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: future,
      builder: (context, snapshot){
        if(snapshot.hasData){
          articlesByCategory = snapshot.data!;
          return Column(
            children: [
              for (int i = 0; i < categories.length; i++) ...[
                IntrinsicHeight(
                  child: InkWell(
                    onTap: (){
                      context.push("/category/${categories[i]}");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoryIdToName[categories[i]]!,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    articlesByCategory[categories[i]]?[0].title ?? "",
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.network(
                            articlesByCategory[categories[i]]?[0].imagePath ?? "",
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/grey_background.jpg",
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

            ],
          );
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const SizedBox(
            height: 400,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const SizedBox(
          height: 400,
          width: double.infinity,
          child: Center(
            child: Text("No categories found. Please try Again"),
          ),
        );

      }
    );
  }
}