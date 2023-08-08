import 'package:contact_dairy/modals/themeModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class themeProvider extends ChangeNotifier {
  themeModel tm;

  themeProvider ({
    required this.tm,
}
);

  changeTheme() async {
    tm.isDark = !tm.isDark;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDark', tm.isDark);

    notifyListeners();
  }
}
