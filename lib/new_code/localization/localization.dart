import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppLocalization extends StatelessWidget {
  final Widget app;
  const AppLocalization({Key? key, required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [Locale("tr", "TR"), Locale("ru", "RU"), Locale("en", "EN")],
      path: "assets/translations",
      child: app,
      fallbackLocale: Locale("ru", "RU"),
    );
  }
}
