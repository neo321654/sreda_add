import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import '/data/api/constants.dart';

class EnterCodeForgotPasswordScreenBloc {
  final stateSubject = BehaviorSubject<EnterCodeForgotPasswordScreenState>();
  var errorMessage = "";
  var email = "";
  var token = "";

  Stream<EnterCodeForgotPasswordScreenState> observeAuthState() => stateSubject;

  EnterCodeForgotPasswordScreenBloc() {
    stateSubject.add(EnterCodeForgotPasswordScreenState.sendEmailCodeScreen);
  }

  void dispose() {
    stateSubject.close();
  }

  Future<void> sendEmailCode(String email, String code) async {
    this.email = email;
    stateSubject.add(EnterCodeForgotPasswordScreenState.loading);
    var dio = Dio();
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
    final baseUrl = ApiConstants.BASE_URL;
    await dio
        .post(baseUrl + "password-reset/check-recovery-code/",
            data: FormData.fromMap({"email": email, "recovery_code": code}),
            options: Options(
              headers: {'Content-type': 'multipart/form-data', 'Accept': 'application/json'},
            ))
        .then((value) => {
              token = value.data['temporary_token'],
              stateSubject.add(EnterCodeForgotPasswordScreenState.sendEmailCodeSuccess)
            })
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = 'Введен неверный код'.tr(),
                  stateSubject.add(EnterCodeForgotPasswordScreenState.sendEmailCodeError)
                }
              else
                {
                  errorMessage = 'Что-то пошло не так. Попробуйте немного позже.'.tr(),
                  stateSubject.add(EnterCodeForgotPasswordScreenState.sendEmailCodeError)
                }
            });
  }

  Future<void> sendRepeatCode(String email) async {
    stateSubject.add(EnterCodeForgotPasswordScreenState.loading);
    var dio = Dio();
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
    const baseUrl = ApiConstants.BASE_URL;
    await dio
        .post("${baseUrl}password-reset/send-reset-email/",
            data: FormData.fromMap({"email": email}),
            options: Options(
              headers: {'Content-type': 'multipart/form-data', 'Accept': 'application/json'},
            ))
        .then((value) => {stateSubject.add(EnterCodeForgotPasswordScreenState.sendEmailCodeScreen)})
        .catchError((onError) => {
              if (onError.response.statusCode == 404)
                {
                  errorMessage = 'Пользователь с таким email не найден'.tr(),
                  stateSubject.add(EnterCodeForgotPasswordScreenState.sendEmailCodeError)
                }
              else
                {
                  errorMessage = 'Что-то пошло не так. Попробуйте немного позже.'.tr(),
                  stateSubject.add(EnterCodeForgotPasswordScreenState.sendEmailCodeError)
                }
            });
  }
}

enum EnterCodeForgotPasswordScreenState {
  loading,
  sendEmailCodeSuccess,
  sendEmailCodeError,
  sendEmailCodeScreen,
}
