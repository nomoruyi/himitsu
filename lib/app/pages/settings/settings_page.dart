import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/app/widgets/app_bar_widget.dart';
import 'package:himitsu_app/utils/utils.export.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //region VARIABLES
  late final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: true);

  // late final Size deviceSize = MediaQuery.of(context).size;

  //endregion

  @override
  Widget build(BuildContext context) {
    // Size deviceSize = MediaQuery.of(context).size;

    return ColorfulSafeArea(
      topColor: Theme.of(context).cardColor,
      bottomColor: Theme.of(context).cardColor,
      child: Scaffold(
        appBar: HimitsuAppBar(
          leading: BackButton(onPressed: () => context.pop()),
          title: Text(FlutterI18n.translate(context, 'settings.'), style: TextStyle(fontSize: TextSize.large)),
        ),
        body: SettingsList(
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
            settingsSectionBackground: Theme.of(context).cardColor,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
            settingsSectionBackground: Theme.of(context).cardColor,
          ),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
          applicationType: Theme.of(context).platform == TargetPlatform.iOS ? ApplicationType.cupertino : ApplicationType.material,
          sections: [
            //region MISC
            SettingsSection(
              title: Text(FlutterI18n.translate(context, 'settings.general.'),
                  style: TextStyle(fontSize: TextSize.large, color: Theme.of(context).primaryColor)),
              tiles: [
                SettingsTile(
                  title: Text(
                    FlutterI18n.translate(context, 'settings.general.userId.').toUpperCase(),
                    style: TextStyle(fontSize: TextSize.large),
                  ),
                  trailing: InkWell(
                    onLongPress: () => Clipboard.setData(ClipboardData(text: ClientUtil.user.id)).then((value) =>
                        FlushbarUtil.success(context, message: FlutterI18n.translate(context, 'settings.general.userId.notification')).show(context)),
                    child: Text(ClientUtil.user.id, style: TextStyle(fontSize: TextSize.large, fontWeight: FontWeight.bold)),
                  ),
                ),
                SettingsTile(
                  title: Text(FlutterI18n.translate(context, 'settings.general.language.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: _buildLanguageSelection(),
                ),
                SettingsTile(
                  title: Text(FlutterI18n.translate(context, 'settings.general.size.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: _buildUISizeSelection(),
                ),
                SettingsTile(
                  title: Text(FlutterI18n.translate(context, 'settings.general.theme.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: _buildThemeToggle(context),
                ),
              ],
            ),
            //endregion

            //region INFO
            SettingsSection(
              title: Text(FlutterI18n.translate(context, 'settings.info.'),
                  style: TextStyle(fontSize: TextSize.large, color: Theme.of(context).primaryColor)),
              tiles: [
                SettingsTile.navigation(
                  // onPressed: (context) => context.pushNamed(Routes.status.name),
                  title: Text(FlutterI18n.translate(context, 'settings.info.status.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: Icon(Icons.adaptive.arrow_forward),
                ),
                SettingsTile.navigation(
                  // onPressed: (context) => context.pushNamed(Routes.versionsProtocol.name),
                  title: Text(FlutterI18n.translate(context, 'settings.info.versionsProtocol.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: Icon(Icons.adaptive.arrow_forward),
                ),
                SettingsTile.navigation(
                  // onPressed: (context) => context.pushNamed(Routes.userData.name),
                  title: Text(FlutterI18n.translate(context, 'settings.info.userData.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: Icon(Icons.adaptive.arrow_forward),
                ),
                SettingsTile.navigation(
                  // onPressed: (context) => context.pushNamed(Routes.imprint.name),
                  title: Text(FlutterI18n.translate(context, 'settings.info.imprint.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: Icon(Icons.adaptive.arrow_forward),
                ),
                SettingsTile.navigation(
                  onPressed: (context) => showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset(
                        'assets/icons/himitsu_app_icon.png',
                        fit: BoxFit.contain,
                        width: 100.0,
                      ),
                      applicationName: env.info.appName,
                      applicationVersion: 'Version\n${env.info.version}',
                      applicationLegalese: env.flavor.name.toUpperCase()),
                  title: Text(FlutterI18n.translate(context, 'settings.info.appInfo.'), style: TextStyle(fontSize: TextSize.medium)),
                  trailing: Icon(Icons.adaptive.arrow_forward),
                )
              ],
            ),
            //endregion

            //region VERSION
/*            SettingsSection(
                  tiles: [
                    SettingsTile(
                      title: const Divider(
                        color: Colors.transparent,
                        height: 20.0,
                      ),
                      description: FutureBuilder(
                          future: BuildEnvironment.getAppInfo(),
                          builder: (context, snapshot) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(snapshot.data ?? '', style: TextStyle(fontSize: TextSize.small), textAlign: TextAlign.center),
                              ],
                            );
                          }),
                    ),
                  ],
                ),*/
            //endregion
          ],
        ),
      ),
    );
  }

  //region WIDGETS
  Widget _buildLanguageSelection() {
    List<DropdownMenuItem> languages = [
      DropdownMenuItem(
        value: SettingsProvider.allSupportedLocales[0],
        alignment: AlignmentDirectional.centerEnd,
        child: Text('${FlutterI18n.translate(context, 'settings.general.language.german')} ${SettingsProvider.getLocaleFlag('de')}',
            style: TextStyle(fontSize: TextSize.medium)),
      ),
      DropdownMenuItem(
        value: SettingsProvider.allSupportedLocales[1],
        alignment: AlignmentDirectional.centerEnd,
        child: Text('${FlutterI18n.translate(context, 'settings.general.language.english')} ${SettingsProvider.getLocaleFlag('en')}',
            style: TextStyle(fontSize: TextSize.medium)),
      ),
    ];

    return DropdownButton(
      onChanged: (value) {
        // setState(() {
        settingsProvider.language = value;
        //  });
      },
      icon: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.language_rounded, color: Theme.of(context).colorScheme.secondary)),
      items: languages,
      value: settingsProvider.language,
    );
  }

  Widget _buildUISizeSelection() {
    List<DropdownMenuItem> sizes = [
      DropdownMenuItem(
        value: SettingsProvider.allSupportedSizes[0],
        alignment: AlignmentDirectional.centerEnd,
        child: Text(FlutterI18n.translate(context, 'settings.general.size.small'), style: TextStyle(fontSize: TextSize.medium)),
      ),
      DropdownMenuItem(
        value: SettingsProvider.allSupportedSizes[1],
        alignment: AlignmentDirectional.centerEnd,
        child: Text(FlutterI18n.translate(context, 'settings.general.size.normal'), style: TextStyle(fontSize: TextSize.medium)),
      ),
      DropdownMenuItem(
        value: SettingsProvider.allSupportedSizes[2],
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          FlutterI18n.translate(context, 'settings.general.size.large'),
          style: TextStyle(fontSize: TextSize.medium),
        ),
      ),
    ];

    return DropdownButton(
      onChanged: (value) {
        // setState(() {
        settingsProvider.size = value;
        // });
      },
      icon: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.format_size, color: Theme.of(context).colorScheme.secondary),
      ),
      items: sizes,
      value: settingsProvider.size,
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    toggleSystemTheme(bool useSystemTheme) {
      settingsProvider.useSystemTheme = useSystemTheme;

      settingsProvider.theme =
          ThemeMode.values.firstWhere((element) => element.name == SchedulerBinding.instance.platformDispatcher.platformBrightness.name);
    }

    switchDarkMode(bool darkModeEnabled) => darkModeEnabled ? settingsProvider.theme = ThemeMode.dark : settingsProvider.theme = ThemeMode.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(FlutterI18n.translate(context, 'settings.general.theme.light'),
                style: TextStyle(fontSize: TextSize.medium, fontWeight: FontWeight.w200)),
            Switch.adaptive(
              onChanged: settingsProvider.useSystemTheme ? null : (darkModeEnabled) => switchDarkMode(darkModeEnabled),
              value: settingsProvider.theme == ThemeMode.dark,
            ),
            Text(FlutterI18n.translate(context, 'settings.general.theme.dark'),
                style: TextStyle(
                  fontSize: TextSize.medium,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(FlutterI18n.translate(context, 'settings.general.theme.useSystemTheme'), maxLines: 2, style: TextStyle(fontSize: TextSize.medium)),
            Checkbox(tristate: false, value: settingsProvider.useSystemTheme, onChanged: (value) => toggleSystemTheme(value!))
          ],
        )
      ],
    );
  }

//endregion
}
