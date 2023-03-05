import 'package:flutter/material.dart';
import 'package:himitsu_app/utils/settings_util.dart';

class OekoPopUp extends StatelessWidget {
  const OekoPopUp({Key? key, required this.title, required this.content, required this.actions}) : super(key: key);

  //region VARIABLES
  final String title;
  final String content;
  final List<Widget> actions;

  //endregion

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(fontSize: TextSize.extraLarge)),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(content, style: TextStyle(fontSize: TextSize.large)),
      ),
      actions: actions,
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }

  //region WIDGETS
  //endregion
}
