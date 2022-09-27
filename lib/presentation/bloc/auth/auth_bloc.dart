import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import "package:http/http.dart" as http;
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/constants.dart';
import '/di/post_di.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/repository/profile_repository.dart';

import '../../../new_code/di.dart';

class AuthBloc {
  final stateSubject = BehaviorSubject<AuthState>();
  final Function() _refreshAuthGate;
  var errorMessage = "";
  final ProfileRepository _repository = serviceDiPost<ProfileRepository>();
  Stream<AuthState> observeAuthState() => stateSubject;

  AuthBloc(this._refreshAuthGate) {
    stateSubject.add(AuthState.loginScreen);
  }

  void dispose() {
    stateSubject.close();
  }

  Future<void> login(final String email, final String password) async {
    stateSubject.add(AuthState.loading);
    final baseUrl = ApiConstants.BASE_URL;
    Map<String, dynamic> jsonMap = {
      'email': email,
      'password': password,
    };

    try{
      final response = await http.Client().post(Uri.parse("${baseUrl}token/obtain/"), body: jsonMap);
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('TOKEN', decoded['access']);
        getProfile();
      } else {
        errorMessage = "Ошибка авторизации".tr();
        stateSubject.add(AuthState.loadingError);
      }
    } on http.ClientException catch(error){
      print('Error HTTP $error');
    }

  }

  Future<void> getProfile() async {
    stateSubject.add(AuthState.loading);
    try {
      ProfileEntity? data = await _repository.getProfileSelf();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('TYPE', data!.userType!);
      stateSubject.add(AuthState.loginSuccess);
      _refreshAuthGate();
    } on Exception catch (e) {
      print(e);
      errorMessage = "Ошибка авторизации".tr();
      stateSubject.add(AuthState.loadingError);
    }
  }
}

enum AuthState {
  loading,
  loginSuccess,
  loadingError,
  loginScreen,
}
