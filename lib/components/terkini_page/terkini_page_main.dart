import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jiwa_bakti/components/common/ads_card.dart';
import 'package:jiwa_bakti/components/common/news_card.dart';
import 'package:jiwa_bakti/components/common/news_detail.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/stores/article_store.dart';
import 'package:jiwa_bakti/utils/utility_functions.dart';

class TerkiniPageMain extends StatefulWidget{
  const TerkiniPageMain({super.key, this.openArticleId});
  final int? openArticleId;

  @override
  State<StatefulWidget> createState() => TerkiniPageMainState();
}

class TerkiniPageMainState extends State<TerkiniPageMain> {

  Future<void> _expandAndScrollTo(int idx) async {
    // expand (no auto-scroll here)
    if (!isExpanded[idx]) {
      setState(() => isExpanded[idx] = true);
    }
    // wait one frame so layout finishes
    await Future<void>.delayed(const Duration(milliseconds: 16));

    final ctx = _cardKeys[idx].currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        alignment: 0.05, // a little below the top
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }


  Future<void> _openDeepLinkedArticle(int id) async {
  try {
    final a = await articleStore.getArticleById(id); // make sure this returns Future<Article?>
    if (!mounted || a == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewsDetail(
          image: a.imagePath,
          title: a.title,
          time: DateFormat("dd/MM/yyyy").format(a.published),
          content: a.content,
          author: "Jiwa Bakti",
          hourAgo: formatTimeDisplay(a.published, false),
          id: a.id,
          onClosePress: () => Navigator.of(context).pop(),
        ),
      ),
    );
  } catch (_) {
    // optional: log or show a toast
  }
}

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _cardKeys = [];
  final scrollKey = GlobalKey();

  late List<bool> isExpanded;

  bool _didAutoOpen = false;

  late Future<List<Article>> future;
  final ArticleStore articleStore = GetIt.I<ArticleStore>();

  Future<List<Article>> loadArticle() async{
    final user = GetIt.I<User>();
    if(user.isLogin){
      await articleStore.getSavedArticles();
    }

    await articleStore.getArticles(false);
    List<Article> loadedArticles = [];

    if(articleStore.articles.isNotEmpty){
      loadedArticles = articleStore.articles;
      isExpanded = List.filled(articleStore.articles.length, false);
      _cardKeys.clear();
      _cardKeys.addAll(List.generate(articleStore.articles.length, (_) => GlobalKey()));
    }

    return loadedArticles;
  }

  @override
  void initState() {
    super.initState();
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
    setState(() => isExpanded[index] = !isExpanded[index]);
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
                        if (!_didAutoOpen && widget.openArticleId != null) {
                          final idx = articles.indexWhere((a) => a.id == widget.openArticleId);
                          _didAutoOpen = true;

                          if (idx != -1) {
                            // expand & then scroll, after build finishes
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _expandAndScrollTo(idx);
                            });
                          } else {
                            // not in list: keep your fetch + push detail as you already do
                            final targetId = widget.openArticleId!;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _openDeepLinkedArticle(targetId);
                            });
                          }
                        }

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