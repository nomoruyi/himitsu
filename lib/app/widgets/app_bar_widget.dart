import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/utils/settings_util.dart';

class HimitsuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final double height;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? tabBar;
  final bool roundedBorder;
  final bool centerTitle;
  final bool implyLeadingWidget;

  const HimitsuAppBar(
      {super.key,
      this.title,
      this.height = 56,
      this.leading,
      this.actions,
      this.tabBar,
      this.roundedBorder = true,
      this.centerTitle = false,
      this.implyLeadingWidget = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: roundedBorder ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0))) : null,
      centerTitle: centerTitle,
      automaticallyImplyLeading: implyLeadingWidget,
      primary: true,
      toolbarHeight: height,
      leading: leading,
      title: title,
      actions: actions,
      bottom: tabBar,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

//region Icon-Buttons
class HimitsuSettingsIconButton extends StatelessWidget {
  const HimitsuSettingsIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(right: 8.0),
      // color: oekoWhite,
      onPressed: () => context.pushNamed('settings'),
      iconSize: 32,
      icon: const Icon(Icons.settings),
    );
  }
}

class HimitsuSortIconButton extends StatelessWidget {
  final int tourId;

  const HimitsuSortIconButton({
    super.key,
    required this.tourId,
    /*required this.refresh*/
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(right: 8.0),
      // color: oekoWhite,
      onPressed: () => context.goNamed('sort', pathParameters: {'tour_id': tourId.toString()}),
      //  onPressed: null,
      iconSize: 32,
      icon: const Icon(Icons.format_line_spacing),
    );
  }
}

class HimitsuSearchIconButton extends StatelessWidget {
  final SearchDelegate delegate;

  const HimitsuSearchIconButton({super.key, required this.delegate});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: const EdgeInsets.only(right: 8.0),
        // color: oekoWhite,
        onPressed: () => showSearch(context: context, delegate: delegate),
        iconSize: 32,
        icon: const Icon(Icons.search));
  }
}

class HimitsuMenuButton extends StatelessWidget {
  const HimitsuMenuButton(
    this.handleClick, {
    super.key,
  });

  final Future<void> Function(String value) handleClick;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: handleClick,
      itemBuilder: (BuildContext context) {
        return [
/*
          PopupMenuItem<String>(
            value: 'logout',
            child: Text(FlutterI18n.translate(context, 'misc.menu.logout')),
          ),
*/
          CustomPopupMenuItem<String>(
            value: 'settings',
            child: Text(FlutterI18n.translate(context, 'misc.menu.settings'), style: TextStyle(fontSize: TextSize.medium)),
          ),
          CustomPopupMenuItem<String>(
            value: 'logout',
            child: Text(FlutterI18n.translate(context, 'misc.menu.logout'), style: TextStyle(fontSize: TextSize.medium)),
          ),
          CustomPopupMenuItem<String>(
            value: 'finishTour',
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
            child: Text(
              FlutterI18n.translate(context, 'misc.menu.finishTour'),
              style: TextStyle(fontSize: TextSize.medium, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ];
      },
    );
  }
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  const CustomPopupMenuItem({
    super.key,
    required T super.value,
    super.enabled,
    required Widget super.child,
    this.color,
  });

  final Color? color;

  @override
  CustomPopupMenuItemState<T> createState() => CustomPopupMenuItemState<T>();
}

class CustomPopupMenuItemState<T> extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: super.build(context),
    );
  }
}

//endregion
