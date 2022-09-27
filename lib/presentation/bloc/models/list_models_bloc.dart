import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/repository/profile_repository.dart';
import '/presentation/bloc/models/list_models_screen_state.dart';

class ListModelsBloc extends Cubit<ListModelsScreenState> {
  final ProfileRepository _repository = serviceDiPost<ProfileRepository>();

  var errorMessage = "";
  String? city;
  int? type;
  int? gender;
  String? userType;

  ListModelsBloc() : super(ListModelsScreenInitial()) {
    emit(ListModelsScreenInitial());
  }

  Future<void> getProfiles() async {
    if (type != null) {
      if (type == 1) {
        userType = "MODEL";
      } else if (type == 0) {
        userType = "PHOTOGRAPH";
      } else {
        userType = "OTHER";
      }
    } else {
      userType = null;
    }
    if (gender == 2) {
      gender = null;
    }
    emit(ListModelsScreenLoading());
    _repository
        .getProfiles(city: city, type: userType, gender: gender)
        ?.then((value) => {emit(ListModelsScreenSuccess(data: value))})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(ListModelsScreenErrorState(
                  CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {
              emit(ListModelsScreenErrorState(
                  CatchException.convertException(error)))
            });
  }
}
