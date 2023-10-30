import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/app/widgets/widgets.export.dart';
import 'package:himitsu_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:himitsu_app/utils/utils.export.dart';

class LicenseView extends StatefulWidget {
  const LicenseView({super.key});

  @override
  State<LicenseView> createState() => _LicenseViewState();
}

class _LicenseViewState extends State<LicenseView> {
  //region VARIABLES
  late final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
  final TextEditingController _licenseController = TextEditingController();

  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);
  //endregion

  @override
  void initState() {
    super.initState();

    _licenseController.addListener(() {
      _enableButtonNotifier.value = _licenseController.text.length >= 24;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<AuthBloc, AuthState>(
              bloc: _authBloc,
              listenWhen: (prev, current) => current is LicenseState,
              listener: (context, state) {
                if (state is LicenseInvalid) {
                  Flushbar(
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    messageColor: oekoSnow,
                    title: 'Fehler',
                    message: 'Der eingegebene Lizenz-Schlüssel ist ungültig. Bitte versuchen Sie es erneut.',
                    duration: const Duration(seconds: 5),
                  ).show(context);
                } else if (state is LicenseValid) {
                  context.pushNamed(Routes.home.name);
                }
              },
              builder: (context, state) {
                if (state is VerifyingLicense) {
                  return LoadingWidget(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                                controller: _licenseController,
                                inputFormatters: [
                                  _MaskedTextInputFormatter(
                                    mask: '****-****-****-****-****',
                                    separator: '-',
                                  )
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 24,
                                decoration: const InputDecoration(hintText: 'XXXX-XXXX-XXXX-XXXX-XXXX', hintStyle: TextStyle(letterSpacing: 1.5))),
                            const Divider(height: 34.0, thickness: 0.0, color: Colors.transparent),
                            ElevatedButton(onPressed: () => {}, child: const Text('Validate')),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                            controller: _licenseController,
                            inputFormatters: [
                              _MaskedTextInputFormatter(
                                mask: '****-****-****-****-****',
                                separator: '-',
                              )
                            ],
                            textAlign: TextAlign.center,
                            maxLength: 24,
                            decoration: const InputDecoration(hintText: 'XXXX-XXXX-XXXX-XXXX-XXXX', hintStyle: TextStyle(letterSpacing: 1.5))),
                        const Divider(height: 34.0, thickness: 0.0, color: Colors.transparent),
                        ValueListenableBuilder(
                            valueListenable: _enableButtonNotifier,
                            builder: (context, enabled, child) {
                              if (enabled) {
                                return ElevatedButton(
                                    onPressed: () => _authBloc.add(VerifyLicense(_licenseController.text)), child: const Text('Validate'));
                              } else {
                                return const ElevatedButton(onPressed: null, child: Text('Validate'));
                              }
                            })
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class _MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  _MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) : super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
