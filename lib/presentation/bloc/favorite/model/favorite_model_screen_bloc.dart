import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/repository/favorite_repository.dart';
import '/domain/repository/post_repository.dart';
import '/presentation/bloc/favorite/model/favorite_model_screen_state.dart';

class FavoriteModelScreenBloc extends Cubit<FavoriteModelScreenState> {
  String errorMessage = "dsfgdsgf";
  final FavoriteRepository _repository = serviceDiPost<FavoriteRepository>();
  final PostRepository _postRepository = serviceDiPost<PostRepository>();

  FavoriteModelScreenBloc() : super(FavoriteModelScreenInitial()) {
    getReplies();
    getFavoriteModels();
  }

  Future<void> getReplies() async {
    emit(FavoriteModelScreenLoading());
    _repository
        .getReplies()
        ?.then(
            (value) => {emit(FavoriteModelRepliesScreenSuccess(data: value))})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(FavoriteModelScreenErrorState(
                  CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {
              emit(FavoriteModelScreenErrorState(
                  CatchException.convertException(error)))
            });
  }

  Future<void> deleteReply({required int replyId}) async {
    emit(FavoriteModelScreenLoading());
    _postRepository
        .deleteReply(replyId: replyId)
        .then((value) => {
              emit(DeleteRepliesScreenSuccess()),
            getReplies()
            })
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(FavoriteModelScreenErrorState(
                  CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {
              emit(FavoriteModelScreenErrorState(
                  CatchException.convertException(error)))
            });
  }

  Future<void> getFavoriteModels() async {
    emit(FavoriteModelScreenLoading());
    _repository
        .getFavoritesModel()
        ?.then(
            (value) => {emit(FavoriteModelScreenSuccess(data: value))})
        .catchError((onError) => {
      if (onError.response.statusCode == 400)
        {
          errorMessage = onError.response.data['detail'],
        },
      emit(FavoriteModelScreenErrorState(
          CatchException.convertException(onError)))
    })
        .onError((error, stackTrace) => {
      emit(FavoriteModelScreenErrorState(
          CatchException.convertException(error)))
    });
  }
}
