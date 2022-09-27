import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../configurable.dart';

class TariffDetails extends Equatable {
  final ProductDetails productDetails;
  @override
  List get props => [productDetails];
  const TariffDetails(this.productDetails);
}

class Tariff extends Equatable {
  final String id;
  final String price;
  final double rawPrice;
  final String translatedDescription;
  final TariffDetails details;
  @override
  List get props => [id, price, translatedDescription, details];
  const Tariff(this.id, this.price, this.rawPrice, this.translatedDescription, this.details);
}

class TariffGroup extends Equatable {
  final TariffGroupName name;
  final List<Tariff> tariffs;
  @override
  List get props => [name, tariffs];
  const TariffGroup(this.name, this.tariffs);
}
