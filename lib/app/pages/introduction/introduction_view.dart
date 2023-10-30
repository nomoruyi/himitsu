import 'package:app_settings/app_settings.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/backend/auth_service/auth_service.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:himitsu_app/utils/utils.export.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'slides/slide_battery.dart';
part 'slides/slide_welcome.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({super.key});

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  final List<ValueNotifier<PermissionStatus>> _permissions = [ValueNotifier(PermissionStatus.denied)];
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  //region METHODS
  Future<void> _closeIntroduction(BuildContext context) async {
    AuthData? authData = AuthService.authBox.get('auth');

    authData ??= AuthData(firstInitialization: false);
    AuthService.authBox.put('auth', authData).then((value) => context.pushNamed(Routes.home.name));
  }

  bool _allPermissionsGranted() {
    for (ValueNotifier<PermissionStatus> perm in _permissions) {
      if (perm.value != PermissionStatus.granted) return false;
    }

    return true;
  }

  //endregion

  @override
  void initState() {
    _permissions.addAll([ValueNotifier(PermissionStatus.denied), ValueNotifier(PermissionStatus.denied)]);

    super.initState();

    for (ValueNotifier permission in _permissions) {
      permission.addListener(() => setState(() {
            log.f('DIGGA WTF');
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ColorfulSafeArea(
        topColor: Theme.of(context).cardColor,
        bottomColor: Theme.of(context).cardColor,
        child: Scaffold(
          body: IntroSlider(
            isShowSkipBtn: false,
            // isShowDoneBtn: value == PermissionStatus.granted,
            prevButtonStyle: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: TextSize.medium, color: oekoBackgroundLight)),
            nextButtonStyle: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: TextSize.medium, color: oekoBackgroundLight)),
            doneButtonStyle: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: TextSize.medium, color: oekoBackgroundLight)),
            // skipButtonStyle: ButtonStyle(textStyle: MaterialStateProperty.all<TextStyle?>(TextStyle(fontSize: TextSize.medium))),
            backgroundColorAllTabs: Theme.of(context).primaryColor,
            onDonePress: () => _closeIntroduction(context),
            // onSkipPress:  () => closeIntroduction(context),
            listCustomTabs: [const WelcomeSlide(), BatteryOptimizationSlide(_permissions[0])],
            navigationBarConfig: NavigationBarConfig(padding: EdgeInsets.zero),
          ),
        ),
      ),
    );
  }

//region WIDGETS
/*
 Widget _buildFirstSlide() {
    return Scaffold(
      body: Center(
          child: Text(
        'INTRODUCTION 1',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: TextSize.large),
      )),
    );
  }

  Widget _buildSecondSlide() {
    return Scaffold(
      body: Center(
          child: Text(
        'INTRODUCTION 2',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: TextSize.large),
      )),
    );
  }

  Widget _buildThirdSlide() {
    return Scaffold(
      body: Center(
          child: Text(
        'INTRODUCTION 3',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: TextSize.large),
      )),
    );
  }
  */

//endregion
}
