import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jiwa_bakti/components/common/ads_card.dart';
import 'package:jiwa_bakti/components/common/news_card.dart';
import 'package:jiwa_bakti/components/common/news_detail.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:jiwa_bakti/stores/article_store.dart';
import 'package:jiwa_bakti/utils/utility_functions.dart';

class ArchiveDetailPageMain extends StatefulWidget{
  const ArchiveDetailPageMain({super.key, required this.year, required this.month});

  final int year;
  final int month;

  @override
  State<StatefulWidget> createState() => ArchiveDetailPageMainState();
}

class ArchiveDetailPageMainState extends State<ArchiveDetailPageMain> {

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _cardKeys = [];
  final scrollKey = GlobalKey();

  late List<bool> isExpanded;

  late Future<List<Article>?> future;
  final ArticleStore articleStore = GetIt.I<ArticleStore>();

  late int year;
  late int month;

  Future<List<Article>?> loadArticle() async{
    DateTime? foundKey;
    if(articleStore.articlesByMonth.values.toList().isEmpty){
      await articleStore.getArticlesByMonth(true);
    }else{
      try {
        foundKey = articleStore.articlesByMonth.keys.firstWhere(
              (k) => k.year == year && k.month == month,
        );
      } catch (_) {
        foundKey = null;
        await articleStore.getArticlesByMonth(true).then((value) {
          foundKey = articleStore.articlesByMonth.keys.firstWhere(
                (k) => k.year == year && k.month == month,
          );
        });
      }
    }

    _cardKeys.clear();
    _cardKeys.addAll(List.generate(articleStore.articlesByMonth[foundKey]!.length, (_) => GlobalKey()));
    isExpanded = List.filled(articleStore.articlesByMonth[foundKey]!.length, false);

    return articleStore.articlesByMonth[foundKey];
  }

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
    future = loadArticle();
  }

  void scrollToWidget(GlobalKey key, BuildContext scrollableContext) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final scrollBox = scrollableContext.findRenderObject() as RenderBox;

      final widgetOffset = box.localToGlobal(Offset.zero, ancestor: scrollBox).dy;

      _scrollController.animateTo(
        _scrollController.offset + widgetOffset + 15,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void toggleExpanded(int index) {
    setState(() {
      isExpanded[index] = !isExpanded[index];
    });

    if (isExpanded[index]) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToWidget(_cardKeys[index], scrollKey.currentContext!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        key: scrollKey,
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(210, 210, 210, 0.4),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0.0, 5),
                  ),
                ],
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                "assets/images/jb_logo.jpg",
                fit: BoxFit.contain,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  FutureBuilder(
                      future: future,
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<Article> articles = snapshot.data!;
                          return Column(
                            children: [
                              for (int i = 0; i < articles.length; i++) ...[
                                KeyedSubtree(
                                  key: _cardKeys[i],
                                  child: isExpanded[i]
                                      ? NewsDetail(
                                    image: articles[i].imagePath,
                                    title: articles[i].title,
                                    time: DateFormat("dd/MM/yyyy").format(
                                        articles[i].published),
                                    content: articles[i].content,
                                    author: "Jiwa Bakti",
                                    hourAgo: formatTimeDisplay(
                                        articles[i].published, false),
                                    id: articles[i].id,
                                    onClosePress: () => toggleExpanded(i),
                                  )
                                      : GestureDetector(
                                    onTap: () => toggleExpanded(i),
                                    child: NewsCard(
                                      image: articles[i].imagePath,
                                      title: articles[i].title,
                                      time: DateFormat("dd/MM/yyyy").format(
                                          articles[i].published),
                                    ),
                                  ),
                                ),
                                if (i == 1)...[
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: const AdsCard(marginTop: 45),
                                  ),
                                ],
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
                            child: Text("No News Article Found, Please try Again"),
                          ),
                        );
                      }
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

}
