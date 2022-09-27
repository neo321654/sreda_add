import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/constants.dart';

import '../../models/RequestProfileModel.dart';

class RegistrationModelBloc {
  final Dio _dio;
  final Function() _refreshAuthGate;
  final stateSubject = BehaviorSubject<RegistrationModelScreenState>();
  var errorMessage = "";

  Stream<RegistrationModelScreenState> observeRegistrationState() => stateSubject;

  void dispose() {
    stateSubject.close();
  }

  RegistrationModelBloc(this._dio, this._refreshAuthGate) {
    stateSubject.add(RegistrationModelScreenState.justScreen);
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> registration(RequestProfileModel model, List<File?> photos, String workType) async {
    final prefs = await SharedPreferences.getInstance();
    stateSubject.add(RegistrationModelScreenState.loading);
    if ((prefs.getString("TOKEN") ?? "") != "") {
      // token is already stored because of some social auth
      _fillDetails(model, photos, workType);
    } else {
      _register(model, photos, workType);
    }
  }

  Future<void> _register(RequestProfileModel model, List<File?> photos, String workType) async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = ApiConstants.BASE_URL;
    final email = prefs.getString("EMAIL");
    final password = prefs.getString("PASSWORD");
    Map<String, dynamic> jsonMap = {
      'email': email,
      'password': password,
    };

    try {
      final response = await _dio.post("${baseUrl}register/", data: jsonMap);
      if (response.statusCode == 201) {
        if ((prefs.getString("TOKEN") ?? "") != "") {
          // token is already stored because of some social auth
          _fillDetails(model, photos, workType);
        } else {
          _getTokenAndFillDetails(email!, password!, model, photos, workType);
        }
      } else {
        if (jsonDecode(utf8.decode(response.data)).toString().contains("email address уже существует")) {
          errorMessage = "Такой email уже существует".tr();
        } else {
          errorMessage = "Ошибка при регистрации".tr();
        }
        stateSubject.add(RegistrationModelScreenState.registrationError);
      }
    } on Exception catch (_) {
      errorMessage = "Ошибка при регистрации".tr();
      stateSubject.add(RegistrationModelScreenState.registrationError);
    }
  }

  Future<void> _getTokenAndFillDetails(
      final String email, final String password, RequestProfileModel model, List<File?> photos, String workType) async {
    final baseUrl = ApiConstants.BASE_URL;
    Map<String, dynamic> jsonMap = {
      'email': email,
      'password': password,
    };
    var dio = Dio();
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final response = await dio.post("${baseUrl}token/obtain/", data: jsonMap);

    final decoded = response.data;
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('TOKEN', decoded['access']);
      _fillDetails(model, photos, workType);
    } else {
      errorMessage = "Ошибка при регистрации".tr();
      stateSubject.add(RegistrationModelScreenState.registrationError);
    }
  }

  Future<void> _fillDetails(final RequestProfileModel model, List<File?> photo, String workType) async {
    stateSubject.add(RegistrationModelScreenState.loading);
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
      "user_type": "MODEL",
      "workType": workType,
    });
    photo.asMap().forEach((index, value) => {
          formData.files.addAll([
            MapEntry("photos[$index]", MultipartFile.fromFileSync(value!.path, filename: "${getRandomString(15)}.jpg"))
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
        stateSubject.add(RegistrationModelScreenState.registrationSuccess);
      } else {
        errorMessage = utf8.decode(response.data);
        stateSubject.add(RegistrationModelScreenState.registrationError);
        if (kDebugMode) {}
      }
    } on Exception catch (e) {
      errorMessage = e.toString();
      stateSubject.add(RegistrationModelScreenState.registrationError);
      if (kDebugMode) {}
    }
  }
}

enum RegistrationModelScreenState { loading, justScreen, registrationSuccess, registrationError }
