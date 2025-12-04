import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowUs extends StatelessWidget{
  const FollowUs({
    super.key,
  });

Future<void> _launchUrl(String link) async {
  final Uri url = Uri.parse(link);

  try {
    if (await canLaunchUrl(url)) {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (launched) return;
    }

    final bool launchedFallback = await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
    );

    if (!launchedFallback) {
      debugPrint("ERROR: Could not launch URL (fallback failed): $link");
    }

  } catch (e) {
    debugPrint("LAUNCH ERROR: $e");

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (e2) {
      debugPrint("FINAL LAUNCH ERROR: $e2");
    }
  }
}


  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 25),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Ikuti kami di Instagram, Facebook, X dan Tiktok untuk berita terkini yang anda tidak mahu terlepas!",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14
            ),
          ),
          const SizedBox(height: 15,),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: () => _launchUrl("https://www.instagram.com/jiwabakti?igsh=eXFkMTA5a2IxYzY3&utm_source=qr"),
                icon: const Icon(FontAwesomeIcons.instagram, color: Color(0xFFD24C00),),
                label: const Text("Instagram", style: TextStyle(color: Color(0xFFD24C00), fontSize: 14),),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD24C00), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
              ),
              TextButton.icon(
                onPressed: () => _launchUrl("https://www.facebook.com/share/19rWn7ih73/?mibextid=wwXIfr"),
                icon: const Icon(FontAwesomeIcons.facebookF, color: Color(0xFFD24C00),),
                label: const Text("Facebook", style: TextStyle(color: Color(0xFFD24C00), fontSize: 14),),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD24C00), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
              ),
              TextButton.icon(
                onPressed: () => _launchUrl("https://x.com/jiwabaktiofcl?s=21&t=lGEBAUbe-ZL5EtLsP5OBew"),
                icon: const Icon(FontAwesomeIcons.xTwitter, color: Color(0xFFD24C00),),
                label: const Text("X", style: TextStyle(color: Color(0xFFD24C00), fontSize: 14),),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD24C00), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
              ),
              TextButton.icon(
                onPressed: () => _launchUrl("https://www.tiktok.com/@jiwabakti?_t=ZS-8xf0ZnVXe7k&_r=1"),
                icon: const Icon(FontAwesomeIcons.tiktok, color: Color(0xFFD24C00),),
                label: const Text("TikTok", style: TextStyle(color: Color(0xFFD24C00), fontSize: 14),),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD24C00), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}