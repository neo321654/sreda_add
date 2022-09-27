import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';

abstract class CreatePostState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostErrorState extends CreatePostState {
  final CatchException? message;

  CreatePostErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

class CreatePostLocalErrorState extends CreatePostState {
  final String? message;

  CreatePostLocalErrorState({this.message});

  @override
  List<Object> get props => [message!];
}

class CreatePostSuccess extends CreatePostState {}