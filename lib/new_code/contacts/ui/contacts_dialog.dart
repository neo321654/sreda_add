import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/new_code/common/flutter_helpers.dart';
import '/new_code/contacts/logic/api/api.dart';
import '/new_code/di.dart';
import '/new_code/tariffs/ui/tariffs_page.dart';
import '/presentation/bloc/review/review_screen_bloc.dart';
import '/presentation/screens/review/create_review_screen.dart';

import '../logic/api/entities.dart';

void showContactsDialog(BuildContext context, int id) async {
  final either = await uiDeps.getContacts(id);
  either.fold(
    (exception) =>
        exception is NotEnoughContactsException ? showBuyContactsDialog(context) : showErrorDialog(context, exception),
    (contacts) => showLoadedContactsDialog(context, contacts, id),
  );
}

void showLoadedContactsDialog(BuildContext context, Contacts contacts, int userId) async {
  final res = await showDialog(
    context: context,
    builder: (context) => Dialog(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Контакты".tr(), style: TextStyle(fontSize: 30)),
              ),
              if (contacts.phone != null) Text("Телефон для связи".tr() + ": " + contacts.phone!),
              if (contacts.instagram != null) Text("Instagram: " + contacts.instagram!),
              if (contacts.facebook != null) Text("Facebook: " + contacts.facebook!),
              if (contacts.linkedIn != null) Text("LinkedIn: " + contacts.linkedIn!),
              if (contacts.website != null) Text("Website: " + contacts.website!),
            ],
          ),
        ),
      ),
    ),
  );
  if (res == null) {
    pushPage(
        context, CreateReviewScreen(userId: userId, customBloc: ReviewScreenBloc(userId, false, uiDeps.checkContact)));
  }
}

void showErrorDialog(BuildContext context, Exception exception) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title: Text("Ошибка".tr(), style: TextStyle(fontSize: 30)),
        content: Text("Произошла системная ошибка".tr()),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ]),
  );
}

void showBuyContactsDialog(BuildContext context) async {
  pushPage(context, TariffsPage());
}
