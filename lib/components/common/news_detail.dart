import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/common/ads_card.dart';
import 'package:jiwa_bakti/components/common/follow_us.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/stores/article_store.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jiwa_bakti/services/flowlink_service.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({
    super.key,
    required this.image,
    required this.title,
    required this.time,
    required this.content,
    required this.onClosePress,
    required this.author,
    required this.hourAgo,
    required this.id,
  });

  final String image;
  final String title;
  final String time;
  final List<Map<String,String>> content;
  final String author;
  final String hourAgo;
  final int id;
  final VoidCallback onClosePress;

  @override
  State<StatefulWidget> createState () => NewsDetailState();
}

class NewsDetailState extends State<NewsDetail>{

  void showPleaseLoginDialog(
  BuildContext context,
  ThemeOptions themeOptions,
  User user,
) {
  const double dialogScale = 2.0;

  double s(double base) => base * dialogScale * user.textSizeScale;

  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: themeOptions.primaryColor,
        ),
        child: const Center(
          child: Icon(FontAwesomeIcons.exclamation, size: 34, color: Colors.white),
        ),
      ),
      message: Text(
        'Untuk terus menggunakan berita tersimpan, sila daftar masuk atau daftar untuk akaun pengguna Jiwa Bakti',
        style: TextStyle(
          fontSize: s(themeOptions.textSize3),
          height: 1.25,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => context.push("/signup-option"),
          child: Text(
            'Daftar untuk akaun pengguna Jiwa Bakti',
            style: TextStyle(fontSize: s(themeOptions.textSize2)),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () => context.push("/signin"),
          child: Text(
            'Daftar Masuk',
            style: TextStyle(fontSize: s(themeOptions.textSize2)),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => context.pop(),
        isDefaultAction: true,
        child: Text(
          'Batalkan',
          style: TextStyle(fontSize: s(themeOptions.textSize2)),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context){
    final articleStore = GetIt.I<ArticleStore>();
    final savedNewsId = articleStore.savedArticleId;
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    bool _isSharing = false;
    final titleTextStyle = TextStyle(
      fontSize: user.textSizeScale * (themeOptions.textTitleSize1 + 2),
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
    final bodyTextStyle = TextStyle(
      color: themeOptions.textColor,
      fontSize: user.textSizeScale * (themeOptions.textSize1 + 6),
      height: 1.6,
    );
    final metaTextStyle = TextStyle(
      fontSize: user.textSizeScale * (themeOptions.textSize1 + 1),
      color: Colors.grey[600],
    );

    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onClosePress,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 6, right: 4),
                        child: Icon(Icons.close, size: 36,),
                      ),
                      Text("Close", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize2),),
                    ],
                  ),
                ),
                const Spacer(),

                // Container(
                //   margin: const EdgeInsets.only(right: 10),
                //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     borderRadius: const BorderRadius.all(Radius.circular(20)),
                //   ),
                //   child: const Icon(Icons.share, color: Colors.black, size: 24,),
                // ),

                GestureDetector(
                  onTap: _isSharing
                      ? null
                      : () async {
                          setState(() => _isSharing = true);
                          try {
                            // easiest helper (uses type:'news', id: widget.id under the hood)
                            final shortLink = await FlowLinkService.createNewsLink(widget.id);

                            debugPrint('Generated FlowLink: $shortLink');

                            if (shortLink != null) {
                              await Share.share(
                                'Check out this news: ${widget.title}\n$shortLink',
                                subject: widget.title,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to generate share link')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Share failed: $e')),
                            );
                          } finally {
                            if (mounted) setState(() => _isSharing = false);
                          }
                        },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: _isSharing
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.share, color: Colors.black, size: 24),
                  ),
                ),



                GestureDetector(
                  onTap: (){
                    if(user.isLogin){
                      setState(() {
                        if(savedNewsId.contains(widget.id)){
                          savedNewsId.remove(widget.id);
                          articleStore.deleteSavedArticles(widget.id);
                        }else{
                          savedNewsId.add(widget.id);
                          articleStore.addSavedArticles(widget.id);
                        }
                      });
                    }else{
                      showPleaseLoginDialog(context, themeOptions, user);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Icon(
                      savedNewsId.contains(widget.id)
                        ? FontAwesomeIcons.solidBookmark
                        : FontAwesomeIcons.bookmark,
                      color: Colors.black, size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Image.network(
              widget.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/grey_background.jpg",
                  fit: BoxFit.cover,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: titleTextStyle,
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.orange,
                          width: 3.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "By ${widget.author}",
                      style: bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.time,
                        style: metaTextStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 1.5,
                        height: metaTextStyle.fontSize ?? 16,
                        color: Colors.grey[500],
                      ),
                      Text(
                        widget.hourAgo,
                        style: metaTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.content.length,
                      itemBuilder: ((context, listIndex) {

                        String content = widget.content[listIndex]["paragraph"]!;
                        int index = content.indexOf("\n", (content.length * 0.65).round());

                        String htmlOne = content.substring(0, index);
                        String htmlTwo = content.substring(index, content.length - 1);

                        return Column(
                          children: [
                            const SizedBox(height: 25),
                            if(widget.content[listIndex].containsKey("location"))...[
                              RichText(
                                text: TextSpan(
                                  text: "${widget.content[listIndex]["location"]!}: ",
                                  style: TextStyle(
                                    color: themeOptions.textColor,
                                    fontSize: bodyTextStyle.fontSize,
                                    fontWeight: FontWeight.w600,
                                    height: bodyTextStyle.height,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.content[listIndex]["paragraph"]!,
                                      style: TextStyle(
                                        color: themeOptions.textColor,
                                        fontSize: bodyTextStyle.fontSize,
                                        fontWeight: FontWeight.normal,
                                        height: bodyTextStyle.height,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]else if(widget.content[listIndex].containsKey("paragraph"))...[
                              HtmlWidget(
                                htmlOne,
                                textStyle: bodyTextStyle,
                              ),

                              const AdsCard(marginTop: 40),

                              HtmlWidget(
                                htmlTwo,
                                textStyle: bodyTextStyle,
                              ),

                            ],
                            if(listIndex == widget.content.length - 5)...[
                              const AdsCard(marginTop: 40,),
                            ],
                          ],
                        );
                      })),
                  const FollowUs(),
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}
