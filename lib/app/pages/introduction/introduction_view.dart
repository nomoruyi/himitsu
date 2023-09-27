import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/utils/utils.export.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  //region METHODS
  Future<void> closeIntroduction(BuildContext context) async {
/*
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('firstInitialization', false);
    });
*/

    final authBox = Hive.box<AuthData>('auth');

    authBox.put('authData', AuthData(firstInitialization: false));

    context.pushNamed(Routes.home.name);
  }

  //endregion

  @override
  void initState() {
    super.initState();
/*
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: IntroSlider(
            prevButtonStyle: ButtonStyle(textStyle: MaterialStateProperty.all<TextStyle?>(TextStyle(fontSize: TextSize.medium))),
            nextButtonStyle: ButtonStyle(textStyle: MaterialStateProperty.all<TextStyle?>(TextStyle(fontSize: TextSize.medium))),
            doneButtonStyle: ButtonStyle(textStyle: MaterialStateProperty.all<TextStyle?>(TextStyle(fontSize: TextSize.medium))),
            skipButtonStyle: ButtonStyle(textStyle: MaterialStateProperty.all<TextStyle?>(TextStyle(fontSize: TextSize.medium))),
            backgroundColorAllTabs: Theme.of(context).primaryColor,
            onSkipPress: () => closeIntroduction(context),
            onDonePress: () => closeIntroduction(context),
            listCustomTabs: [_buildFirstSlide(), _buildSecondSlide(), _buildThirdSlide()],
            navigationBarConfig: NavigationBarConfig(padding: EdgeInsets.zero),
          ),
        ),
      ),
    );
  }

  //region WIDGETS
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

//endregion
}
