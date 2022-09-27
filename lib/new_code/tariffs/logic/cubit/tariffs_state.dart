part of 'tariffs_cubit.dart';

typedef TariffsState = Option<Either<Exception, LoadedTariffsState>>; // None means "loading"

extension TariffsStateLoadedFold on TariffsState {
  T foldLoaded<T>(T Function() notLoaded, T Function(LoadedTariffsState) loaded) => fold(
        () => notLoaded(),
        (some) => some.fold(
          (_) => notLoaded(),
          (l) => loaded(l),
        ),
      );
}

class LoadedTariffsState extends Equatable {
  final List<TariffGroup> groups;
  final Tariff? selected;
  @override
  List get props => [groups, selected];
  const LoadedTariffsState(this.groups, [this.selected]);

  LoadedTariffsState withSelected(Tariff? newSelected) => LoadedTariffsState(groups, newSelected);
}
