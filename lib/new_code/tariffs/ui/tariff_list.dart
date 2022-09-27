import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/new_code/tariffs/logic/cubit/tariffs_cubit.dart';
import '/new_code/tariffs/ui/tariff_buttons.dart';

import '../../../presentation/colors.dart';
import '../../configurable.dart';
import '../logic/values.dart';

const titleTextStyle = TextStyle(
  color: grey,
  fontFamily: defaultFont,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

class TariffList extends StatelessWidget {
  final List<TariffGroup> groups;
  final Tariff? selectedTariff;

  const TariffList({Key? key, required this.groups, required this.selectedTariff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ...groups.map((group) => TariffGroupWidget(
            group: group,
            selected: selectedTariff,
          )),
      const SizedBox(height: 40,),
      PayButton(enabled: selectedTariff != null),
    ]);
  }
}

String _translateGroupName(TariffGroupName name) {
  switch (name) {
    case TariffGroupName.hirerContacts:
      return "Контакты".tr();
    case TariffGroupName.hirerAdUps:
      return "Поднятия".tr();
    case TariffGroupName.modelAdUps:
      return "Поднятия".tr();
  }
}

class TariffGroupWidget extends StatelessWidget {
  final TariffGroup group;
  final Tariff? selected;
  const TariffGroupWidget({Key? key, required this.group, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            _translateGroupName(group.name),
            style: titleTextStyle,
            textAlign: TextAlign.left,

          ),
        ),
        const SizedBox(height: 10),
        TariffButtons(tariffs: group.tariffs, selected: selected),
      ]),
    );
  }
}

class PayButton extends StatelessWidget {
  final bool enabled;
  const PayButton({Key? key, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled ? context.read<TariffsCubit>().payPressed : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Оплатить".tr(),
          style: TextStyle(color: Colors.white, fontSize:17,fontWeight:FontWeight.w500,letterSpacing: 1.2),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: vikingColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
