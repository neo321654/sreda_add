import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/profile/profile_entity.dart';

abstract class TalentsWidgetState extends Equatable {
  @override
  List<Object> get props => [];
}

class TalentsWidgetInitial extends TalentsWidgetState {}

class TalentsWidgetLoading extends TalentsWidgetState {}

class TalentsWidgetErrorState extends TalentsWidgetState {
  final CatchException? message;

  TalentsWidgetErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

class TalentsWidgetLocalErrorState extends TalentsWidgetState {
  final String? message;

  TalentsWidgetLocalErrorState({this.message});

  @override
  List<Object> get props => [message!];
}

class TalentsWidgetSuccess extends TalentsWidgetState {
  final List<ProfileEntity>? data;

  TalentsWidgetSuccess({required this.data});
}
