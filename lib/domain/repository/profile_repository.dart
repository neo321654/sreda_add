import 'dart:io';

import 'package:dio/dio.dart';
import '/domain/model/profile/create_review_entity.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/model/profile/review_entity.dart';

abstract class ProfileRepository {

  Future<ProfileEntity>? getProfile({required int id});

  Future<ProfileEntity>? getProfileSelf();

  Future<List<ProfileEntity>>? getTalents({String? city});

  Future<List<ProfileEntity>>? getProfiles({String? city, String? type, int? gender});

  Future<List<ReviewEntity>>? getReviews({int? userId});

  Future<Response> createReview({required CreateReviewEntity body});

  Future<Response> updateProfileHirer(int id, ProfileEntity body, List<File> photos);

}