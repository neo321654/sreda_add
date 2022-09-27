import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/repository/post_repository.dart';
import '/presentation/bloc/favorite/replies_screen_state.dart';

class RepliesScreenBloc extends Cubit<RepliesScreenState> {
  RepliesScreenBloc({required int postId}) : super(RepliesInitial()) {
    getReplies(postId);
  }

  String errorMessage = '';

  final PostRepository _repository = serviceDiPost<PostRepository>();

  void declineReply(int id, int postId) {
    emit(RepliesLoadingState());
    _repository
        .declineReply(id)
        .then((value) => {getReplies(postId)})
        .catchError((onError) => {
      if (onError.response.statusCode == 400)
        {
          errorMessage = onError.response.data['detail'],
        },
      emit(RepliesLoadedErrorState(
          CatchException.convertException(onError)))
    })
        .onError((error, stackTrace) => {
      emit(RepliesLoadedErrorState(
          CatchException.convertException(error)))
    });
  }

  void acceptReply(int id, int postId) {
    emit(RepliesLoadingState());
    _repository
        .acceptReply(id)
        .then((value) => {getReplies(postId)})
        .catchError((onError) => {
      if (onError.response.statusCode == 400)
        {
          errorMessage = onError.response.data['detail'],
        },
      emit(RepliesLoadedErrorState(
          CatchException.convertException(onError)))
    })
        .onError((error, stackTrace) => {
      emit(RepliesLoadedErrorState(
          CatchException.convertException(error)))
    });
  }

  void getReplies(int postId) {
    emit(RepliesLoadingState());
    _repository
        .getReplies(postId)
        ?.then((value) => {emit(RepliesLoadedState(listReplies: value))})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(RepliesLoadedErrorState(
                  CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {
              emit(RepliesLoadedErrorState(
                  CatchException.convertException(error)))
            });
  }
}
