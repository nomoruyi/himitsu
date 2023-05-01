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
      {Key? key,
      this.title,
      this.height = 56,
      this.leading,
      this.actions,
      this.tabBar,
      this.roundedBorder = true,
      this.centerTitle = false,
      this.implyLeadingWidget = true})
      : super(key: key);

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
class OekoSettingsIconButton extends StatelessWidget {
  const OekoSettingsIconButton({Key? key}) : super(key: key);

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

class OekoSortIconButton extends StatelessWidget {
  // final TourBloc tourBloc;
  final int tourId;
// final void Function() refresh;
  const OekoSortIconButton({
    Key? key,
    required this.tourId,
    /*required this.refresh*/
  }) : super(key: key);

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

class OekoSearchIconButton extends StatelessWidget {
  final SearchDelegate delegate;

  const OekoSearchIconButton({Key? key, required this.delegate}) : super(key: key);

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

class OekoMenuButton extends StatelessWidget {
  const OekoMenuButton(
    this.handleClick, {
    Key? key,
  }) : super(key: key);

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
    Key? key,
    required T value,
    bool enabled = true,
    required Widget child,
    this.color,
  }) : super(key: key, value: value, enabled: enabled, child: child);

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
