import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class CatchException {
  String? message;

  CatchException({this.message});

  @override
  String toString() => message!;

  static CatchException convertException(dynamic error) {
    if (error is DioError && error.error is CatchException) {
      return error.error;
    }
    if (error is DioError) {
      print((error as DioError).message);
      if (error.type == DioErrorType.connectTimeout) {
        return CatchException(message: 'Привышено время обработки запроса. Повторите позднее'.tr());
      } else if (error.type == DioErrorType.receiveTimeout) {
        return CatchException(message: 'Привышено время обработки запроса. Повторите позднее'.tr());
      } else if (error.response == null) {
        return CatchException(message: 'Нет интернет соеденения'.tr());
      } else if (error.response!.statusCode == 401) {
        return CatchException(message: error.response!.data["detail"]);
      } else if (error.response!.statusCode == 400) {
        return CatchException(message: error.response!.data["detail"]);
      } else {
        return CatchException(message: 'Произошла системная ошибка'.tr());
      }
    }
    if (error is CatchException) {
      return error;
    } else {
      return CatchException(message: 'Произошла системная ошибка'.tr());
    }
  }
}
