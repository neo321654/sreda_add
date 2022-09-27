import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';

class CreateReviewScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateReviewScreenInitial extends CreateReviewScreenState {}

class CreateReviewLoadingState extends CreateReviewScreenState {}

class CreateReviewLoadedState extends CreateReviewScreenState {}

class CreateReviewLoadedErrorState extends CreateReviewScreenState {
  final CatchException? message;

  CreateReviewLoadedErrorState(this.message);

  @override
  List<Object> get props => [message!];
}