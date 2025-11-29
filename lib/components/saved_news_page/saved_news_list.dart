import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:jiwa_bakti/models/article.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SavedNewsList extends StatefulWidget {
  const SavedNewsList({
    super.key,
    required this.news,
  });

  final List<Article> news;

  @override
  State<StatefulWidget> createState() => SavedNewListState();
}

class SavedNewListState extends State<SavedNewsList>{

  @override
  Widget build(BuildContext context){
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();

    return Column(
      children: [
        for (int i = 0; i < widget.news.length; i++) ...[
          IntrinsicHeight(
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
                            widget.news[i].title,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Html(
                            data: widget.news[i].content[0]["summary"] ?? widget.news[i].content[0]["paragraph"],
                            style: {
                              '#': Style(
                                fontSize: FontSize(user.textSizeScale * themeOptions.textSize3),
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis,
                                margin: Margins.all(0),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.network(
                    widget.news[i].imagePath,
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
        ],

      ],
    );
  }
}