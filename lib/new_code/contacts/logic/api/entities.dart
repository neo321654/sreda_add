import 'package:equatable/equatable.dart';

class ContactsAmount extends Equatable {
  final int contacts;
  final DateTime? unlimitedTill;

  @override
  List get props => [contacts, unlimitedTill];

  const ContactsAmount({required this.contacts, required this.unlimitedTill});

  ContactsAmount.fromJson(Map<String, dynamic> json)
      : this(
          contacts: json["contacts_amount"],
          unlimitedTill: _decodeTimestamp(json["unlimited_till"]),
        );

  // TODO: move to common
  static DateTime? _decodeTimestamp(dynamic timestamp) =>
      timestamp == null ? null : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

class Contacts extends Equatable {
  final String? phone;
  final String? facebook;
  final String? instagram;
  final String? linkedIn;
  final String? website;

  @override
  List get props => [phone, facebook, instagram, linkedIn, website];

  const Contacts({this.phone, this.facebook, this.instagram, this.linkedIn, this.website});

  Contacts.fromJson(Map<String, dynamic> json)
      : this(
          phone: json["phone"],
          facebook: json["facebook"],
          instagram: json["instagram"],
          linkedIn: json["linked_in"],
          website: json["website"],
        );
}
