import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '/data/api/constants.dart';
import '/new_code/contacts/logic/api/entities.dart';

import '../../../common/api.dart';

class NotEnoughContactsException extends Equatable implements Exception {
  @override
  List get props => [];
}

typedef APIContactsAmountGetter = Future<ContactsAmount> Function();
typedef APIBoughtContactChecker = Future<bool> Function(int id);

typedef APIContactsGetter = Future<Contacts> Function(int id);

const _contactsAmountUrl = "tariffs/contact-amounts/";
APIContactsAmountGetter newAPIContactsAmountGetter(Dio dio, BaseOptionsGetter getOptions) => () async {
      final options = (await getOptions()).copyWith(method: "GET");
      final response = await dio.get(_contactsAmountUrl, options: options);
      return ContactsAmount.fromJson(response.data);
    };

const _contactsBaseUrl = ApiConstants.BASE_URL + "tariffs/contacts";
APIContactsGetter newAPIContactsGetter(Dio dio, BaseOptionsGetter getOptions) => (id) async {
      final options = (await getOptions()).copyWith(method: "GET");
      late final Response response;
      try {
        response = await dio.get("$_contactsBaseUrl/$id/", options: options);
      } on DioError catch (e) {
        print(e.requestOptions.headers);
        if (e.response?.statusCode == 403) {
          throw NotEnoughContactsException();
        }
        rethrow;
      }
      return Contacts.fromJson(response.data);
    };

const _contactsCheckBaseUrl = ApiConstants.BASE_URL + "tariffs/bought-contacts";
APIBoughtContactChecker newAPIBoughtContactChecker(Dio dio, BaseOptionsGetter getOptions) => (id) async {
      final options = (await getOptions()).copyWith(method: "GET");
      final response = await dio.get("$_contactsCheckBaseUrl/$id/", options: options);
      print(response);
      return response.data["is_bought"] as bool;
    };
