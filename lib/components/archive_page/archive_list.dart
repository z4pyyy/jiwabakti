import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:jiwa_bakti/stores/article_store.dart';

class ArchiveList extends StatefulWidget {
  const ArchiveList({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ArchiveListState();
}

class ArchiveListState extends State<ArchiveList>{

  ArticleStore articleStore = GetIt.I<ArticleStore>();
  Map<int, String> categoryIdToName = {};
  List<DateTime> months = [];
  Map<DateTime, List<Article>> articlesByMonth = {};

  late Future<Map<DateTime, List<Article>>> future;

  Future<Map<DateTime, List<Article>>> loadArticle() async{
    if(articleStore.articlesByMonth.values.toList().isEmpty){
      await articleStore.getArticlesByMonth(true);
    }
    months = articleStore.articlesByMonth.keys.toList();

    return articleStore.articlesByMonth;
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
            articlesByMonth = snapshot.data!;
            return Column(
              children: [
                for (int i = 0; i < months.length; i++) ...[
                  IntrinsicHeight(
                    child: InkWell(
                      onTap: (){
                        context.push("/archive/${months[i].year}/${months[i].month}");
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
                                      DateFormat("MMMM yyyy").format(articlesByMonth[months[i]]![0].published),
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      articlesByMonth[months[i]]?[0].title ?? "",
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
                              articlesByMonth[months[i]]?[0].imagePath ?? "",
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