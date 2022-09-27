import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/presentation/screens/profile/profile_screen.dart';

import '../../presentation/colors.dart';

class LanguageSelectItem extends StatelessWidget {
  const LanguageSelectItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => const LanguageSelectDialog(),
      ),
      child: ItemProfileMenu(
        iconPath: "assets/images/icons_profile/ic_langudge.svg",
        title: "Язык".tr(),
        isDivider: true,
        leftPadding: 20,
        rightPadding: 25,
        width: 4,

      ),
    );
  }
}

class LanguageSelectDialog extends StatelessWidget {
  const LanguageSelectDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: vikingColor,
          width: 5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      children: [
        _LanguageOption(
          locale: Locale("ru", "RU"),
          langName: "Русский",
        ),
        _LanguageOption(
          locale: Locale("en", "EN"),
          langName: "English",
        ),
        _LanguageOption(
          locale: Locale("tr", "TR"),
          langName: "Türk",
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String langName;
  final Locale locale;

  const _LanguageOption({Key? key, required this.locale, required this.langName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          langName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: vikingColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        context.setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }
}
