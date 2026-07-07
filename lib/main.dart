import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';
import 'core/localization/app_strings.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const GeoTimeApp());
}

class GeoTimeApp extends StatefulWidget {
  const GeoTimeApp({super.key});

  @override
  State<GeoTimeApp> createState() => _GeoTimeAppState();
}

class _GeoTimeAppState extends State<GeoTimeApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('fr');

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoTime Enterprise HR Suite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        AppStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: GeoTimeShell(
        themeMode: _themeMode,
        locale: _locale,
        onThemeModeChanged: _setThemeMode,
        onLocaleChanged: _setLocale,
      ),
    );
  }
}
