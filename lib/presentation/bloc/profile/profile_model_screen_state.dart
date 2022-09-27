import 'package:equatable/equatable.dart';
import '/data/api/service/catch_exeptions.dart';
import '/domain/model/profile/profile_entity.dart';

abstract class ProfileModelScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileModelScreenInitial extends ProfileModelScreenState {}

class ProfileLoadingState extends ProfileModelScreenState {}

class UpdateProfileHirerLoadedState extends ProfileModelScreenState {}

class ProfileLoadedState extends ProfileModelScreenState {
  final ProfileEntity profileEntity;
  ProfileLoadedState({required this.profileEntity});


  ProfileLoadedState copyWith({ProfileEntity? profileEntity}){
    return ProfileLoadedState(profileEntity: profileEntity ?? this.profileEntity);
  }

  @override
  List<Object> get props => [profileEntity];
}

class FavoriteLoadedState extends ProfileModelScreenState {
  final bool isFavorite;
  FavoriteLoadedState({required this.isFavorite});
}

class ProfileLoadedErrorState extends ProfileModelScreenState {
  final CatchException? message;

  ProfileLoadedErrorState(this.message);

  @override
  List<Object> get props => [message!];
}
