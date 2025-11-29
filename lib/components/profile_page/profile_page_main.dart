import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/common/block_container.dart';
import 'package:jiwa_bakti/components/common/custom_divider.dart';
import 'package:jiwa_bakti/components/profile_page/account_detail_row.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:jiwa_bakti/utils/show_toast.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePageMain extends StatefulWidget {
  const ProfilePageMain({super.key});

  @override
  State<ProfilePageMain> createState() => ProfilePageMainState();
}

class ProfilePageMainState extends State<ProfilePageMain> {

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<User>();
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

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
              const SizedBox(height: 20),
              InkWell(
                onTap: (){
                  if(user.isLogin){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            title: const Text("Daftar Keluar"),
                            content: const Text("Are you sure you want to sign out?"),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                ),
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    color: themeOptions.secondaryColor,
                                  ),
                                ),
                                onPressed: (){
                                  context.pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                ),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: themeOptions.primaryColor,
                                  ),
                                ),
                                onPressed: (){
                                  context.pop();
                                  showFToast(message: "Logout successful", context: context);
                                  setState(() {
                                    user.logout();
                                  });
                                },
                              ),
                            ],
                          );
                        }
                    );
                  }else{
                    context.push("/signin");
                  }
                },
                child: BlockContainer(
                  child: Text(
                    user.isLogin ? "Daftar Keluar" : "Daftar Masuk",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFD24C00),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              if(user.isLogin)...[
                const SizedBox(height: 30),
                BlockContainer(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User Profile",
                            style: TextStyle(
                              fontSize: user.textSizeScale * themeOptions.textSize5,
                              fontWeight: FontWeight.w500,
                              color: themeOptions.iconColor,
                              fontFamily: "Serif",
                              letterSpacing: 1.1,
                              wordSpacing: 3,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              // context.push("/edit-profile");
                            },
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: user.textSizeScale * themeOptions.textSize3,
                                fontWeight: FontWeight.w500,
                                color: themeOptions.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AccountDetailRow(label: "Name", value: "${user.firstName} ${user.lastName}"),
                      const SizedBox(height: 5),
                      const CustomDivider(),
                      const SizedBox(height: 5),
                      AccountDetailRow(label: "Umur", value: "${user.age}"),
                      const SizedBox(height: 5),
                      const CustomDivider(),
                      const SizedBox(height: 5),
                      AccountDetailRow(label: "Negara", value: "${user.state}, ${user.country}"),
                      const SizedBox(height: 5),
                      const CustomDivider(),
                      const SizedBox(height: 5),
                      AccountDetailRow(label: "E-mel", value: user.email!),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),
              BlockContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Aturan Aplikasi",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontFamily: "Serif",
                          letterSpacing: 1.1,
                          wordSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: (){
                          context.push("/text-size");
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Icon(Icons.text_fields_rounded, size: 24,),
                                ),
                                SizedBox(width: 12,),
                                Text(
                                  "Saiz Teks",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
              const SizedBox(height: 30),
              BlockContainer(
                child: InkWell(
                  onTap: (){
                    context.push("/support-and-legal");
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Icon(FontAwesomeIcons.question, size: 24,),
                          ),
                          SizedBox(width: 12,),
                          Text(
                            "Sokongan Aplikasi",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
              BlockContainer(
                child: InkWell(
                  onTap: (){
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
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Icon(Icons.email_outlined, size: 24,),
                          ),
                          SizedBox(width: 12,),
                          Text(
                            "Feedback",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
              BlockContainer(
                child: InkWell(
                  onTap: (){
                    context.push("/saved-news");
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Icon(FontAwesomeIcons.bookmark, size: 20,),
                          ),
                          SizedBox(width: 12,),
                          Text(
                            "Saved News",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
