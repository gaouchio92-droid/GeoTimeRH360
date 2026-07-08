import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('ar'),
    Locale('es'),
  ];

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings)!;
  }

  static const _values = <String, Map<String, String>>{
    'fr': {
      'dashboard': 'Tableau',
      'products': 'Employes RH',
      'stock': 'Pointage',
      'warehouses': 'Sites',
      'pos': 'Paie',
      'customers': 'Missions',
      'suppliers': 'Performance',
      'ai': 'IA RH',
      'settings': 'Reglages',
      'search': 'Rechercher',
      'present': 'Presents',
      'late': 'Retards',
      'absent': 'Absents',
      'netPayroll': 'Paie nette',
      'alerts': 'Alertes',
      'bestSellers': 'Tendance presence',
      'assistantPrompt': 'Posez une question RH a GeoTime AI',
      'theme': 'Theme',
      'language': 'Langue',
    },
    'en': {
      'dashboard': 'Dashboard',
      'products': 'Employees',
      'stock': 'Attendance',
      'warehouses': 'Sites',
      'pos': 'Payroll',
      'customers': 'Missions',
      'suppliers': 'Performance',
      'ai': 'HR AI',
      'settings': 'Settings',
      'search': 'Search',
      'present': 'Present',
      'late': 'Late',
      'absent': 'Absent',
      'netPayroll': 'Net payroll',
      'alerts': 'Alerts',
      'bestSellers': 'Attendance trend',
      'assistantPrompt': 'Ask GeoTime AI an HR question',
      'theme': 'Theme',
      'language': 'Language',
    },
    'ar': {
      'dashboard': 'Dashboard',
      'products': 'Employees',
      'stock': 'Attendance',
      'warehouses': 'Sites',
      'pos': 'Payroll',
      'customers': 'Missions',
      'suppliers': 'Performance',
      'ai': 'HR AI',
      'settings': 'Settings',
      'search': 'Search',
      'present': 'Present',
      'late': 'Late',
      'absent': 'Absent',
      'netPayroll': 'Net payroll',
      'alerts': 'Alerts',
      'bestSellers': 'Attendance trend',
      'assistantPrompt': 'Ask GeoTime AI an HR question',
      'theme': 'Theme',
      'language': 'Language',
    },
    'es': {
      'dashboard': 'Panel',
      'products': 'Empleados',
      'stock': 'Marcaje',
      'warehouses': 'Sitios',
      'pos': 'Nomina',
      'customers': 'Misiones',
      'suppliers': 'Rendimiento',
      'ai': 'IA RRHH',
      'settings': 'Ajustes',
      'search': 'Buscar',
      'present': 'Presentes',
      'late': 'Retrasos',
      'absent': 'Ausentes',
      'netPayroll': 'Nomina neta',
      'alerts': 'Alertas',
      'bestSellers': 'Tendencia asistencia',
      'assistantPrompt': 'Haz una pregunta RRHH a GeoTime AI',
      'theme': 'Tema',
      'language': 'Idioma',
    },
  };

  String t(String key) => _values[locale.languageCode]?[key] ?? _values['fr']![key] ?? key;
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppStrings.supportedLocales.any((item) => item.languageCode == locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}
