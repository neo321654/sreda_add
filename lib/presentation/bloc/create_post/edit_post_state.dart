part of 'edit_post_cubit.dart';

@immutable
abstract class EditPostState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditPostInitial extends EditPostState {}

class EditPostLoading extends EditPostState {}

class EditPostErrorState extends EditPostState {
  final CatchException? message;

  EditPostErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

class EditPostLocalErrorState extends EditPostState {
  final String? message;

  EditPostLocalErrorState({this.message});

  @override
  List<Object> get props => [message!];
}

class EditPostSuccess extends EditPostState {}