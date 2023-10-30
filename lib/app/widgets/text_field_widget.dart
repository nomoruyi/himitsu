import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:himitsu_app/utils/settings_util.dart';

class HimitsuTextField extends StatelessWidget {
  const HimitsuTextField({
    super.key,
    this.initialValue,
    required this.controller,
    this.obscureText = false,
    this.isPassword = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines,
    this.maxCharacters,
    this.width,
    this.height = 56,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    this.enabled = true,
    this.textOverflow = TextOverflow.ellipsis,
  });

  //region VARIABLES
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final bool isPassword;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final int? maxCharacters;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final TextOverflow? textOverflow;
  final bool enabled;

  //endregion

  //region METHODS

  //endregion

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /*   width: width,
      height: height,*/
      child: TextFormField(
        enabled: enabled,
        onTap: onTap,
        enableInteractiveSelection: !isPassword,
        enableIMEPersonalizedLearning: !isPassword,
        // TODO: Try getting input text AND hint text to align center; Currently only input is center with "TextAlign.center"
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        initialValue: initialValue,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxCharacters,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        obscureText: obscureText,
        readOnly: isPassword,
        keyboardType: keyboardType,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        controller: controller,
        validator: (value) => validator!(value),
        style: TextStyle(fontSize: TextSize.medium, overflow: textOverflow),
        decoration: InputDecoration(
          isDense: true,
          label: Text(hintText ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TextSize.medium,
                color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                fontWeight: FontWeight.w100,
                height: 1.25,
              )),
          labelStyle: TextStyle(
            fontSize: TextSize.small,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            fontWeight: FontWeight.w100, /*height: 2,*/
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            fontSize: TextSize.small,
            fontWeight: FontWeight.w100,
            overflow: TextOverflow.fade, /*height: 2,*/
          ),
          counterStyle: TextStyle(
            fontSize: TextSize.small,
            // color: oekoWhiteTranslucent,
          ),
          contentPadding: contentPadding,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          alignLabelWithHint: false,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: prefixIcon,
                )
              : null,
          suffixIcon: suffixIcon,
          fillColor: oekoSnow,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0),
          ),

          //hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.background, width: 0.5),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class SwitchVisibilityIconButton extends StatelessWidget {
  const SwitchVisibilityIconButton({super.key, required this.onPressed, required this.value, this.size = 24});

  final void Function() onPressed;
  final bool value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: value ? Icon(Icons.visibility, size: size) : Icon(Icons.visibility_off_outlined, size: size),
      onPressed: onPressed,
    );
  }
}
