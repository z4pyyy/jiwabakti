import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jiwa_bakti/components/common/news_card.dart';
import 'package:jiwa_bakti/components/common/news_detail.dart';
import 'package:jiwa_bakti/components/common/rounded_text_button.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/stores/article_store.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:jiwa_bakti/utils/utility_functions.dart';
import 'package:theme_provider/theme_provider.dart';

class SavedNewsPageMain extends StatefulWidget{
  const SavedNewsPageMain({super.key});

  @override
  State<StatefulWidget> createState() => SavedNewsPageMainState();
}

class SavedNewsPageMainState extends State<SavedNewsPageMain>{

  final ArticleStore articleStore = GetIt.I<ArticleStore>();
  final User user = GetIt.I<User>();
  late Future<void> future;

  final ScrollController _scrollController = ScrollController();

  final List<GlobalKey> _cardKeys = [];
  final scrollKey = GlobalKey();

  List<bool> isExpanded = [];

  int _lastBuiltLength = 0;

  @override
  void initState(){
    super.initState();
    future = articleStore.getSavedArticles();
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
  Widget build(BuildContext context){
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    if(user.isLogin) {
      return FutureBuilder(
          future: future,
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
                child: Text('No Saved News Found'),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final List<Article> articles = articleStore.savedArticles;

              if (articles.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No Saved News Found'),
                );
              }

              if (_lastBuiltLength != articles.length) {
                _lastBuiltLength = articles.length;
                isExpanded = List.filled(articles.length, false);
                _cardKeys.clear();
                _cardKeys.addAll(List.generate(articles.length, (_) => GlobalKey()));
              }

              return ListView(
                key: scrollKey,
                controller: _scrollController,
                padding: EdgeInsets.zero,
                children: [
                  Column(
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
                  ),
                ],
              );
            }

            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No Saved News Found'),
            );
          }
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeOptions.primaryColor,
            ),
            child: const Center(
              child: Icon(FontAwesomeIcons.exclamation, size: 30, color: Colors.white,),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Text(
            'When you have a Jiwa Bakti account, your saved news will show up here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: themeOptions.textSize3,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: RoundedTextButton(
              text: Text(
                "Register for a Jiwa Bakti account",
                style: TextStyle(
                  fontSize: themeOptions.textSize3,
                ),
              ),
              onPressed: (){
                context.push("/signup-option");
              },
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: RoundedTextButton(
              text: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: themeOptions.textSize3,
                ),
              ),
              onPressed: (){
                context.push("/signin");
              },
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
          ),

        ],
      ),
    );
  }
}