part of '../introduction_view.dart';

class BatteryOptimizationSlide extends StatelessWidget {
  const BatteryOptimizationSlide(this.status, {super.key});

  final ValueNotifier<PermissionStatus> status;
  // TODO: Permission should NOT be granted
  Future<void> _requestIgnoreBatteryOptimizationPermission() async {
    status.value = await Permission.ignoreBatteryOptimizations.status;

    if (status.value != PermissionStatus.granted) {
      await AppSettings.openAppSettings(type: AppSettingsType.batteryOptimization);

      status.value = await Permission.ignoreBatteryOptimizations.status;

      log.d('${status.value}   SHEEEEEEEESH');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              FlutterI18n.translate(context, 'introduction.battery.title'),
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: TextSize.extraLarge),
            ),
            Text(FlutterI18n.translate(context, 'introduction.battery.content'), style: TextStyle(fontSize: TextSize.large)),
            ElevatedButton(
                onPressed: _requestIgnoreBatteryOptimizationPermission,
                child: Text(FlutterI18n.translate(context, 'introduction.battery.button'),
                    textAlign: TextAlign.center, style: TextStyle(fontSize: TextSize.large)))
          ],
        ),
      )),
    );
  }
}
