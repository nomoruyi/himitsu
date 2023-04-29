import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/app/widgets/widgets.export.dart';
import 'package:himitsu_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:himitsu_app/utils/format_util.dart';
import 'package:himitsu_app/utils/utils.export.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //region VARIABLES
  final ValueNotifier<bool> _loginEnabled = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);

  final _loginFormKey = GlobalKey<FormState>(debugLabel: 'Login Button Enabled?');

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

  late final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);

  final TestUser user = TestUser.current;

  //endregion

  //region METHODS
  //endregion

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<AuthBloc, AuthState>(
          bloc: _authBloc,
          listenWhen: (prev, current) => current is LoginState,
          listener: (context, state) {
            if (state is LoginFailed) {
              Flushbar(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                messageColor: oekoSnow,
                title: FlutterI18n.translate(context, state.errorKey),
                message: 'Error key: ${state.errorKey}',
                duration: const Duration(seconds: 5),
              ).show(context);
            } else if (state is LoginSuccessful) {
              context.pushNamed('tours');
            }
          },
          builder: (context, state) {
            if (state is VerifyingLogin) {
              return LoadingWidget(
                child: _buildLoginScreen(context),
              );
            }
            return _buildLoginScreen(context);
          }),
    );
  }

  Widget _buildLoginScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: Form(
            key: _loginFormKey,
            onChanged: () => _loginEnabled.value = _loginFormKey.currentState?.validate() ?? false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Image(
                      image: AssetImage(settingsProvider.theme == ThemeMode.light
                          ? 'assets/logos/bio_courier_logo.png'
                          : 'assets/logos/bio_courier_logo_dark.png')),
                ),
                Flexible(
                  flex: 3,
                  child: _buildTextFields(context),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLoginButton(),
                      if (kDebugMode) _buildProceedWithoutLoginButton(),
                      const Divider(height: 8.0, thickness: 0, color: Colors.transparent),
                      _buildSettingsButton(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //region WIDGETS
  Widget _buildTextFields(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextFormField(
          controller: _usernameController,
          validator: (value) => isStringNotEmpty(value) ? null : FlutterI18n.translate(context, 'auth.login.usernameMissing'),
          decoration: InputDecoration(
            isDense: true,
            hintText: FlutterI18n.translate(context, 'auth.login.username'),
            hintStyle: TextStyle(fontSize: TextSize.medium),
            prefixIcon: const Icon(Icons.person_2_outlined, size: 24),
          ),
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
        ),
        const Divider(height: 16.0, color: Colors.transparent),
        ValueListenableBuilder(
            valueListenable: _obscureText,
            builder: (context, value, child) {
              return TextFormField(
                controller: _passwordController,
                validator: (value) => isStringNotEmpty(value) ? null : FlutterI18n.translate(context, 'auth.login.passwordMissing'),
                obscureText: value,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: FlutterI18n.translate(context, 'auth.login.password'),
                  hintStyle: TextStyle(fontSize: TextSize.medium),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 24),
                  suffixIcon: SwitchVisibilityIconButton(
                    onPressed: () => _obscureText.value = !_obscureText.value,
                    value: value,
                  ),
                ),
                maxLines: 1,
                keyboardType: TextInputType.text,
              );
            }),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: _loginEnabled,
        builder: (context, enabled, child) {
          return ElevatedButton(
            onPressed: enabled ? () => _authBloc.add(Login(username: _usernameController.text, password: _passwordController.text)) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                FlutterI18n.translate(context, 'auth.login.'),
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: 1, fontSize: TextSize.medium, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProceedWithoutLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => _authBloc.add(Login(username: user.username, password: user.password)),
        child: Text(
          FlutterI18n.translate(context, 'auth.login.proceedWithoutLogin'),
          textAlign: TextAlign.center,
          style: TextStyle(letterSpacing: 1, fontSize: TextSize.medium),
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => context.pushNamed('settings'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            FlutterI18n.translate(context, 'settings.'),
            textAlign: TextAlign.center,
            style: TextStyle(letterSpacing: 1, fontSize: TextSize.medium, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
//endregion
}
