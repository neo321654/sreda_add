import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '/new_code/configurable.dart';

import '../../../common/user_type_getter.dart';
import '../purchase_services.dart';
import '../values.dart';

part 'tariffs_state.dart';

typedef TariffsCubitFactory = TariffsCubit Function();
TariffsCubitFactory newTariffsCubitFactory(
  UserTypeGetter getUserType,
  TariffGroupsGetter fetchGroups,
  TariffBuyer buyTariff,
) =>
    () => TariffsCubit(
          getUserType,
          fetchGroups,
          buyTariff,
        );

class TariffsCubit extends Cubit<TariffsState> {
  final UserTypeGetter _getUserType;
  final TariffGroupsGetter _fetchGroups;
  final TariffBuyer _buyTariff;

  TariffsCubit(this._getUserType, this._fetchGroups, this._buyTariff) : super(const None()) {
    _load();
  }

  void tariffSelected(Tariff selected) => state.foldLoaded(
        () => null,
        (loaded) => emit(Some(Right(loaded.withSelected(selected)))),
      );

  Future<void> payPressed() async => state.foldLoaded(
        () => null,
        (loaded) => loaded.selected != null
            ? _buyTariff(loaded.selected!).then((result) => result.fold(
                  (exception) => emit(Some(Left(exception))),
                  (success) => emit(Some(Right(loaded.withSelected(null)))),
                ))
            : null,
      );

  Future<void> _load() => _getUserType().then(
        (result) => result.fold(
          (exception) => emit(Some(Left(exception))),
          (userType) => _fetchGroups(_chooseGroups(userType)).then(
            (groupsResult) => groupsResult.fold(
              (exception) => emit(Some(Left(exception))),
              (groups) => emit(Some(Right(LoadedTariffsState(groups)))),
            ),
          ),
        ),
      );

  List<TariffGroupIds> _chooseGroups(UserType userType) {
    switch (userType) {
      case UserType.hirer:
        return hirerTariffGroups;
      case UserType.model:
        return modelTariffGroups;
    }
  }
}
