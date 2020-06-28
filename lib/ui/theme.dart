import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NexusTheme {
  ///
  /// THEME CONSTANTS
  ///

  static const _borderRadius = BorderRadius.all(Radius.circular(16.0));
  static const MaterialColor _materialColor =
      const MaterialColor(0xFF142850, const {
    50: const Color(0xFFE2E5EA),
    100: const Color(0xFFB8BECA),
    200: const Color(0xFF8893A70),
    300: const Color(0xFF586884),
    400: const Color(0xFF354769),
    500: primary,
    600: const Color(0xFF0F2348),
    700: const Color(0xFF0C1D3F),
    800: const Color(0xFF0A1736),
    900: const Color(0xFF050E266)
  });

  static DialogTheme _dialogTheme = DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      backgroundColor: background);

  static ButtonThemeData _buttonTheme = ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
      shape: RoundedRectangleBorder(borderRadius: _borderRadius));

  static InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.fromLTRB(16.0, 4.0, 2.0, 4.0),
    filled: true,
    border: InputBorder.none,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: lightGrey),
      borderRadius: _borderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: lightGrey),
      borderRadius: _borderRadius,
    ),
  );

  ///
  /// THEME FUNCTIONS
  ///

  static ChipThemeData _chipTheme(BuildContext context) {
    return ChipThemeData(
        backgroundColor: dark,
        disabledColor: grey,
        selectedColor: _materialColor.shade500,
        secondarySelectedColor: _materialColor.shade300,
        labelPadding: EdgeInsets.only(left: 4.0, right: 4.0),
        padding: EdgeInsets.all(8.0),
        labelStyle:
            GoogleFonts.openSans(textStyle: Theme.of(context).textTheme.button)
                .apply(color: textLight, fontWeightDelta: 2),
        secondaryLabelStyle:
            GoogleFonts.openSans(textStyle: Theme.of(context).textTheme.button)
                .apply(color: textDark, fontWeightDelta: 2),
        brightness: Brightness.dark,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
        ));
  }

  static TextTheme _textTheme(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var theme = TextTheme(
      headline1: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline1
              .copyWith(fontWeight: FontWeight.w800, color: dark)),
      headline2: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline2
              .copyWith(fontWeight: FontWeight.w800, color: dark)),
      headline3: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline3
              .copyWith(fontWeight: FontWeight.w900, color: dark)),
      headline4: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline4
              .copyWith(fontWeight: FontWeight.w900, color: dark)),
      headline5: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline5.copyWith(fontSize: 24.0)),
      headline6: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline6.copyWith(fontWeight: FontWeight.w700)),
      subtitle1: GoogleFonts.openSans(textStyle: textTheme?.subtitle1),
      bodyText1: GoogleFonts.openSans(textStyle: textTheme?.bodyText1),
      bodyText2: GoogleFonts.openSans(textStyle: textTheme?.bodyText2),
      caption: GoogleFonts.openSans(textStyle: textTheme?.caption),
      button: GoogleFonts.sourceSansPro(textStyle: textTheme?.button),
      subtitle2: GoogleFonts.openSans(textStyle: textTheme?.subtitle2),
      overline: GoogleFonts.sourceSansPro(textStyle: textTheme?.overline),
    );
    return theme;
  }

  static AppBarTheme _appBarTheme(BuildContext context) {
    return Theme.of(context).appBarTheme.copyWith(
        color: NexusTheme.background,
        brightness: Brightness.light,
        iconTheme:
            Theme.of(context).iconTheme.copyWith(color: NexusTheme.textLight));
  }

  ///
  /// THEME
  ///

  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: _materialColor,
        backgroundColor: background,
        scaffoldBackgroundColor: background,
        canvasColor: background,
        cardColor: backgroundGrey,
        cursorColor: dark,
        dividerColor: grey,
        dialogTheme: _dialogTheme,
        inputDecorationTheme: _inputDecorationTheme,
        chipTheme: _chipTheme(context),
        textTheme: _textTheme(context),
        appBarTheme: _appBarTheme(context),
        buttonTheme: _buttonTheme);
  }

  ///
  /// COLORS
  ///

  static const primary = const Color(0xFF142850);
  static const dark = const Color(0xFF353535);
  static const grey = const Color(0xFF555555);
  static const backgroundGrey = const Color(0xFFf4f5f7);
  static const background = const Color(0xFFFFFFFF);

  static const lightGrey = const Color(0xFFeeeff4);
  static const blue = const Color(0xFF4680FF);

  static const textLight = const Color(0xFFFFFFFF);
  static const textLightMedium = const Color(0xFF959595);
  static const textMedium = const Color(0xFF353535);
  static const textDark = const Color(0xFF1d1d24);

  //Buttons
  static const buttonActive = const Color(0xff1b48a1);
  static const buttonNormal = const Color(0xff);
  static const buttonDisabled = const Color(0xff);
  static const buttonDarkActive = const Color(0xff);
  static const buttonDarkNormal = const Color(0xff1e2845);
  static const buttonDarkDisabled = const Color(0xff);

  static const secondary = const Color(0xFF0c4767);
  static const surface = const Color(0xFFeaebed);
  static const warning = const Color(0xFFfe9920);
  static const danger = const Color(0xFFFB617F);
}
