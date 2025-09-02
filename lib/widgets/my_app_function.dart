import 'package:depth_tracker/services/assets_manager.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';

class MyAppFunction {
  static Future<void> showErrorAndAlertDialog({
    required BuildContext context,
    required String description,
    required String fucntionBtnName,
    bool isError = false,
    required Function function,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Image.asset(
            isError ? AssetsManager.error : AssetsManager.warning,
            width: 60,
            height: 60,
          ),
          content: Text(
            description,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent),
              onPressed: () {
                Navigator.pop(context);
              },
              child: TitleText(title: "Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent),
              onPressed: () {
                function();
              },
              child: TitleText(title: fucntionBtnName),
            ),
          ],
        );
      },
    );
  }
}
