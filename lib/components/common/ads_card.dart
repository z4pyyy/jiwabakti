import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jiwa_bakti/components/common/custom_divider.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/services/api_service.dart';
import 'package:jiwa_bakti/stores/ads_store.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';

class AdsCard extends StatefulWidget{
  const AdsCard({super.key, this.dividerAbove = false, required this.marginTop});

  final bool dividerAbove;
  final double marginTop;

  @override
  State<AdsCard> createState() => AdsCardState();
}

class AdsCardState extends State<AdsCard>{
  final adsStore = GetIt.I<AdsStore>();
  var _currentCarouselIndex = 0;

  late Future<List<Map<String, String>>> future;

  Future<void> _launchUrl(String stringUrl) async {
    final Uri url = Uri.parse(stringUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget blankAds(){
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    future = adsStore.getAdsListPartial();
  }

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<User>();
    final apiService = GetIt.I<ApiService>();
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return FutureBuilder(
        future: future,
        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const SizedBox(
              height: 400,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              List<Map<String, String>> data = snapshot.data!;
              if(data.isNotEmpty) {
                return Column(
                  children: [
                    if(widget.dividerAbove)
                      const CustomDivider(),
                    SizedBox(height: widget.marginTop),
                    Text(
                      "[ Advertisement ]",
                      style: TextStyle(
                          fontSize: user.textSizeScale * themeOptions.textSize3,
                          color: themeOptions.secondaryColor),
                    ),
                    const SizedBox(height: 5),
                    CarouselSlider(
                      items: List.generate(data.length, (index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () async {
                              final data = snapshot.data!;
                              apiService.adsClick({"ads_id": data[index]["id"]});
                              await _launchUrl(data[index]["url"]!);
                            },
                            child: Image.memory(
                              base64Decode(data[index]["image"]!),
                              fit: BoxFit.fill,
                              gaplessPlayback: true,
                            ),
                          ),
                        );
                      }),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentCarouselIndex = index;
                          });
                        },
                        autoPlay: true,
                        autoPlayInterval: const Duration(milliseconds: 8000),
                        autoPlayAnimationDuration: const Duration(
                            milliseconds: 1500),
                        clipBehavior: Clip.antiAlias,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(data.length, (index) {
                          return Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCarouselIndex == index
                                  ? const Color.fromRGBO(0, 0, 0, 0.6)
                                  : const Color.fromRGBO(0, 0, 0, 0.2),
                            ),
                          );
                        })
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }else{
                return blankAds();
              }
            }else{
              return blankAds();
            }
          }

          if(snapshot.hasError){
            // print("----------- SNAPSHOT HAS ERROR: ${snapshot.error}");
          }

          return blankAds();
        }
    );

  }
}
