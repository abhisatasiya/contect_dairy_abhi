import 'package:contact_dairy/Controllers/providers/themeprovider.dart';
import 'package:contact_dairy/modals/themeModel.dart';
import 'package:contact_dairy/views/screens/details_page.dart';
import 'package:flutter/material.dart';
import 'package:contact_dairy/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact_dairy/views/screens/add_contact.dart';
import 'package:contact_dairy/views/screens/home_page.dart';
import 'package:contact_dairy/views/screens/Intro_page.dart';
import 'package:contact_dairy/views/screens/hidden_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isIntroVisited = prefs.getBool('isIntroVisited') ?? false;
  bool isDarkTheme = prefs.getBool('isDark') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider(tm: themeModel(isDark: isDarkTheme),),
      builder: (context, _) {
        return MaterialApp(
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: (Provider.of<themeProvider>(context).tm.isDark == false)
              ? ThemeMode.light
              : ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          initialRoute: (isIntroVisited) ? '/' : 'Intro_page',
          routes: {
            '/': (context) => HomePage(),
            'Intro_page': (context) => IntroPage(),
            'add_contact': (context) => AddContact(),
            'details_page': (context) => DetailPage(),
            'hidden_page': (context) => HiddenPage(),
          },
        );
      },
    ),
  );
}

class ThemeModel {
}
