import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/repository/post_repository.dart';
import '/presentation/bloc/home/home_screen_state.dart';

class HomeScreenBloc extends Cubit<HomeScreenState> {
  String errorMessage = "Ошибка".tr();
  final PostRepository _repository = serviceDiPost<PostRepository>();

  HomeScreenBloc() : super(HomeScreenInitial()) {
    emit(HomeScreenInitial());
  }

  String? city;
  String? userType;
  int? workType;
  int? category;
  int? gender;
  String? genderStr;
  int? fromPrice;
  int? toPrice;

  Future<void> getPosts() async {
    if (category != null) {
      if (category == 1) {
        userType = "Модель".tr();
      } else if (category == 0) {
        userType = "Фотограф".tr();
      } else {
        userType = "Другое".tr();
      }
    } else {
      userType = null;
    }
    if (gender == 2) {
      genderStr = null;
    } else if (gender == 1) {
      genderStr = "Мужчины".tr();
    } else if (gender == 0) {
      genderStr = "Женщины".tr();
    } else {
      genderStr = null;
    }
    emit(HomeScreenLoading());
    _repository
        .getPosts(
          city: city,
          workType: null,
          category: userType,
          gender: genderStr,
          fromPrice: fromPrice,
          toPrice: toPrice,
        )
        ?.then((value) => {
          emit(HomeScreenSuccess(data: value))})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(HomeScreenErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) {
          print('ljlkjkj');
          return {emit(HomeScreenErrorState(CatchException. convertException(error)))};
        });
  }
}
