import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/auth/post_entity.dart';
import '/domain/model/profile/profile_entity.dart';

abstract class HomeScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenErrorState extends HomeScreenState {
  final CatchException? message;

  HomeScreenErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

class HomeScreenLocalErrorState extends HomeScreenState {
  final String? message;

  HomeScreenLocalErrorState({this.message});

  @override
  List<Object> get props => [message!];
}

class HomeScreenSuccess extends HomeScreenState {
  final List<PostEntity>? data;

  HomeScreenSuccess({required this.data});
}

class HomeScreenTalentsSuccess extends HomeScreenState {
  final List<ProfileEntity>? data;

  HomeScreenTalentsSuccess({required this.data});
}
