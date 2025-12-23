import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({
    super.key,
    required this.title,
    this.isAppBar = false,
    this.shimmer = false,
    this.fontSize = 20,
  });

  final String title;
  final bool isAppBar;
  final bool shimmer;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final textWidget = TitleText(
      title: title,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      maxLength: 1,
      color: isAppBar
          ? Theme.of(context).colorScheme.onSurface
          : null,
    );

    if (!shimmer) {
      return textWidget;
    }

    final baseColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.55);
    final highlightColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.9);

    return Shimmer.fromColors(
      period: const Duration(seconds: 3),
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: textWidget,
    );
  }
}
