import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/api/constants.dart';
import '../../../../new_code/auth/social_auth.dart';

part "welcome_screen_state.dart";

enum SocialProvider {
  apple,
  google,
}

class WelcomeScreenCubit extends Cubit<WelcomeScreenState> {
  final SocialAuthenticator _signInWithGoogle;
  final SocialAuthenticator _signInWithApple;
  final Function() _refreshAuthGate;
  WelcomeScreenCubit(this._signInWithGoogle, this._signInWithApple, this._refreshAuthGate)
      : super(WelcomeScreenInitial());

  SocialAuthenticator _getAuthenticator(SocialProvider provider) =>
      provider == SocialProvider.apple ? _signInWithApple : _signInWithGoogle;

  Future<void> socialSignInPressed(SocialProvider provider) async {
    final result = await _getAuthenticator(provider)();
    result.fold(
      (exception) => emit(WelcomeScreenError(exception.toString())), // TODO: error handling
      (isRegistration) => isRegistration == null
          ? null
          : isRegistration
              ? emit(WelcomeScreenSuccess()) // go to the Model or Hirer Registration screen
              : _refreshAuthGate(), // refresh auth gate, thus exiting the welcome screen and going to the home screen
    );
  }

  Future<void> registration(final String email, final String password) async {
    emit(WelcomeScreenLoading());
    final prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    prefs.setString("EMAIL", email);
    prefs.setString("PASSWORD", password);
    Map<String, dynamic> jsonMap = {
      'email': email,
      'password': password,
    };

    try {
      final baseUrl = ApiConstants.BASE_URL;
      final response = await dio.post("${baseUrl}check/", data: jsonMap);
      if (response.statusCode == 200) {
        emit(WelcomeScreenSuccess());
      } else {
        if (jsonDecode(utf8.decode(response.data)).toString().contains("email address уже существует")) {
          emit(WelcomeScreenError("Такой email уже существует".tr()));
        } else {
          emit(WelcomeScreenError("Ошибка при регистрации".tr()));
        }
      }
    } on Exception catch (_) {
      emit(WelcomeScreenError("Ошибка при регистрации".tr()));
    }
  }
}
