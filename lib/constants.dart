import 'package:flutter/cupertino.dart';
import 'package:grossmx/providers/darkthemeprovider.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;
  Color get color => getTheme ? CupertinoColors.white : CupertinoColors.black;
  Size get getScreenSize => MediaQuery.of(context).size;
}

class Styles {
  static CupertinoThemeData themeData(bool isDarkTheme, BuildContext context) {
    return CupertinoThemeData(
      scaffoldBackgroundColor:
          //0A1931  // white yellow 0xFFFCF8EC
          isDarkTheme ? const Color(0xFF00001a) : const Color(0xFFFFFFFF),
      primaryColor: CupertinoColors.systemGreen,
      // colorScheme: CupertinoThemeData().colorScheme.copyWith(
      //       secondary:
      //           isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      // ),
      primaryContrastingColor:
          isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
      barBackgroundColor:
          isDarkTheme ? CupertinoColors.black : CupertinoColors.systemGrey2,
      // buttonTheme: CupertinoTheme.of(context). .copyWith(
      //     colorScheme: isDarkTheme
      //         ? const ColorScheme.dark()
      //         : const ColorScheme.light()),
    );
  }
}
