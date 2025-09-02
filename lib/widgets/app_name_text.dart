import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatefulWidget {
  const AppNameText({super.key, required this.title});

  final String title;
  @override
  State<AppNameText> createState() => _AppNameTextState();
}

class _AppNameTextState extends State<AppNameText> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(seconds: 12),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: FittedBox(
        child: TitleText(
          title: widget.title,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }
}
