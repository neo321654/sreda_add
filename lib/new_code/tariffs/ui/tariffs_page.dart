import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/new_code/di.dart';
import '/new_code/tariffs/logic/cubit/tariffs_cubit.dart';
import '/new_code/tariffs/ui/tariff_list.dart';

import '../../common/app_bar.dart';

class TariffsPage extends StatelessWidget {
  const TariffsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print('in tarif');
    return Scaffold(
      appBar: CustomAppBar("Тарифы".tr()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocProvider(
            create: (_) => uiDeps.tariffsCubitFactory(),
            child: BlocBuilder<TariffsCubit, TariffsState>(
              builder: (context, state) => state.fold(
                () => Center(child: CircularProgressIndicator()),
                (some) => some.fold(
                  (exception) => Center(child: Text(exception.toString())), // TODO: error handling
                  (loaded) {
                    print('kjkjkj');
                    return TariffList(groups: loaded.groups, selectedTariff: loaded.selected);
                  },
                ),
              ),
            )),
      ),
    );
  }
}
