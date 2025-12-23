import 'package:depth_tracker/widgets/app_name_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.title,
    this.hasTitleDecoration = false,
    this.hasTitleInCenter = false,
    this.hasLeading = false,
    this.leadingIcon,
    this.leadingfunction,
    this.hasAction = false,
    this.actionIcon,
    this.actionFunction,
    this.showBack = false,
  });

  final String title;
  final bool hasTitleDecoration;
  final bool hasTitleInCenter;
  final bool hasLeading;
  final IconData? leadingIcon;
  final Function? leadingfunction;
  final bool hasAction;
  final IconData? actionIcon;
  final Function? actionFunction;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shouldShowBack =
        showBack || hasLeading || Navigator.of(context).canPop();
    final gradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.9),
        theme.colorScheme.secondary.withOpacity(0.85),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: hasTitleInCenter,
          titleSpacing: 12,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: shouldShowBack
              ? IconButton(
                  onPressed: () =>
                      leadingfunction?.call() ?? Navigator.maybePop(context),
                  icon: Icon(
                    leadingIcon ?? Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                )
              : null,
          title: hasTitleDecoration
              ? AppNameText(title: title, isAppBar: true)
              : TitleText(
                  title: title,
                  color: Colors.white,
                  fontSize: 18,
                  maxLength: 1,
                ),
          actions: hasAction
              ? [
                  IconButton(
                    onPressed: () => actionFunction?.call(),
                    icon: Icon(actionIcon, color: Colors.white),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
