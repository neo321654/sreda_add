import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/auth/post_entity.dart';

class FavoritePostState extends Equatable {
@override
List<Object> get props => [];
}

class FavoritePostInitial extends FavoritePostState {}

class FavoritePostLoadingState extends FavoritePostState {}

class CreateFavoritePostSuccessState extends FavoritePostState {}

class FavoritePostLoadedState extends FavoritePostState {
  final List<PostEntity> listFavoritePosts;

  FavoritePostLoadedState({required this.listFavoritePosts});
}

class FavoritePostLoadedErrorState extends FavoritePostState {
  final CatchException? message;

  FavoritePostLoadedErrorState(this.message);

  @override
  List<Object> get props => [message!];
}
