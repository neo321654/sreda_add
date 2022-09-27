import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/repository/favorite_repository.dart';
import '/presentation/bloc/favorite/favorite_post_state.dart';

class FavoritePostBloc extends Cubit<FavoritePostState> {
  FavoritePostBloc() : super(FavoritePostInitial());

  String errorMessage = '';

  final FavoriteRepository _repository = serviceDiPost<FavoriteRepository>();

  void getPostSelf() {
    emit(FavoritePostLoadingState());
    _repository
        .getFavoritePost()
        ?.then((value) => {
      emit(FavoritePostLoadedState(listFavoritePosts: value))
    })
        .catchError((onError) => {
      if (onError.response.statusCode == 400)
        {
          errorMessage = onError.response.data['detail'],
        },
      emit(FavoritePostLoadedErrorState(
          CatchException.convertException(onError)))
    }).onError((error, stackTrace) => {
      emit(FavoritePostLoadedErrorState(
          CatchException.convertException(error)))
    });
  }
}