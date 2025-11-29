import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget{
  const NewsCard({
    super.key,
    required this.image,
    required this.title,
    required this.time
  });

  final String image;
  final String title;
  final String time;

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 35),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(210, 210, 210, 0.6),
            spreadRadius: 3,
            blurRadius: 12),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/grey_background.jpg",
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: textTheme.bodyLarge?.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: textTheme.bodySmall?.fontSize,
                    color: Colors.grey[600]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}