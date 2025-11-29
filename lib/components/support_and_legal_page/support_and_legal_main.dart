import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jiwa_bakti/components/common/block_container.dart';
import 'package:jiwa_bakti/components/common/custom_divider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportAndLegalMain extends StatefulWidget {
  const SupportAndLegalMain({Key? key}) : super(key: key);

  @override
  State<SupportAndLegalMain> createState() => SupportAndLegalMainState();
}

class SupportAndLegalMainState extends State<SupportAndLegalMain> {

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              BlockContainer(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async{
                        final Uri url = Uri.parse("https://utusansarawak.com.my/terms-and-conditions/");
                        await _launchUrl(url);
                      },
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Term & syarat",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const CustomDivider(),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () async{
                        final Uri url = Uri.parse("https://utusansarawak.com.my/disclaimer/");
                        await _launchUrl(url);
                      },
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dasar Privasi",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const CustomDivider(),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () async{
                        final Uri url = Uri(
                          scheme: "mailto",
                          path: 'apps@utusansarawak.com.my',
                          queryParameters: {
                            "subject" : "",
                            "body" : ""
                          },
                        );
                        _launchUrl(url);
                      },
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hubungi Kami",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
