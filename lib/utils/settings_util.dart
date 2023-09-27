import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

// TEXT STYLES

enum UIType { compact, standard, comfortable }

class SettingsProvider extends ChangeNotifier {
  static final settings = Hive.box('settings');

  //region LANGUAGE
  String _language = settings.get('language');

  static final List<Locale> allSupportedLocales = [
    const Locale('de', null), // German, no country code
    const Locale('en', null), // English, no country code
  ];

  Locale get language => Locale(_language);

  set language(Locale newLocale) {
    if (!allSupportedLocales.contains(newLocale)) return;

    settings.put('language', newLocale.languageCode);
    _language = newLocale.languageCode;
    notifyListeners();
  }

  static String? getLocaleFlag(String localeCode) {
    switch (localeCode) {
      case 'de':
        return '🇩🇪';
      case 'en':
        return '🇬🇧';
      default:
        return null;
    }
  }

  //endregion

  //region SIZE
  String _size = settings.get('size');
  static final List<String> allSupportedSizes = [UIType.compact.name, UIType.standard.name, UIType.comfortable.name];

  String get size => _size;

  set size(String newSize) {
    if (!allSupportedSizes.contains(newSize)) return;

    settings.put('size', newSize);
    _size = newSize;
    notifyListeners();
  }

  //endregion

  //region THEME
  static final List<String> allSupportedThemes = [ThemeMode.light.name, ThemeMode.dark.name, ThemeMode.system.name];

  String _theme = settings.get('theme');

  ThemeMode get theme => ThemeMode.values.firstWhere((element) => element.name == _theme);

  set theme(ThemeMode newTheme) {
    if (!allSupportedThemes.contains(newTheme.name)) return;

    settings.put('theme', newTheme.name);
    _theme = newTheme.name;
    notifyListeners();
  }

  bool _useSystemTheme = settings.get('useSystemTheme') ?? true;

  bool get useSystemTheme => _useSystemTheme;

  set useSystemTheme(bool value) {
    settings.put('useSystemTheme', value);
    _useSystemTheme = value;
    notifyListeners();
  }

  SystemUiOverlayStyle getUiOverlyStyle() {
    if (useSystemTheme) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
          ? oekoDarkSystemOverlayStyle
          : oekoLightSystemOverlayStyle;
    }

    switch (theme) {
      case ThemeMode.system:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
            ? oekoDarkSystemOverlayStyle
            : oekoLightSystemOverlayStyle;
      case ThemeMode.light:
        return oekoLightSystemOverlayStyle;
      case ThemeMode.dark:
        return oekoDarkSystemOverlayStyle;
    }
  }

/*
  String getAppIconPath() {
    if (useSystemTheme) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.light
          ? 'assets/icons/himitsu_app_icon.png'
          : 'assets/icons/himitsu_app_icon_dark.png';
    }

    switch (theme) {
      case ThemeMode.system:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.light
            ? 'assets/icons/himitsu_app_icon.png'
            : 'assets/icons/himitsu_app_icon_dark.png';
      case ThemeMode.light:
        return 'assets/icons/himitsu_app_icon.png';
      case ThemeMode.dark:
        return 'assets/icons/himitsu_app_icon_dark.png';
    }
  }
*/

  //endregion

  void resetSettings() {
    _language = 'de';
    _size = UIType.standard.name;
    _theme = ThemeMode.system.name;
    notifyListeners();
  }
}

class TextSize {
  static const double _oekoMaxSize = 32.0;
  static const double _oekoExtraLarge = 26.0;
  static const double _oekoLargeText = 20.0;
  static const double _oekoMediumText = 16.0;
  static const double _oekoSmallText = 12.0;
  static const double _oekoTinyText = 10.0;
  static const double _oekoMinSize = 8.0;

  static const String _tiny = 'tiny';
  static const String _small = 'small';
  static const String _medium = 'normal';
  static const String _large = 'large';
  static const String _extraLarge = 'extraLarge';

  //static final settings = Hive.box('settings');
  static final Map<String, Map<String, double>> sizes = {
    UIType.compact.name: {
      _tiny: _oekoMinSize,
      _small: _oekoTinyText,
      _medium: _oekoSmallText,
      _large: _oekoMediumText,
      _extraLarge: _oekoLargeText,
    },
    UIType.standard.name: {
      _tiny: _oekoTinyText,
      _small: _oekoSmallText,
      _medium: _oekoMediumText,
      _large: _oekoLargeText,
      _extraLarge: _oekoExtraLarge,
    },
    UIType.comfortable.name: {
      _tiny: _oekoSmallText,
      _small: _oekoMediumText,
      _medium: _oekoLargeText,
      _large: _oekoExtraLarge,
      _extraLarge: _oekoMaxSize,
    },
  };

  static String selectedUIType = UIType.standard.name;

  static double get tiny => sizes[selectedUIType]![_tiny]!;

  static double get small => sizes[selectedUIType]![_small]!;

  static double get medium => sizes[selectedUIType]![_medium]!;

  static double get large => sizes[selectedUIType]![_large]!;

  static double get extraLarge => sizes[selectedUIType]![_extraLarge]!;
}

//region THEME
// This theme was made for FlexColorScheme version 6.1.1. Make sure
// you use same or higher version, but still same major version. If
// you use a lower version, some properties may not be supported. In
// that case you can also remove them after copying the theme to your app.
final ThemeData oekoLightTheme = FlexThemeData.light(
  scheme: FlexScheme.indigo,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 9,
  appBarElevation: 4.0,
  subThemesData: const FlexSubThemesData(
    buttonMinSize: Size(80.0, 40.0),
    buttonPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    textButtonRadius: 12.0,
    elevatedButtonRadius: 12.0,
    outlinedButtonRadius: 12.0,
    toggleButtonsRadius: 12.0,
    inputDecoratorRadius: 12.0,
    blendOnLevel: 10,
    blendOnColors: false,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
// To use the playground font, add GoogleFonts package and uncomment
  fontFamily: GoogleFonts.poppins().fontFamily,
);
final ThemeData oekoDarkTheme = FlexThemeData.dark(
  scheme: FlexScheme.indigo,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  appBarElevation: 4.0,
  subThemesData: const FlexSubThemesData(
    buttonMinSize: Size(80.0, 40.0),
    buttonPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    textButtonRadius: 12.0,
    elevatedButtonRadius: 12.0,
    outlinedButtonRadius: 12.0,
    toggleButtonsRadius: 12.0,
    inputDecoratorRadius: 12.0,
    blendOnLevel: 20,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
  ),

  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
// To use the Playground font, add GoogleFonts package and uncomment
  fontFamily: GoogleFonts.poppins().fontFamily,
);
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

//OLD THEME DATA
/*

final TextTheme _oekoDarkTextTheme = GoogleFonts.getTextTheme('Poppins', TextTheme(


  labelSmall: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.tiny),
  labelMedium: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.tiny),
  labelLarge: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.tiny),
  bodySmall: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.small),
  bodyMedium: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.medium),
  bodyLarge: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.large),
  headlineSmall: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.extraLarge),
  headlineMedium: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.extraLarge),
  headlineLarge: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500, fontSize: TextSize.extraLarge),

/*
        headline1: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline2: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline3: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline4: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline5: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline6: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        overline: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        subtitle1: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        subtitle2: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        bodyText1: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        bodyText2: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        button: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        caption: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
*/
));

final TextTheme _oekoLightTextTheme = GoogleFonts.getTextTheme(
    'Poppins',
    TextTheme(
      labelSmall: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.tiny),
      labelMedium: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.tiny),
      labelLarge: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.tiny),
      bodySmall: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.small),
      bodyMedium: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.medium),
      bodyLarge: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.large),
      headlineSmall: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.extraLarge),
      headlineMedium: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.extraLarge),
      headlineLarge: TextStyle(color: oekoBackgroundDark, fontWeight: FontWeight.w500, fontSize: TextSize.extraLarge),

/*
        headline1: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline2: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline3: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline4: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline5: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        headline6: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        overline: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        subtitle1: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        subtitle2: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        bodyText1: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        bodyText2: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        button: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
        caption: TextStyle(color: oekoBackgroundLight, fontWeight: FontWeight.w500),
*/
    ));

final ThemeData oekoLightTheme = ThemeData(
  useMaterial3: true,
  visualDensity: VisualDensity.comfortable,
  textTheme: _oekoLightTextTheme,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.green,
    brightness: Brightness.light,
    backgroundColor: oekoBackgroundLight,
    errorColor: Colors.red,
  ).copyWith(secondary: Colors.lightGreenAccent),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((Set<MaterialState> states) {
        return const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0);
      }),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((Set<MaterialState> states) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
      }),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return Colors.grey;
        if (states.contains(MaterialState.focused)) return Colors.lightGreen;
        if (states.contains(MaterialState.hovered)) return Colors.lightGreen;
        return Colors.green;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return Colors.black26;
        return oekoSnow;
      }),
      shadowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) return Colors.blueGrey;
        if (states.contains(MaterialState.hovered)) return Colors.blueGrey;
        return Colors.blueGrey;
      }),
      elevation: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return 0;
        if (states.contains(MaterialState.focused)) return 2.0;
        if (states.contains(MaterialState.hovered)) return 2.0;
        if (states.contains(MaterialState.pressed)) return 1.0;
        if (states.contains(MaterialState.selected)) return 1.0;
        return 4.0;
      }),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((Set<MaterialState> states) {
      return const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0);
    }),
    shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((Set<MaterialState> states) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
    }),
  )),
  appBarTheme: AppBarTheme(
    foregroundColor: oekoSnow,
    backgroundColor: Colors.green,
    titleTextStyle: _oekoDarkTextTheme.bodyLarge,
    elevation: 4.0,
    systemOverlayStyle: oekoLightSystemOverlayStyle,
  ),
  listTileTheme: const ListTileThemeData(
    style: ListTileStyle.list,
    iconColor: oekoMidnight,
    textColor: oekoMidnight,
    tileColor: oekoBackgroundLight,
  ),
  dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 4.0, space: 2.0),
  cardTheme: CardTheme(
      elevation: 4.0, color: Colors.amberAccent.withOpacity(0.75), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.blueGrey),
  toggleButtonsTheme: const ToggleButtonsThemeData(selectedColor: Colors.green),
  primaryColor: Colors.green,
  primaryColorLight: Colors.green,
  primaryColorDark: Colors.green,
  shadowColor: Colors.blueGrey,

  //HINT: MAY NEED TO REMOVE
  scaffoldBackgroundColor: oekoBackgroundLight,
  dialogTheme: const DialogTheme(
    backgroundColor: oekoBackgroundLight,
    elevation: 4.0,
  ),
  cardColor: oekoSnow,
  dividerColor: Colors.grey,
  disabledColor: Colors.grey,
  indicatorColor: oekoSnow,
  focusColor: Colors.green,
  hintColor: Colors.grey,
  // toggleableActiveColor: Colors.green,
);

final ThemeData oekoDarkTheme = ThemeData(
  useMaterial3: true,
  visualDensity: VisualDensity.comfortable,
  textTheme: _oekoDarkTextTheme,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
    backgroundColor: oekoBackgroundDark,
    errorColor: Colors.red,
  ).copyWith(secondary: Colors.greenAccent),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((Set<MaterialState> states) {
        return const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0);
      }),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((Set<MaterialState> states) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
      }),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return Colors.black12;
        if (states.contains(MaterialState.focused)) return Colors.green;
        if (states.contains(MaterialState.hovered)) return Colors.green;
        return Colors.teal;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return Colors.grey;
        return oekoSnow;
      }),
      shadowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) return Colors.blueGrey;
        if (states.contains(MaterialState.hovered)) return Colors.blueGrey;
        return Colors.blueGrey;
      }),
      elevation: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return 0;
        if (states.contains(MaterialState.focused)) return 2.0;
        if (states.contains(MaterialState.hovered)) return 2.0;
        if (states.contains(MaterialState.pressed)) return 2.0;
        return 4.0;
      }),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((Set<MaterialState> states) {
      return const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0);
    }),
    shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((Set<MaterialState> states) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
    }),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      return Colors.teal;
    }),
  )),
  appBarTheme: AppBarTheme(
    foregroundColor: oekoSnow,
    backgroundColor: Colors.teal,
    titleTextStyle: _oekoDarkTextTheme.bodyLarge,
    elevation: 4.0,
    systemOverlayStyle: oekoDarkSystemOverlayStyle,
  ),

  listTileTheme: const ListTileThemeData(
    style: ListTileStyle.list,
    iconColor: oekoSnow,
    textColor: oekoSnow,
    tileColor: oekoBackgroundDark,
  ),
  dividerTheme: const DividerThemeData(color: Colors.blueGrey, thickness: 4.0, space: 2.0),
  cardTheme:
      CardTheme(elevation: 4.0, color: Colors.deepOrange.withOpacity(0.75), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.blueGrey),
  toggleButtonsTheme: const ToggleButtonsThemeData(selectedColor: Colors.teal),

  primaryColor: Colors.teal,
  primaryColorLight: Colors.teal,
  primaryColorDark: Colors.teal,
  shadowColor: Colors.blueGrey,
  scaffoldBackgroundColor: oekoBackgroundDark,
  dialogTheme: const DialogTheme(
    backgroundColor: oekoBackgroundDark,
    elevation: 4.0,
  ),
  cardColor: oekoMidnight,
  dividerColor: Colors.blueGrey,
  disabledColor: Colors.grey,

  focusColor: Colors.teal,
  indicatorColor: oekoSnow,
  hintColor: Colors.grey,
);
*/

final ButtonStyle secondaryButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((Set<MaterialState> states) {
    return const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0);
  }),
  shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((Set<MaterialState> states) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
  }),
  backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return Colors.grey;
    if (states.contains(MaterialState.focused)) return Colors.lightGreen.shade400;
    if (states.contains(MaterialState.hovered)) return Colors.lightGreen.shade400;
    return Colors.greenAccent;
  }),
  foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return Colors.black26;
    return oekoSnow;
  }),
  shadowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
    if (states.contains(MaterialState.focused)) return Colors.blueGrey;
    if (states.contains(MaterialState.hovered)) return Colors.blueGrey;
    return Colors.blueGrey;
  }),
  elevation: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return 0;
    if (states.contains(MaterialState.focused)) return 2.0;
    if (states.contains(MaterialState.hovered)) return 2.0;
    if (states.contains(MaterialState.pressed)) return 1.0;
    if (states.contains(MaterialState.selected)) return 1.0;
    return 4.0;
  }),
);

const Color oekoPrimaryLight = Color(0xFF386A1F);
const Color oekoPrimaryDark = Color(0xFF9CD67E);
const Color oekoBackgroundLight = Color(0xfff7f7f7);
const Color oekoSnow = Color(0xffffffff);
const Color oekoBackgroundDark = Color(0xff0c0f0c);
const Color oekoMidnight = Color(0xff181e18);

/*
const oekoPrimarySystemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.green,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.green,
  systemNavigationBarContrastEnforced: true,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarIconBrightness: Brightness.dark,
);
*/

const oekoLightSystemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: oekoPrimaryLight,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarColor: oekoBackgroundLight,
  systemNavigationBarContrastEnforced: false,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const oekoDarkSystemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: oekoPrimaryDark,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarColor: oekoBackgroundDark,
  systemNavigationBarContrastEnforced: false,
  systemNavigationBarIconBrightness: Brightness.light,
);

/*
const oekoSecondarySystemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Color(0xfff7f7f7),
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Color(0xfff7f7f7),
  systemNavigationBarContrastEnforced: true,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarIconBrightness: Brightness.dark,
);
*/

//endregion

/*
//region FARBEN
//Primary
const Color oekoPrimary = Color(0xFF559900);
const Color oekoPrimaryTranslucent = Color(0x99007700);
const Color oekoPrimaryLight = Color(0xFFDDFF99);
const Color oekoPrimaryLightTranslucent = Color(0x99DDFF99);

const Color oekoPrimaryDark = Color(0xFF111166);
const Color oekoPrimaryDarkTranslucent = Color(0x99111166);
const Color oekoPrimaryGrey = Color(0xFF99AAFF);
const Color oekoPrimaryGreyTranslucent = Color(0x9999AAFF);

//Secondary
const Color oekoSecondary = Color(0xFFFF0077);
const Color oekoSecondaryTranslucent = Color(0x99FF0077);
const Color oekoSecondaryLight = Color(0xFFFF82B5);
const Color oekoSecondaryLightTranslucent = Color(0x99FF82B5);

//Tertiary
const Color oekoTertiary = Color(0xFFFFFF00);
const Color oekoTertiaryTranslucent = Color(0x99FFFF00);

//Warning
//

//Background
const Color oekoBackground = Color(0xFF559900);
const Color oekoBackgroundTranslucent = Color(0x99007700);
const Color oekoBackgroundLight = Color(0xFFDDFF99);
const Color oekoBackgroundLightTranslucent = Color(0x99DDFF99);

//Black - White
const Color oekoBlack = Color(0xFF15152D);
const Color oekoBlackTranslucent = Color(0x9915152D);
const Color oekoGrey = Color(0xFF6D6D6D);
const Color oekoGreyTranslucent = Color(0x996D6D6D);
const Color oekoLightGrey = Color(0xFFAAA9B0);
const Color oekoLightGreyTranslucent = Color(0x99AAA9B0);
const Color oekoSnow = Color(0xFFFFFFFF);
const Color oekoSnowTranslucent = Color(0xFFFFFFFF);
const Color oekoWhite = Color(0xFFF7F7F7);
const Color oekoWhiteTranslucent = Color(0x99F7F7F7);
//endregion



//region TEXT

const oekoHintTextStyle = TextStyle(
  letterSpacing: 1,
  fontWeight: FontWeight.w100,
  color: oekoLightGrey,
);

const oekoLabelStyle = TextStyle(
  letterSpacing: 1,
  color: oekoWhiteTranslucent,
  fontWeight: FontWeight.bold,
);
//endregion


//region BUTTON
final oekoBoxDecorationStyle = BoxDecoration(
  color: oekoPrimaryLight,
  borderRadius: BorderRadius.circular(16.0),
  boxShadow: const [
    BoxShadow(
      color: oekoBlack,
      blurRadius: 10.0,
      offset: Offset(1, 3),
    ),
  ],
);

final oekoPrimaryButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: oekoWhite,
  minimumSize: const Size(64, 48),
  backgroundColor: oekoPrimary,
  elevation: 8,
  shadowColor: oekoBlack,
  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
);

final oekoPrimaryButtonStyleOutlined = TextButton.styleFrom(
  foregroundColor: oekoPrimary,
  backgroundColor: Colors.transparent,
  minimumSize: const Size(64, 48),
  elevation: 0,
  shadowColor: Colors.transparent,
  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0), side: const BorderSide(color: oekoPrimary)),
);

final oekoPrimaryButtonStyleDisabled = ElevatedButton.styleFrom(
  foregroundColor: oekoWhite,
  backgroundColor: oekoPrimaryGrey,
  splashFactory: NoSplash.splashFactory,
  enableFeedback: false,
  minimumSize: const Size(64, 48),
  elevation: 8,
  shadowColor: oekoBlack,
  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
);

final oekoSecondaryButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: oekoWhite,
  backgroundColor: oekoSecondary,
  minimumSize: const Size(64, 48),
  elevation: 8.0,
  shadowColor: oekoBlack,
  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
);

final oekoSecondaryDisabledButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: oekoWhite,
  backgroundColor: oekoSecondaryLight,
  splashFactory: NoSplash.splashFactory,
  enableFeedback: false,
  minimumSize: const Size(64, 48),
  elevation: 8,
  shadowColor: oekoBlack,
  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
);

final oekoTextButtonStyle = TextButton.styleFrom(
  foregroundColor: oekoPrimary,
  elevation: 0,
  shadowColor: Colors.transparent,
  padding: const EdgeInsets.all(0.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
);

const oekoPrimarySystemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: oekoPrimary,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: oekoPrimary,
  systemNavigationBarContrastEnforced: true,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const oekoMixSystemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: oekoPrimary,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: oekoWhite,
  systemNavigationBarContrastEnforced: true,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const oekoSecondarySystemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: oekoWhite,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: oekoWhite,
  systemNavigationBarContrastEnforced: true,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarIconBrightness: Brightness.dark,
);

final ButtonStyle oekoSliderButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: oekoWhite,
  backgroundColor: Colors.transparent,
  textStyle: TextStyle(fontSize: TextSize.normal),
);
//endregion

*/
