import 'package:equatable/equatable.dart';
import '/domain/model/profile/review_entity.dart';

import '../../../data/api/service/catch_exeptions.dart';

class ReviewScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReviewScreenInitial extends ReviewScreenState {}

class ReviewLoadingState extends ReviewScreenState {}

class CreateReviewSuccessState extends ReviewScreenState {}

class ReviewLoadedState extends ReviewScreenState {
  final List<ReviewEntity> listReviews;
  final bool canReview;

  ReviewLoadedState({required this.listReviews, required this.canReview});
}

class ReviewLoadedErrorState extends ReviewScreenState {
  final CatchException? message;

  ReviewLoadedErrorState(this.message);

  @override
  List<Object> get props => [message!];
}
