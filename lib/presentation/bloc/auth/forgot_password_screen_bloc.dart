import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import '/data/api/constants.dart';

class ForgotPasswordScreenBloc {
  final stateSubject = BehaviorSubject<ForgotPasswordScreenState>();
  var errorMessage = "";
  var email = "";

  Stream<ForgotPasswordScreenState> observeAuthState() => stateSubject;

  ForgotPasswordScreenBloc() {
    stateSubject.add(ForgotPasswordScreenState.sendEmailScreen);
  }

  void dispose() {
    stateSubject.close();
  }

  Future<void> registration(String text) async {
    email = text;
    stateSubject.add(ForgotPasswordScreenState.loading);
    var dio = Dio();
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
    final baseUrl = ApiConstants.BASE_URL;
    await dio
        .post(baseUrl + "password-reset/send-reset-email/",
            data: FormData.fromMap({"email": text}),
            options: Options(
              headers: {'Content-type': 'multipart/form-data', 'Accept': 'application/json'},
            ))
        .then((value) => {stateSubject.add(ForgotPasswordScreenState.sendEmailSuccess)})
        .catchError((onError) => {
              if (onError.response.statusCode == 404)
                {
                  errorMessage = 'Пользователь с таким email не найден'.tr(),
                  stateSubject.add(ForgotPasswordScreenState.sendEmailError)
                }
              else
                {
                  errorMessage = 'Что-то пошло не так. Попробуйте немного позже.'.tr(),
                  stateSubject.add(ForgotPasswordScreenState.sendEmailError)
                }
            });
  }
}

enum ForgotPasswordScreenState {
  loading,
  sendEmailSuccess,
  sendEmailError,
  sendEmailScreen,
}
