import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/model/reply/reply_entity.dart';

abstract class FavoriteModelScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteModelScreenInitial extends FavoriteModelScreenState {}

class FavoriteModelScreenLoading extends FavoriteModelScreenState {}

class DeleteRepliesScreenSuccess extends FavoriteModelScreenState {}

class FavoriteModelScreenErrorState extends FavoriteModelScreenState {
  final CatchException? message;

  FavoriteModelScreenErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

class FavoriteModelScreenLocalErrorState extends FavoriteModelScreenState {
  final String? message;

  FavoriteModelScreenLocalErrorState({this.message});

  @override
  List<Object> get props => [message!];
}

class FavoriteModelScreenSuccess extends FavoriteModelScreenState {
  final List<ProfileEntity>? data;

  FavoriteModelScreenSuccess({required this.data});
}

class FavoriteModelRepliesScreenSuccess extends FavoriteModelScreenState {
  final List<ReplyEntity>? data;

  FavoriteModelRepliesScreenSuccess({required this.data});
}
