import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jiwa_bakti/components/common/news_card.dart';
import 'package:jiwa_bakti/components/common/news_detail.dart';
import 'package:jiwa_bakti/utils/utility_functions.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:jiwa_bakti/utils/search_cache.dart';

class SearchPageMain extends StatefulWidget {
  const SearchPageMain({super.key});

  @override
  State<SearchPageMain> createState() => SearchPageMainState();
}

class SearchPageMainState extends State<SearchPageMain>{
  final ScrollController _scrollController = ScrollController();

  final List<GlobalKey> _cardKeys = [];
  final scrollKey = GlobalKey();

  List<bool> isExpanded = [];

  int _lastBuiltLength = 0;

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
      print("--- SETTING STATE, TOGGLING EXPANDED ---");
      isExpanded[index] = !isExpanded[index];
    });

    if (isExpanded[index]) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("--- SCROLLING ---");
        scrollToWidget(_cardKeys[index], scrollKey.currentContext!);
      });
    }
  }

  Widget _buildArticleTile(int i, Article article, User user, ThemeOptions themeOptions, bool lastIndex) {
    return KeyedSubtree(
      key: _cardKeys[i],
      child: Padding(
        padding: lastIndex ? const EdgeInsets.only(bottom: 50) : const EdgeInsets.only(bottom: 0),
        child: isExpanded[i]
            ? NewsDetail(
                image: article.imagePath,
                title: article.title,
                time: DateFormat("dd/MM/yyyy").format(article.published),
                content: article.content,
                author: "Jiwa Bakti",
                hourAgo: formatTimeDisplay(article.published, false),
                id: article.id,
                onClosePress: () => toggleExpanded(i),
              )
            : GestureDetector(
                onTap: () => toggleExpanded(i),
                child: NewsCard(
                  image: article.imagePath,
                  title: article.title,
                  time: DateFormat("dd/MM/yyyy").format(article.published),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final searchCache = GetIt.I<SearchCache>();
    final user = GetIt.I<User>();

    return ListView(
      key: scrollKey,
      controller: _scrollController,
      padding: EdgeInsets.zero,
      children: [
        if (searchCache.lastSearchFuture != null)
          FutureBuilder<List<Article>>(
            future: searchCache.lastSearchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Tiada carian dijumpai'),
                );
              }

              final articles = snapshot.data!;
              if (articles.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Tiada carian dijumpai'),
                );
              }

              if (_lastBuiltLength != articles.length) {
                _lastBuiltLength = articles.length;
                isExpanded = List.filled(articles.length, false);
                _cardKeys.clear();
                _cardKeys.addAll(List.generate(articles.length, (_) => GlobalKey()));
              }
              
              return Column(
                children: List.generate(
                  articles.length,
                      (i) => _buildArticleTile(
                    i,
                    articles[i],
                    user,
                    themeOptions,
                    i == articles.length - 1,
                  ),
                ),
              );
            },
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Text(
              'Masukkan kata kunci di atas untuk mula mencari',
              style: TextStyle(
                fontSize:  user.textSizeScale * themeOptions.textSize4,
              ),
            ),
          ),

      ],
    );


  }
}
