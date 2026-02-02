import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/category_page/category_list.dart';
import 'package:jiwa_bakti/stores/article_store.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:jiwa_bakti/utils/search_cache.dart';
import 'package:theme_provider/theme_provider.dart';

class CategoryPageMain extends StatefulWidget{
  const CategoryPageMain({super.key});

  @override
  State<StatefulWidget> createState() => CategoryPageMainState();
}

class CategoryPageMainState extends State<CategoryPageMain>{
  final TextEditingController _controller = TextEditingController();

  void handleSearch(String query, ArticleStore articleStore, SearchCache searchCache) {
    if (query.trim().isEmpty) return;

    searchCache.lastQuery = query;
    searchCache.lastSearchFuture = articleStore.loadSearchArticles(query);

    context.push("/search");
  }

  @override
  Widget build(BuildContext context){
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final articleStore = GetIt.I<ArticleStore>();
    final searchCache = GetIt.I<SearchCache>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (query) {
                      handleSearch(query, articleStore, searchCache);
                    },
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: themeOptions.textTitleSize2,
                      color: themeOptions.textColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Cari',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.search, size: 32),
              ],
            ),
          ),
          const CategoryList(),
        ],
      ),
    );
  }
}