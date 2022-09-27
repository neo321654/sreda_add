import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/repository/profile_repository.dart';
import '/presentation/bloc/home/talents_widget_state.dart';

class TalentsWidgetBloc extends Cubit<TalentsWidgetState> {
  String errorMessage = "Ошибка".tr();
  final ProfileRepository _repository = serviceDiPost<ProfileRepository>();

  TalentsWidgetBloc() : super(TalentsWidgetInitial()) {
    emit(TalentsWidgetInitial());
    getTalents();
  }

  void dispose() {}

  Future<void> getTalents() async {
    emit(TalentsWidgetLoading());
    _repository
        .getTalents(city: null)
        ?.then((value) => {emit(TalentsWidgetSuccess(data: value))})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(TalentsWidgetErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(TalentsWidgetErrorState(CatchException.convertException(error)))});
  }
}
