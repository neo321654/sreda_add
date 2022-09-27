import 'package:equatable/equatable.dart';

const defaultFont = "GloryMedium";

const modelTariffGroups = [_modelAdUpsGroup];
const hirerTariffGroups = [_hirerContactsGroup, _hirerAddUpsGroup];

class TariffGroupIds extends Equatable {
  final TariffGroupName name;
  final Set<String> tariffIds;
  @override
  List get props => [name, tariffIds];

  const TariffGroupIds._(this.name, this.tariffIds);
}

enum TariffGroupName {
  hirerContacts,
  hirerAdUps,
  modelAdUps,
}

const _hirerContacts = {"1_contact", "10_contacts", "unlimited_contacts_for_a_day"};
const _hirerAdUps = {"1_hirer_ad_up", "5_hirer_ad_ups", "10_hirer_ad_ups"};
const _modelAdUps = {"1_model_ad_up", "model_hour_at_the_top", "model_day_at_the_top"};

const _hirerContactsGroup = TariffGroupIds._(TariffGroupName.hirerContacts, _hirerContacts);
const _hirerAddUpsGroup = TariffGroupIds._(TariffGroupName.hirerAdUps, _hirerAdUps);

const _modelAdUpsGroup = TariffGroupIds._(TariffGroupName.modelAdUps, _modelAdUps);
