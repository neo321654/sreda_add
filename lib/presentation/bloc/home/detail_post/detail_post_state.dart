import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/auth/post_entity.dart';

abstract class DetailPostState extends Equatable {
  @override
  List<Object> get props => [];
}

class DetailPostScreenInitial extends DetailPostState {}

class DetailPostScreenLoading extends DetailPostState {}

class DetailPostScreenError extends DetailPostState {}

class ReplySuccess extends DetailPostState {}

class ReplyLoadedErrorState extends DetailPostState {
  final CatchException? message;

  ReplyLoadedErrorState(this.message);

  @override
  List<Object> get props => [message!];
}


class DetailPostScreenSuccess extends DetailPostState {
  final PostEntity? data;

  DetailPostScreenSuccess({required this.data});
}
