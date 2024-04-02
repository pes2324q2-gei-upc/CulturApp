import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TextWithLink extends StatelessWidget {
  final String text;
  final String url;

  const TextWithLink({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrlString(url);

      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}