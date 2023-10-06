// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';

abstract class DialogUtil {
  //region GENERAL
  /*static Future<void> updateApp(BuildContext context, AuthBloc authBloc) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return BioCourierPopUp(
          title: Text(FlutterI18n.translate(ctx, 'popup.title.updateAvailable'), style: TextStyle(fontSize: TextSize.large)),
          content: Text(FlutterI18n.translate(ctx, 'popup.content.updateAvailable'), style: TextStyle(fontSize: TextSize.large)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();

                  authBloc.add(Logout());
                },
                child: Text(FlutterI18n.translate(ctx, 'button.ok'), style: TextStyle(fontSize: TextSize.medium))),
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(FlutterI18n.translate(ctx, 'button.cancel'), style: TextStyle(fontSize: TextSize.medium))),
          ],
        );
      },
    );
  }

  static Future<void> logout(BuildContext context, AuthBloc authBloc) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return BioCourierPopUp(
          title: Text(FlutterI18n.translate(ctx, 'popup.title.warning'), style: TextStyle(fontSize: TextSize.large)),
          content: Text(FlutterI18n.translate(ctx, 'popup.content.logout'), style: TextStyle(fontSize: TextSize.large)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();

                  authBloc.add(Logout());
                },
                child: Text(FlutterI18n.translate(ctx, 'button.yes'), style: TextStyle(fontSize: TextSize.medium))),
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(FlutterI18n.translate(ctx, 'button.cancel'), style: TextStyle(fontSize: TextSize.medium))),
          ],
        );
      },
    );
  }

  static Future<void> loadTourDeliveries(BuildContext context, TourBloc tourBloc, BioCourierTour selectedTour) async {
    await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return selectedTour.isInBox
              ? BioCourierPopUp(
                  title: Text('${selectedTour.name} (Nr. ${selectedTour.tourId})', style: TextStyle(fontSize: TextSize.extraLarge)),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(FlutterI18n.translate(ctx, 'popup.content.alreadyAvailable'), style: TextStyle(fontSize: TextSize.large)),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();

                          TourService.tourBox.delete(selectedTour.id);
                          tourBloc.add(LoadTourDeliveries(selectedTour,
                              loadFromCache: false, extraBoxName: FlutterI18n.translate(ctx, 'boxNames.Fahrer packen')));
                        },
                        child: Text(FlutterI18n.translate(ctx, 'button.downloadAgain'),
                            textAlign: TextAlign.center, style: TextStyle(fontSize: TextSize.medium))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();

                          tourBloc.add(LoadTourDeliveries(selectedTour,
                              loadFromCache: true, extraBoxName: FlutterI18n.translate(ctx, 'boxNames.Fahrer packen')));
                        },
                        child:
                            Text(FlutterI18n.translate(ctx, 'button.skip'), style: TextStyle(fontSize: TextSize.medium, fontWeight: FontWeight.bold)))
                  ],
                )
              : BioCourierPopUp(
                  title: Text('${selectedTour.name} (Nr. ${selectedTour.tourId})', style: TextStyle(fontSize: TextSize.extraLarge)),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(FlutterI18n.translate(ctx, 'popup.content.downloadTour'), style: TextStyle(fontSize: TextSize.large)),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(FlutterI18n.translate(ctx, 'button.cancel'), style: TextStyle(fontSize: TextSize.medium))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          tourBloc.add(LoadTourDeliveries(selectedTour,
                              loadFromCache: false, startTour: false, extraBoxName: FlutterI18n.translate(ctx, 'boxNames.Fahrer packen')));
                        },
                        child: Text(FlutterI18n.translate(ctx, 'button.onlyDownload'), style: TextStyle(fontSize: TextSize.medium))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          tourBloc.add(LoadTourDeliveries(selectedTour,
                              loadFromCache: false, extraBoxName: FlutterI18n.translate(ctx, 'boxNames.Fahrer packen')));
                        },
                        child:
                            Text(FlutterI18n.translate(ctx, 'button.yes'), style: TextStyle(fontSize: TextSize.medium, fontWeight: FontWeight.bold)))
                  ],
                );
        });
  }

  static Future<void> _showPickTime(BuildContext context, TextEditingController textController, {required GlobalKey<FormState> formKey}) async {
    await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((selectedTime) {
      textController.text = selectedTime == null ? '' : '${selectedTime.hour}:${selectedTime.minute}';
      // textController.text = selectedTime?.format(context) ?? '';
      formKey.currentState!.validate();
    });
  }

  static Future<void> showAllProducts(BuildContext context, List<BioCourierBox> boxes) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return BioCourierPopUp(
          title: Text(
            FlutterI18n.translate(ctx, 'popup.title.allArticle'),
            style: TextStyle(fontSize: TextSize.large, fontWeight: FontWeight.w500),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (BioCourierBox delivery in boxes)
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: SizedBox(
                      width: double.infinity,
                      child: Text(
                        delivery.getInfo(ctx),
                        style: TextStyle(fontSize: TextSize.medium, fontWeight: FontWeight.w600),
                      ),
                    ),
                    children: [
                      for (BioCourierProduct product in delivery.products)
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            children: [
                              Text('- ${product.getInfo()}', style: TextStyle(fontSize: TextSize.medium, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(FlutterI18n.translate(ctx, 'button.ok'), style: TextStyle(fontSize: TextSize.medium))),
          ],
        );
      },
    );
  }

  static Future<void> deviatingLocation(BuildContext context, DeliverStationCubit stationCubit) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return BioCourierPopUp(
              title: Text(FlutterI18n.translate(ctx, 'popup.title.differentLocation'), style: TextStyle(fontSize: TextSize.large)),
              content: Text(FlutterI18n.translate(ctx, 'popup.content.differentLocation'), style: TextStyle(fontSize: TextSize.large)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(FlutterI18n.translate(ctx, 'button.no'), style: TextStyle(fontSize: TextSize.medium))),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();

                      stationCubit.updateAddressLocation();
                    },
                    child: Text(FlutterI18n.translate(ctx, 'button.yes'), style: TextStyle(fontSize: TextSize.medium)))
              ]);
        });
  }

  static Future<bool?> abortTour(BuildContext context, TourBloc tourBloc) async {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return BioCourierPopUp(
              title: Text(FlutterI18n.translate(ctx, 'popup.title.warning'), style: TextStyle(fontSize: TextSize.large)),
              content: Text(FlutterI18n.translate(ctx, 'popup.content.abortTour'), style: TextStyle(fontSize: TextSize.large)),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);

                      tourBloc.add(const UpdateTour(TourStatus.OPEN));

                      ctx.pop();
                    },
                    child: Text(FlutterI18n.translate(ctx, 'button.yes'), style: TextStyle(fontSize: TextSize.medium))),
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(FlutterI18n.translate(ctx, 'button.back'), style: TextStyle(fontSize: TextSize.medium)))
              ]);
        });
  }
*/
  //endregion
}

abstract class FlushbarUtil {
  static Flushbar error(BuildContext context, {String? title, String? message, int durationSeconds = 5}) {
    return Flushbar(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      title: title ?? FlutterI18n.translate(context, 'notification.title.error'),
      titleColor: Theme.of(context).textTheme.bodyMedium?.color,
      message: message,
      messageColor: Theme.of(context).textTheme.bodyMedium?.color,
      duration: Duration(seconds: durationSeconds),
    );
  }

  static Flushbar success(BuildContext context, {String? title, String? message, int durationSeconds = 3}) {
    return Flushbar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: title ?? FlutterI18n.translate(context, 'notification.title.success'),
      titleColor: Theme.of(context).textTheme.bodyMedium?.color,
      message: message,
      messageColor: Theme.of(context).textTheme.bodyMedium?.color,

      // message: FlutterI18n.translate(context, 'notification.title.tourFinished'),
      duration: Duration(seconds: durationSeconds),
    );
  }
}

enum UriType { none, phone, mail, link }

void openURI(BuildContext context, {required UriType type, required String input, String? subject, String? body}) async {
  final Uri uri;

  input = input.trim();

  switch (type) {
    case UriType.none:
      return;
    case UriType.phone:
      input = input.replaceAll('/', '').replaceAll('-', '').replaceAll(' ', '');
      uri = Uri.parse('tel://$input');

      await url_launcher.launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    case UriType.mail:
      uri = Uri.parse(
          'mailto:no_mail_yet?subject=Himitsu: ${FlutterI18n.translate(context, 'errorReport')}&body=${FlutterI18n.translate(context, 'emailDescribeError')}\n\n\n\n\n${FlutterI18n.translate(context, 'emailDontRemoveInfo')}\n---\n${await BuildEnvironment.getAppInfo()}\n---\n');

      await url_launcher.launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
      return;
    case UriType.link:
      uri = Uri.parse(input);

      await url_launcher.launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
      return;
  }
}
