import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '/data/api/constants.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/repository/favorite_repository.dart';
import '/domain/repository/profile_repository.dart';
import '/presentation/bloc/profile/profile_model_screen_state.dart';

class ProfileModelScreenBloc extends Cubit<ProfileModelScreenState> {
  ProfileModelScreenBloc() : super(ProfileModelScreenInitial());

  String errorMessage = '';
  int profileId = 0;

  final ProfileRepository _repository = serviceDiPost<ProfileRepository>();
  final FavoriteRepository _favoriteRepository = serviceDiPost<FavoriteRepository>();

  Future<void> getProfile(int profileId) async {
    this.profileId = profileId;
    // emit(ProfileLoadingState());
    _repository
        .getProfile(id: profileId)
        ?.then((value) => {emit(ProfileLoadedState(profileEntity: value))})
        .catchError((onError) => {
              print('ProfileEror ===== $onError'),
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(ProfileLoadedErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(ProfileLoadedErrorState(CatchException.convertException(error)))});
  }

  Future<void> getProfileSelf() async {
    emit(ProfileLoadingState());
    _repository
        .getProfileSelf()
        ?.then((value) => {emit(ProfileLoadedState(profileEntity: value))})
        .catchError((onError) => {
              print('ProfileEror ===== $onError'),
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(ProfileLoadedErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(ProfileLoadedErrorState(CatchException.convertException(error)))});
  }

  Future<void> setFavorite({required bool isFavorite, required int modelId}) async {
    // emit(ProfileLoadingState());
    _favoriteRepository
        .setFavorite(isFavorite: !isFavorite, modelId: modelId)
        .then((value) => getProfile(profileId))
        .catchError((onError) => {
              print('ProfileError ===== $onError'),
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(ProfileLoadedErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(ProfileLoadedErrorState(CatchException.convertException(error)))});
  }

  Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  Future<File> _fileFromImageUrl(String url) async {
    final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes, followRedirects: false));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(p.join(documentDirectory.path, '${generateRandomString(10)}.png'));
    file.writeAsBytesSync(response.data);

    return file;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Future<void> updateProfileHirer(int id, ProfileEntity body, List<dynamic> photoList) async {
    emit(ProfileLoadingState());
    List<File> resultPhotos = await mapperPhoto(photoList);
    await Future.delayed(const Duration(seconds: 2));
    _repository
        .updateProfileHirer(id, body, resultPhotos)
        .then((value) => {emit(UpdateProfileHirerLoadedState())})
        .catchError((onError) => {
              print('ProfileEror ===== $onError'),
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(ProfileLoadedErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(ProfileLoadedErrorState(CatchException.convertException(error)))});
  }

  Future<List<File>> mapperPhoto(List<dynamic> photoList) async {
    List<File> resultPhotos = [];
    photoList.forEach((element) async {
      if (element is String) {
        if (element.toString().contains("user_profile_photo")) {
          var myFile = await _fileFromImageUrl(ApiConstants.BASE_URL_IMAGE + '/media/' + element);
          resultPhotos.add(myFile);
        } else {
          resultPhotos.add(File(element));
        }
      }
    });
    return resultPhotos;
  }
}
