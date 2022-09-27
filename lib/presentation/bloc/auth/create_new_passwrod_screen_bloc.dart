import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import '/data/api/constants.dart';

class CreateNewPasswordScreenBloc {
  final stateSubject = BehaviorSubject<CreateNewPasswordScreenState>();
  var errorMessage = "";

  Stream<CreateNewPasswordScreenState> observeState() => stateSubject;

  CreateNewPasswordScreenBloc() {
    stateSubject.add(CreateNewPasswordScreenState.createNewPasswordScreen);
  }

  void dispose() {
    stateSubject.close();
  }

  Future<void> createNewPassword(String email, String token, String password, String repeatPassword) async {
    stateSubject.add(CreateNewPasswordScreenState.loading);
    var dio = Dio();
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
    const baseUrl = ApiConstants.BASE_URL;
    await dio
        .post("${baseUrl}password-reset/reset-password-confirm/",
            data: FormData.fromMap({
              "email": email,
              "temporary_token": token,
              "password": password,
              "password_confirmation": repeatPassword
            }),
            options: Options(
              headers: {'Content-type': 'multipart/form-data', 'Accept': 'application/json'},
            ))
        .then((value) => {stateSubject.add(CreateNewPasswordScreenState.createNewPasswordSuccess)})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                  stateSubject.add(CreateNewPasswordScreenState.createNewPasswordError)
                }
              else
                {
                  errorMessage = 'Что-то пошло не так. Попробуйте немного позже.'.tr(),
                  stateSubject.add(CreateNewPasswordScreenState.createNewPasswordError)
                }
            });
  }
}

enum CreateNewPasswordScreenState {
  loading,
  createNewPasswordSuccess,
  createNewPasswordError,
  createNewPasswordScreen,
}
