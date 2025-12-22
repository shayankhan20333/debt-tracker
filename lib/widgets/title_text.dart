import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.title,
    this.fontSize = 20,
    this.color,
    this.maxLength,
    this.fontWeight = FontWeight.normal,
  });

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLength,
      overflow: TextOverflow.ellipsis,
      style: textStyle(),
    );
  }

  TextStyle textStyle() {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);
  }
}
