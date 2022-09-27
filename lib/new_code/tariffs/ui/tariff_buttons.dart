import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/new_code/tariffs/logic/cubit/tariffs_cubit.dart';
import '/new_code/tariffs/logic/values.dart';
import '/presentation/colors.dart';

class TariffButtons extends StatelessWidget {
  final List<Tariff> tariffs;
  final Tariff? selected;
  const TariffButtons({Key? key, required this.tariffs, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tariffs
          .map((tariff) => _TariffButton(
                tariff: tariff,
                isSelected: tariff == selected,
                onSelected: () => context.read<TariffsCubit>().tariffSelected(tariff),
              ))
          .toList(),
    );
  }
}

class _TariffButton extends StatelessWidget {
  final Tariff tariff;
  final bool isSelected;
  final Function() onSelected;

  const _TariffButton({
    Key? key,
    required this.tariff,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? vikingColor : Colors.black;
    final colorDesc = isSelected ? vikingColor : grey;
    final textDesc=tariff.translatedDescription;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        shadowColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 2,
        child: InkWell(
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.only(left: 18,right: 10,top: 10,bottom: 10),
            child: Row(
              children: [
                Text(
                  (tariff.rawPrice - tariff.rawPrice.floor()) >= 0.01 ? tariff.rawPrice.toString() : tariff.rawPrice.round().toString(),
                  // tariff.rawPrice.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    textDesc.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: colorDesc,
                    ),
                  ),
                ),
                Radio<int>(
                  value: 1,
                  focusColor: vikingColor,
                  activeColor: vikingColor,
                  groupValue: isSelected ? 1 : 0,
                  onChanged: (_) {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
