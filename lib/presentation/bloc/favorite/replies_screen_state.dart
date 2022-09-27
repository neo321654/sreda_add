import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/reply/reply_entity.dart';

class RepliesScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class RepliesInitial extends RepliesScreenState {

}

class RepliesLoadingState extends RepliesScreenState {}

class CreateRepliesSuccessState extends RepliesScreenState {}

class RepliesLoadedState extends RepliesScreenState {
  final List<ReplyEntity> listReplies;

  RepliesLoadedState({required this.listReplies});
}

class RepliesLoadedErrorState extends RepliesScreenState {
  final CatchException? message;

  RepliesLoadedErrorState(this.message);

  @override
  List<Object> get props => [message!];
}