import 'dart:io';

import 'package:dio/dio.dart';
import '/domain/model/profile/create_review_entity.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/model/profile/review_entity.dart';
import '/domain/repository/profile_repository.dart';

import '../../di/post_di.dart';
import '../api/api_util.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ApiUtil _apiUtil = serviceDiPost<ApiUtil>();

  @override
  Future<ProfileEntity>? getProfile({required int id}) {
    return _apiUtil.getProfile(id: id);
  }

  @override
  Future<ProfileEntity>? getProfileSelf() {
    return _apiUtil.getProfileSelf();
  }

  @override
  Future<List<ProfileEntity>>? getProfiles({String? city, String? type, int? gender}) {
    return _apiUtil.getProfiles(city: city, type: type, gender: gender);
  }

  @override
  Future<List<ReviewEntity>>? getReviews({int? userId}) {
    return _apiUtil.getReviews(userId: userId);
  }

  @override
  Future<List<ProfileEntity>>? getTalents({String? city}) {
    return _apiUtil.getTalents(city: city);
  }

  @override
  Future<Response> createReview({required CreateReviewEntity body}) {
    return _apiUtil.createReview(body: body);
  }

  @override
  Future<Response> updateProfileHirer(int id, ProfileEntity body, List<File> photos) {
    return _apiUtil.updateProfileHirer(id: id, body: body, photos: photos);
  }
}
