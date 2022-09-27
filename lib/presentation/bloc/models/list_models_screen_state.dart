import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/profile/profile_entity.dart';

class ListModelsScreenState extends Equatable{
  @override
  List<Object> get props => [];
}

class ListModelsScreenInitial extends ListModelsScreenState {}

class ListModelsScreenLoading extends ListModelsScreenState {}

class ListModelsScreenErrorState extends ListModelsScreenState {
  final CatchException? message;

  ListModelsScreenErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

class ListModelsScreenLocalErrorState extends ListModelsScreenState {
  final String? message;

  ListModelsScreenLocalErrorState({this.message});

  @override
  List<Object> get props => [message!];
}

class ListModelsScreenSuccess extends ListModelsScreenState {
  final List<ProfileEntity>? data;

  ListModelsScreenSuccess({required this.data});
}