import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '/new_code/common/functional.dart';
import '/new_code/configurable.dart';
import '/new_code/tariffs/logic/values.dart';

class ProductsNotFound extends Equatable implements Exception {
  final List<String> ids;
  @override
  List get props => [ids];
  const ProductsNotFound(this.ids);
}

class FetchingProductsException extends Equatable implements Exception {
  final dynamic detail;
  @override
  List get props => [detail];
  const FetchingProductsException(this.detail);
}

typedef TariffsGetter = Future<Either<Exception, List<Tariff>>> Function(Set<String> ids);
typedef TariffGroupsGetter = Future<Either<Exception, List<TariffGroup>>> Function(List<TariffGroupIds>);

typedef TariffBuyer = Future<Either<Exception, void>> Function(Tariff tariff);

// TODO: optimize to call the Purchases API only once
TariffGroupsGetter newTariffGroupsGetter(TariffsGetter getTariffs) => (idGroups) {
      return withExceptionHandling(() async {
        final futures = idGroups.map((group) => getTariffs(group.tariffIds).then(
              (result) => result.fold(
                (exception) => throw exception,
                (tariffs) => TariffGroup(group.name, tariffs),
              ),
            ));
        final groups = await Future.wait(futures);
        return groups.toList();
      });
    };
// Note: its only for consumables (currently all of the tariffs are consumables)
TariffBuyer newTariffBuyer(InAppPurchase iap) => (tariff) {
      return withExceptionHandling(() async {
        print("buying $tariff");
        await iap.buyConsumable(purchaseParam: PurchaseParam(productDetails: tariff.details.productDetails));
      });
    };

TariffsGetter newTariffsGetter(InAppPurchase iap) => (ids) {
      return withExceptionHandling(() async {
        final products = await iap.queryProductDetails(ids);

        if (products.error != null) {
          throw FetchingProductsException(products.error);
        }
        final tariffs = products.productDetails
            .map((det) => Tariff(
                  det.id,
                  det.price,
                  det.rawPrice,
                  det.title,
                  TariffDetails(det),
                ))
            .toList();
        tariffs.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
        return tariffs;
      });
    };
