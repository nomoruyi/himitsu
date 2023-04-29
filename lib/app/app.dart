import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/app/widgets/loading_widget.dart';
import 'package:himitsu_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:himitsu_app/utils/router_util.dart';
import 'package:himitsu_app/utils/settings_util.dart';
import 'package:provider/provider.dart';

class Himitsu extends StatelessWidget {
  const Himitsu({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      builder: (context, child) {
        final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);

        WidgetsBinding.instance.window.platformDispatcher.onPlatformBrightnessChanged = () {
          if (settingsProvider.useSystemTheme) {
            settingsProvider.theme =
                ThemeMode.values.firstWhere((element) => element.name == SchedulerBinding.instance.platformDispatcher.platformBrightness.name);
          }
        };

        TextSize.selectedUIType = settingsProvider.size;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: settingsProvider.getUiOverlyStyle(),
          child: MultiBlocProvider(
            providers: [
              // BlocProvider(create: (context) => NetworkBloc()..add(NetworkObserve())),
              BlocProvider(create: (context) => AuthBloc()),
            ],
            child: MaterialApp.router(
              title: 'Himitsu',
              routerConfig: router,
              localizationsDelegates: [
                FlutterI18nDelegate(
                    translationLoader: FileTranslationLoader(fallbackFile: 'de', basePath: 'assets/i18n'),
                    missingTranslationHandler: (key, locale) => debugPrint('--- Missing Key: $key, languageCode: ${locale?.languageCode}')),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: SettingsProvider.allSupportedLocales,
              locale: settingsProvider.language,
              // TODO: Use ".copyWith(...)" methode to update font size from single point (here) instead of in every text widget
              theme: oekoLightTheme,
              darkTheme: oekoDarkTheme,
              themeMode: settingsProvider.theme,
            ),
          ),
        );
      },
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final AuthBloc _initializationBloc = BlocProvider.of<AuthBloc>(context);
  late final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);

  @override
  void initState() {
    super.initState();

    _initializationBloc.add(InitializeApp());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => _initializationBloc,
      child: Builder(builder: (context) {
        return BlocListener<AuthBloc, AuthState>(
          bloc: _initializationBloc,
          listenWhen: (prev, current) => current is InitializationState,
          listener: (_, state) {
            if (state is ShowIntroductionSlides) {
              context.pushNamed(Routes.introduction.name);
            } else if (state is ShowLicenseView) {
              context.pushNamed(Routes.license.name);
/*
            } else if (state is LogoutSuccessful) {
              while(context.canPop()) {
                context.pop();
              }
              context.pushNamed('login');
*/
            } else if (state is ShowLoginView) {
              context.pushNamed(Routes.login.name);
            } else if (state is StartMainApp) {
              context.pushNamed(Routes.chats.name);
            }
          },
          child: LoadingWidget(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Image(
                    image: AssetImage(
                        settingsProvider.theme == ThemeMode.light ? 'assets/logos/bio_courier_logo.png' : 'assets/logos/bio_courier_logo_dark.png')),
              ),
            ),
          ),
        );
      }),
    );
  }
}
