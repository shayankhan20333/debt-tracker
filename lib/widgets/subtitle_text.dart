import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    super.key,
    required this.title,
    this.fontSize = 20,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.textDecoration = TextDecoration.none,
    this.textalign = TextAlign.start,
  });

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration textDecoration;
  final TextAlign textalign;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: textStyle(), textAlign: textalign);
  }

  TextStyle textStyle() {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: textDecoration,
    );
  }
}
