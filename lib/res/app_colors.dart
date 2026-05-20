import 'package:flutter/material.dart';

/// to control all colors, app theme, without any need to dig into code
/// any new color or existing color will have a const with its value
/// there is a stand alone variable for any widget, text, image or icon
///
/// All name colors according to https://chir.ag/projects/name-that-color
class AppColors {
  static const _black = Color(0xff222222);
  static const _white = Colors.white;
  static const _grey = Color(0xffD9D9D9);
  static const _red = Colors.red;
  static const _transparent = Colors.transparent;
  static const _blueZodiac = Color(0xff10164B);
  static const _chestnutRose = Color(0xffD15957);
  static const _blueRibbon = Color(0xff0437F2);
  static const _silver = Color(0xffc8c8c8);

  static const _whisper = Color(0xffF5F5FA);

  static const _thunder = Color(0xff231F20);
  static const _mineShaft = Color(0xff3B3B3B);

  static const _guardsmanRed = Color(0xffBC0000);
  static const _ecstasy = Color(0xffF58220);

  static const _buttercup10Opacity = Color.fromARGB(255, 245, 234, 211);

  static const _mandysPink = Color(0xffF2B9B9);
  static const _goblink = Color(0xff378A3A);
  static const _madang = Color(0xffC0F1C2);
  static const _apple = Color(0xff54B435);

  // app main theme ...

  // static const colorSchemeSeed = Color(0xFF27AE60);

  // static const focus = Color(0xFF27AE60);
  // static const primaryColor = Color(0xFF27AE60);
  // static const primaryColor60 = Color(0xFF70C58D);
  // static const primaryColor20 = Color(0xFFC3E5CE);//for buttons
  // static const secondaryColor = Color(0xFFFF8900);
  // static const secondaryColor80 = Color(0xFFFD9821);
  // static const secondaryColor40 = Color(0xFFFDC079);
  // static const baseColorwhite = Colors.white;
  // static const baseColorwhite20 = Color(0xffE9E9E9);
  // static const baseColorBlack = Color(0xff222222);
  // static const baseColorBlack60 = Color(0xffA9A9A9);//for some buttons
  // static const headLineText = Colors.black;
  // static const bodyLineText = Color(0xff626262);
  // static const errorRedColor = Color(0xffD10101);//for asstrisk and err
  // // static const inputFieldColor = Color(0xffE9E9E9);
  // static const infoBlueColor = Color(0xff0047AB);
  // static const percentageColor = Color(0xff2DEE74);
  // static const todoColor = Color(0xff7812B7);

  // PRIMARY COLORS
  static const Color _primary100 = Color(0xFF27AE60);
  static const Color _primary80 = Color(0xFF52C488);
  static const Color _primary60 = Color(0xFF7BD6A3);
  static const Color _primary40 = Color(0xFFA4E7BF);
  static const Color _primary20 = Color(0xFFCDEFD9);

  // SECONDARY COLORS
  static const Color _secondary100 = Color(0xFFF7931A);
  static const Color _secondary80 = Color(0xFFF9A63C);
  static const Color _secondary60 = Color(0xFFFBC66A);
  static const Color _secondary40 = Color(0xFFFCD89A);
  static const Color _secondary20 = Color(0xFFFDE9C9);

  // BASE COLORS (Greys)
  static const Color _black100 = Color(0xFF222222);
  static const Color _black80 = Color(0xFF5E5E5E);
  static const Color _black60 = Color(0xFF8A8A8A);
  static const Color _black40 = Color(0xFFCACACA);
  static const Color _black20 = Color(0xFFE8E8E8);
  static const Color _black0 = Color(0xFFFFFFFF);

  // ACCENT COLORS
  static const Color _success100 = Color(0xFF008A00);
  static const Color _success80 = Color(0xFFD7EED6);

  static const Color _warning100 = Color(0xFFF7C444);
  static const Color _warning80 = Color(0xFFFCEFC1);

  static const Color _error100 = Color(0xFFD01919);
  static const Color _error80 = Color(0xFFF3D3D3);

  static const Color _info100 = Color(0xFF0A74D9);
  static const Color _info80 = Color(0xFFD0E4FA);

  static const scaffoldBackground = _black0;
  static const primary = _primary100;
  static const onPrimary = _black0;
  static const primaryContainer = _primary40;

  static const secondary = _secondary100;
  static const onSecondary = _black0;
  static const secondaryContainer = _secondary40;

  static const surface = _black20;
  static const onSurface = _black100;

  static const error = _error100;
  static const onError = _black0;

  // AppBar
  static const appBarBackground = _primary100;
  static const appBarTextColor = _black20;
  static const appBarIconColor = _black20;

  // static const statusBar = _blueZodiac;
  static const baseBtnColorGreen = _primary100;
  static const baseBtnColorGreenTransparent = _primary20;
  static const baseBtnColorWhite = _black0;

  static const floatActionBtnText = _white;
  static const floatActionBtnBackground = _ecstasy;
  static const buttonTextLight = _white;
  static const iconTheme = _primary100;
  static const appBarIcon = _blueZodiac;
  static const titleMedium = _blueRibbon;
  static const headlineMedium = _blueZodiac;
  static const bodyMedium = _blueZodiac;
  static const labelLarge = _thunder;
  static const labelMedium = _mineShaft;
  static const labelSmall = _grey;
  static const backLoginIconBackground = _white;
  static const removeHighlight = _transparent;
  static const backGroundCard = _white;
  static const backGroundContainer = _white;
  static const removeTxt = _chestnutRose;

  /// base widget
  static const baseWidgetBackground = _transparent;

  /// toast ..
  static const toastBackground = _black;
  static const toastText = _white;

  /// app form field

  static final appFormFieldFill = _white.withOpacity(.1);
  static const enabledAppFormFieldBorder = _white;
  static const appFormFieldText = _white;
  static const appFormFieldSuffixIcon = _white;
  static const appFormFieldPrefixIcon = _white;
  static const disabledAppFormFieldBorder = _silver;

  /// Custom DropDown Widget
  static const appDropdownFill = _white;
  static const appDropdownDisabledBorder = _silver;
  static const appDropdownEnabledBorder = _white;
  static const appDropdownFocusedBorder = _blueZodiac;

  /// paging
  static const paginationLoadingBackground = _white;

  /// home

  static const homeUserModeAlert = _buttercup10Opacity;

  static const containerDivide = _silver;

  ///dialog
  static const packageIcon = _blueRibbon;
  static const doneIconBg = _blueRibbon;
  static const doneIcon = _white;
  static const languageUnActive = _grey;
  static const languageActive = _black;
  static const dividerColor = _grey;
  static const confirmIconBackground = _red;
  static const confirmIcon = _white;

  /// connectivity widget
  static const connectedToInternetBackground = _madang;
  static const notConnectedToInternetBackground = _mandysPink;
  static const connectedToInternetText = _goblink;
  static const connectedToInternetIcon = _goblink;
  static const notConnectedToInternetIcon = _guardsmanRed;
  static const notConnectedToInternetText = _guardsmanRed;

  /// Auth Screen
  static const loginButtonBg = _apple;
}
