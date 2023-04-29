// ignore_for_file: constant_identifier_names

/*
import 'package:driver_app/app/app.dart';
import 'package:driver_app/app/views/auth/license_view.dart';
import 'package:driver_app/app/views/auth/login_view.dart';
import 'package:driver_app/app/views/base/base_view.dart';
import 'package:driver_app/app/views/base/load_up/station_details.dart';
import 'package:driver_app/app/views/base/sort_and_search/sort_view.dart';
import 'package:driver_app/app/views/base/tour_selection_view.dart';
import 'package:driver_app/app/views/introduction/introduction_view.dart';
import 'package:driver_app/app/views/settings/settings_view.dart';
import 'package:driver_app/app/views/settings/sub_settings/status_view.dart';
import 'package:driver_app/app/views/settings/sub_settings/version_protocol_view.dart';
import 'package:driver_app/backend/models/models.export.dart';
import 'package:driver_app/utils/settings_util.dart';
*/
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/app/app.dart';
import 'package:himitsu_app/app/views/auth/license_view.dart';
import 'package:himitsu_app/app/views/auth/login_view.dart';
import 'package:himitsu_app/app/views/base/chats/chats_view.dart';
import 'package:himitsu_app/app/views/introduction/introduction_view.dart';
import 'package:himitsu_app/utils/settings_util.dart';

enum Routes {
  home,
  introduction,
  license,
  login,
  chats,
  settings,
  status,
  versionsProtocol,
  userData,
  imprint,
  error,
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.home.name,
      path: '/',
      builder: (context, state) => const MainView(),
/*      redirect: (context, state) {
        if ('isFirstInit' == '') return Routes.introduction.name;
        if ('userLoggedIn' == '') return Routes.tour.name;
        return Routes.login.name;
      },*/
      routes: [
        GoRoute(
          name: Routes.introduction.name,
          path: Routes.introduction.name,
          builder: (context, state) => const IntroductionView(),
        ),
        GoRoute(
          name: Routes.license.name,
          path: Routes.license.name,
          builder: (context, state) => const LicenseView(),
        ),
        GoRoute(
          name: Routes.login.name,
          path: Routes.login.name,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          name: Routes.chats.name,
          path: Routes.chats.name,
          builder: (context, state) => const ChatsView(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);

Widget _buildSlideTransition2(context, animation, secondaryAnimation, child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

Widget _buildSlideTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(animation),
    child:
        child /*SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset.zero,
                            end: const Offset(-1.0, 0.0),
                          ).animate(secondaryAnimation),
                          child: child,
                        )*/
    ,
  );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            FlutterI18n.translate(context, 'error.http.4xx'),
            style: TextStyle(fontSize: TextSize.extraLarge, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.background),
          ),
        ),
      ),
    );
  }
}