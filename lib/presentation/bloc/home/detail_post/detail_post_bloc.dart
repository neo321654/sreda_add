import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/model/auth/post_entity.dart';
import '/domain/repository/post_repository.dart';
import '/presentation/bloc/home/detail_post/detail_post_state.dart';

class DetailPostBloc extends Cubit<DetailPostState> {
  String errorMessage = "dsfgdsgf";
  String userType = "";
  final PostRepository _repository = serviceDiPost<PostRepository>();

  DetailPostBloc() : super(DetailPostScreenInitial()) {
    _getUserType();
  }

  void dispose() {}

  void getPostById(int id) async {
    emit(DetailPostScreenLoading());
    try {
      PostEntity? data = await _repository.getPostById(id: id);
      emit(DetailPostScreenSuccess(data: data));
    } on Exception {
      emit(DetailPostScreenError());
    }
  }

  void _getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userType = preferences.getString("TYPE") ?? "";
  }

  Future<void> createReply({required int postId}) async {
    emit(DetailPostScreenLoading());
    _repository
        .createReply(postId: postId)
        .then((value) => {emit(ReplySuccess()), getPostById(postId)})
        .catchError((onError) => {
              print('ProfileEror ===== $onError'),
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['message'],
                },
              emit(ReplyLoadedErrorState(
                  CatchException.convertException(onError))),
              getPostById(postId)
            })
        .onError((error, stackTrace) => {
              emit(
                  ReplyLoadedErrorState(CatchException.convertException(error)))
            });
  }
}
