import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/constants.dart';
import '/presentation/models/RequestProfileModel.dart';

class RegistrationEmployerBloc {
  final Dio _dio;
  final Function() _refreshAuthGate;
  final stateSubject = BehaviorSubject<RegistrationEmployerScreenState>();
  var errorMessage = "";

  Stream<RegistrationEmployerScreenState> observeRegistrationState() => stateSubject;

  void dispose() {
    stateSubject.close();
  }

  RegistrationEmployerBloc(this._dio, this._refreshAuthGate) {
    stateSubject.add(RegistrationEmployerScreenState.justScreen);
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> registration(RequestProfileModel model, List<File> photos) async {
    final prefs = await SharedPreferences.getInstance();
    stateSubject.add(RegistrationEmployerScreenState.loading);
    if ((prefs.getString("TOKEN") ?? "") != "") {
      // token is already stored because of some social auth
      _fillDetails(model, photos);
    } else {
      _register(model, photos);
    }
  }

  Future<void> _register(RequestProfileModel model, List<File> photos) async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = ApiConstants.BASE_URL;
    final email = prefs.getString("EMAIL")!;
    final password = prefs.getString("PASSWORD")!;
    Map<String, dynamic> jsonMap = {
      'email': email,
      'password': password,
    };

    try {
      final response = await _dio.post("${baseUrl}register/", data: jsonMap);
      if (response.statusCode == 201) {
        _getTokenAndFillDetails(email, password, model, photos);
      } else {
        if (jsonDecode(utf8.decode(response.data)).toString().contains("email address уже существует".tr())) {
          errorMessage = "Такой email уже существует".tr();
        } else {
          errorMessage = "Ошибка при регистрации".tr();
        }
        stateSubject.add(RegistrationEmployerScreenState.registrationError);
      }
    } on Exception catch (_) {
      errorMessage = "Ошибка при регистрации".tr();
      stateSubject.add(RegistrationEmployerScreenState.registrationError);
    }
  }

  Future<void> _getTokenAndFillDetails(
    final String email,
    final String password,
    RequestProfileModel model,
    List<File> photos,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> jsonMap = {
      'email': email,
      'password': password,
    };
    final response = await _dio.post("${ApiConstants.BASE_URL}token/obtain/", data: jsonMap);

    if (response.statusCode == 200) {
      await prefs.setString('TOKEN', response.data['access']);
      _fillDetails(model, photos);
    } else {
      errorMessage = "Ошибка при регистрации".tr();
      stateSubject.add(RegistrationEmployerScreenState.registrationError);
    }
  }

  Future<void> _fillDetails(RequestProfileModel model, List<File> photos) async {
    stateSubject.add(RegistrationEmployerScreenState.loading);
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      //
    }
    final baseUrl = ApiConstants.BASE_URL;
    var formData = FormData.fromMap({
      'email': model.email,
      'password': model.password,
      'name': model.name,
      'gender': model.gender,
      'age': model.age,
      'city': model.city,
      'phone': model.phone,
      'instagram': model.instagram,
      'website': model.website,
      'about': model.about,
      'close_size': model.closeSize,
      'shoes_size': model.shoesSize,
      'growth': model.growth,
      'bust': model.bust,
      'waist': model.waist,
      'hips': model.hips,
      'look_type': model.lookType,
      'skin_color': model.skinColor,
      'hair_color': model.hairColor,
      'hair_length': model.hairLength,
      'is_have_international_passport': model.isHaveInternationalPassport,
      'is_have_tattoo': model.isHaveTattoo,
      'is_have_english': model.isHaveEnglish,
      "user_type": "HIRER"
    });
    photos.asMap().forEach((index, value) => {
          formData.files.addAll([
            MapEntry("photos[$index]", MultipartFile.fromFileSync(value.path, filename: "${getRandomString(15)}.jpg"))
          ])
        });
    try {
      final response = await _dio.post("${baseUrl}profiles/",
          data: formData,
          options: Options(
            headers: {
              'Content-type': 'multipart/form-data',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${prefs.getString("TOKEN")}'
            },
          ));
      if (response.statusCode == 201) {
        _refreshAuthGate();
        stateSubject.add(RegistrationEmployerScreenState.registrationSuccess);
      } else {
        errorMessage = utf8.decode(response.data);
        stateSubject.add(RegistrationEmployerScreenState.registrationError);
        if (kDebugMode) {}
      }
    } on Exception catch (e) {
      errorMessage = e.toString();
      stateSubject.add(RegistrationEmployerScreenState.registrationError);
      if (kDebugMode) {}
    }
  }
}

enum RegistrationEmployerScreenState { loading, justScreen, registrationSuccess, registrationError }
