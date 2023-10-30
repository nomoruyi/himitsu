import 'package:flutter/material.dart';

class HimitsuPopUp extends StatelessWidget {
  const HimitsuPopUp({super.key, required this.title, this.content, required this.actions});

  //region VARIABLES
  final Widget title;
  final Widget? content;
  final List<Widget> actions;

  //endregion

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Colors.transparent,
      shadowColor: Theme.of(context).shadowColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: title,
      contentPadding: content == null ? null : const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      content: content,
      actions: actions,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsOverflowAlignment: OverflowBarAlignment.center,
    );
  }
}
