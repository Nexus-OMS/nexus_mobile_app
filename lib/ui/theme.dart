import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NexusTheme {
  ///
  /// THEME CONSTANTS
  ///

  static const radius = 16.0;
  static const _borderRadius = BorderRadius.all(Radius.circular(radius));
  static const MaterialColor _materialColor = MaterialColor(0xFF142850, {
    50: Color(0xFFE2E5EA),
    100: Color(0xFFB8BECA),
    200: Color(0xFF8893A70),
    300: Color(0xFF586884),
    400: Color(0xFF354769),
    500: primary,
    600: Color(0xFF0F2348),
    700: Color(0xFF0C1D3F),
    800: Color(0xFF0A1736),
    900: Color(0xFF050E266)
  });

  static DialogTheme _dialogTheme(bool dark) {
    return DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
        backgroundColor: dark ? backgroundDark : background);
  }

  static ButtonThemeData _buttonTheme(bool dark) {
    return ButtonThemeData(
        buttonColor: dark ? accentDark : buttonNormal,
        shape: RoundedRectangleBorder(borderRadius: _borderRadius));
  }

  static InputDecorationTheme _inputDecorationTheme(bool dark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: dark ? cardDark : lightGrey,
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(16.0),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: NexusTheme.danger),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: NexusTheme.primary),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: NexusTheme.warning),
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: dark ? backgroundDark : lightGrey),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  ///
  /// THEME FUNCTIONS
  ///

  static ChipThemeData _chipTheme(BuildContext context) {
    return ChipThemeData(
        backgroundColor: darkGrey,
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

  static IconThemeData _actionsIconTheme(BuildContext context, bool dark) {
    var theme = IconThemeData(color: dark ? textLight : textDark);
    return theme;
  }

  static AppBarTheme _appBarTheme(BuildContext context, bool dark) {
    var theme = AppBarTheme(
        color: dark ? NexusTheme.cardDark : NexusTheme.background,
        actionsIconTheme: _actionsIconTheme(context, dark),
        iconTheme: _actionsIconTheme(context, dark),
        brightness: dark ? Brightness.dark : Brightness.light,
        textTheme: _textTheme(context, dark).apply(
            bodyColor: dark ? NexusTheme.textLight : NexusTheme.textDark,
            displayColor: dark ? NexusTheme.textLight : NexusTheme.textDark));
    return theme;
  }

  static BottomAppBarTheme _bottomAppBarTheme(BuildContext context, bool dark) {
    var theme = BottomAppBarTheme(
      color: dark ? NexusTheme.cardDark : NexusTheme.background,
    );
    return theme;
  }

  static TextTheme _textTheme(BuildContext context, bool dark) {
    var textTheme = Theme.of(context).textTheme;
    var theme = TextTheme(
      headline1: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline1.copyWith(
              fontWeight: FontWeight.w800, color: dark ? textLight : darkGrey)),
      headline2: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline2.copyWith(
              fontWeight: FontWeight.w800, color: dark ? textLight : darkGrey)),
      headline3: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline3.copyWith(
              fontWeight: FontWeight.w900, color: dark ? textLight : darkGrey)),
      headline4: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline4.copyWith(
              fontWeight: FontWeight.w900, color: dark ? textLight : darkGrey)),
      headline5: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline5
              .copyWith(fontSize: 24.0, color: dark ? textLight : darkGrey)),
      headline6: GoogleFonts.sourceSansPro(
          textStyle: textTheme.headline6
              .copyWith(fontSize: 28.0, fontWeight: FontWeight.w700)),
      subtitle1: GoogleFonts.openSans(textStyle: textTheme?.subtitle1)
          .copyWith(color: dark ? textLight : darkGrey),
      bodyText1: GoogleFonts.openSans(textStyle: textTheme?.bodyText1)
          .copyWith(color: dark ? textLight : darkGrey),
      bodyText2: GoogleFonts.openSans(textStyle: textTheme?.bodyText2)
          .copyWith(color: dark ? textLight : darkGrey),
      caption: GoogleFonts.openSans(textStyle: textTheme?.caption)
          .copyWith(color: dark ? textLight : darkGrey),
      button: GoogleFonts.sourceSansPro(textStyle: textTheme?.button)
          .copyWith(color: textLight),
      subtitle2: GoogleFonts.openSans(textStyle: textTheme?.subtitle2)
          .copyWith(color: dark ? textLight : darkGrey),
      overline: GoogleFonts.sourceSansPro(textStyle: textTheme?.overline)
          .copyWith(color: dark ? textLight : darkGrey),
    ).apply(
        bodyColor: dark ? textLight : darkGrey,
        displayColor: dark ? textLight : darkGrey);
    return theme;
  }

  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
      BuildContext context, bool dark) {
    return BottomNavigationBarThemeData(
        backgroundColor: dark ? cardDark : background,
        selectedItemColor: dark ? accentDark : accentLight,
        unselectedItemColor: dark ? textLight : textDark);
  }

  ///
  /// THEME
  ///

  static ThemeData light(BuildContext context) {
    return ThemeData(
        brightness: Brightness.light,
        appBarTheme: _appBarTheme(context, false),
        bottomAppBarTheme: _bottomAppBarTheme(context, false),
        primarySwatch: _materialColor,
        accentColor: accentLight,
        backgroundColor: background,
        scaffoldBackgroundColor: background,
        canvasColor: background,
        cardColor: backgroundGrey,
        cursorColor: darkGrey,
        dividerColor: grey,
        dialogTheme: _dialogTheme(false),
        inputDecorationTheme: _inputDecorationTheme(false),
        chipTheme: _chipTheme(context),
        textTheme: _textTheme(context, false),
        bottomNavigationBarTheme: _bottomNavigationBarTheme(context, false),
        buttonTheme: _buttonTheme(false));
  }

  static ThemeData dark(BuildContext context) {
    return ThemeData(
        brightness: Brightness.dark,
        appBarTheme: _appBarTheme(context, true),
        bottomAppBarTheme: _bottomAppBarTheme(context, true),
        primarySwatch: _materialColor,
        accentColor: accentDark,
        backgroundColor: backgroundDark,
        scaffoldBackgroundColor: backgroundDark,
        canvasColor: backgroundDark,
        cardColor: cardDark,
        cursorColor: lightGrey,
        dividerColor: grey,
        dialogTheme: _dialogTheme(true),
        inputDecorationTheme: _inputDecorationTheme(true),
        chipTheme: _chipTheme(context),
        textTheme: _textTheme(context, true),
        bottomNavigationBarTheme: _bottomNavigationBarTheme(context, true),
        buttonTheme: _buttonTheme(true));
  }

  ///
  /// COLORS
  ///

  static const primary = Color(0xFF142850);
  static const darkGrey = Color(0xFF353535);
  static const grey = Color(0xFF555555);
  static const backgroundGrey = Color(0xFFf4f5f7);
  static const background = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xFF182038);
  static const cardDark = Color(0xFF13192d);
  static const menuDark = Color(0xFF0a0d17);
  static const menuLight = primary;

  static const accentDark = Color(0xFFfecc41); //Color(0xFFa8a669);
  static const accentLight = blue;

  static const lightGrey = Color(0xFFeeeff4);
  static const blue = Color(0xFF4680FF);

  static const textLight = Color(0xFFFFFFFF);
  static const textLightMedium = Color(0xFF959595);
  static const textMedium = Color(0xFF353535);
  static const textDark = Color(0xFF1d1d24);

  static const danger = Color(0xFFfc7263);
  static const success = Color(0xFF2ceba8);
  static const alert = Color(0xFFfeb941);

  //Buttons
  static const buttonActive = Color(0xff1b48a1);
  static const buttonNormal = Color(0xff1b48a1);
  static const buttonDisabled = Color(0xff);
  static const buttonDarkActive = Color(0xff);
  static const buttonDarkNormal = Color(0xff1e2845);
  static const buttonDarkDisabled = Color(0xff);

  static const secondary = const Color(0xFF0c4767);
  static const surface = const Color(0xFFeaebed);
  static const warning = const Color(0xFFfe9920);
}
