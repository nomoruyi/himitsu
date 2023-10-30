// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/app/app.dart';
import 'package:himitsu_app/app/pages/auth/license_view.dart';
import 'package:himitsu_app/app/pages/auth/login_view.dart';
import 'package:himitsu_app/app/pages/base/channel_page.dart';
import 'package:himitsu_app/app/pages/base/channels_list_page.dart';
import 'package:himitsu_app/app/pages/base/create_channel_page.dart';
import 'package:himitsu_app/app/pages/introduction/introduction_view.dart';
import 'package:himitsu_app/utils/settings_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

enum Routes {
  home,
  introduction,
  license,
  login,
  channels_list,
  channel,
  settings,
  status,
  versionsProtocol,
  userData,
  imprint,
  error,
  createChannel,
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
        GoRoute(name: Routes.channels_list.name, path: Routes.channels_list.name, builder: (context, state) => const ChannelsListPage(), routes: [
          GoRoute(
            name: Routes.createChannel.name,
            path: Routes.createChannel.name,
            builder: (context, state) => const CreateChannelView(),
          ),
          GoRoute(
            name: Routes.channel.name,
            path: '${Routes.channel.name}/:channel_id',
            builder: (context, state) => ChannelPage(channel: state.extra as Channel),
          ),
        ]),
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
  const ErrorScreen({super.key});

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
