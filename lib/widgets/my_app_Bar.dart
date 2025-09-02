import 'package:depth_tracker/services/assets_manager.dart';
import 'package:depth_tracker/widgets/app_name_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';

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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: hasLeading
          ? Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: InkWell(
                onTap: () {
                  leadingfunction!();
                },
                child: Image.asset(AssetsManager.emptySearch),
              ),
            )
          : null,
      title: hasTitleDecoration
          ? AppNameText(title: title)
          : FittedBox(child: TitleText(title: title)),
      centerTitle: hasTitleInCenter,
      actions: hasAction
          ? [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: InkWell(
                  onTap: () {
                    actionFunction!();
                  },
                  child: Icon(actionIcon),
                ),
              ),
            ]
          : null,
    );
  }
}
