import 'dart:io';

import 'package:dio/dio.dart';
import '/data/api/service/favorite_service.dart';
import '/data/api/service/post_service.dart';
import '/data/api/service/profile_service.dart';
import '/data/mapper/favorite/favorite_mapper.dart';
import '/data/mapper/profile/profile_mapper.dart';
import '/data/mapper/profile/review_mapper.dart';
import '/data/mapper/reply/reply_mapper.dart';
import '/domain/model/favorite/favorite_entity.dart';
import '/domain/model/post/create_post_request_entity.dart';
import '/domain/model/profile/create_review_entity.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/model/profile/review_entity.dart';
import '/domain/model/reply/reply_entity.dart';

import '../../di/post_di.dart';
import '../../domain/model/auth/post_entity.dart';
import '../mapper/auth/post_mapper.dart';

class ApiUtil {
  final PostService _postService = serviceDiPost<PostService>();
  final ProfileService _profileService = serviceDiPost<ProfileService>();
  final FavoriteService _favoriteService = serviceDiPost<FavoriteService>();

  Future<PostEntity> getPostById({
    required int id,
  }) async {
    final result = await _postService.getPostById(id);
    return PostMapper.fromApi(result);
  }

  Future<List<PostEntity>> getPosts(
      {String? city,
      String? workType,
      String? category,
        String? gender,
      int? fromPrice,
      int? toPrice}) async {
    final result = await _postService.getPosts(
      city: city,
      workType: workType,
      category: category,
      gender: gender,
      fromPrice: fromPrice,
      toPrice: toPrice,
    );
    List<PostEntity> list = [];
    for (var element in result) {
      list.add(PostMapper.fromApi(element));
    }
    return list;
  }

  Future<ProfileEntity> getProfile({required int id}) async {
    final result = await _profileService.getProfile(id: id);
    return ProfileMapper.fromApi(result);
  }

  Future<ProfileEntity> getProfileSelf() async {
    final result = await _profileService.getProfileSelf();
    return ProfileMapper.fromApi(result);
  }

  Future<List<ProfileEntity>> getProfiles(
      {String? city, String? type, int? gender}) async {
    final result = await _profileService.getProfiles(
        city: city, type: type, gender: gender);
    List<ProfileEntity> list = [];
    for (var element in result) {
      list.add(ProfileMapper.fromApi(element));
    }
    return list;
  }

  Future<List<ReviewEntity>> getReviews({int? userId}) async {
    final result = await _profileService.getReviews(userId: userId);
    List<ReviewEntity> list = [];
    for (var element in result) {
      list.add(ReviewMapper.fromApi(element));
    }
    return list;
  }

  Future<List<FavoriteEntity>>? getFavorites() async {
    final result = await _favoriteService.getFavorites();
    List<FavoriteEntity> list = [];
    for (var element in result) {
      list.add(FavoriteMapper.fromApi(element));
    }
    return list;
  }

  Future<List<ProfileEntity>>? getTalents({String? city}) async {
    final result = await _profileService.getTalents(city: city ?? '');
    List<ProfileEntity> list = [];
    for (var element in result) {
      list.add(ProfileMapper.fromApi(element));
    }
    return list;
  }

  Future<Response> createPost({required CreatePostRequestEntity body}) async {
    return await _profileService.createPost(body);
  }

  Future<Response> createReview({required CreateReviewEntity body}) async {
    return await _profileService.createReview(body: body);
  }

  Future<List<PostEntity>>? getFavoritePost() async {
    final result = await _favoriteService.getFavoritesPost();
    List<PostEntity> list = [];
    for (var element in result) {
      list.add(PostMapper.fromApi(element));
    }
    return list;
  }

  Future<List<ProfileEntity>>? getFavoritesModel() async {
    final result = await _favoriteService.getFavoritesModel();
    List<ProfileEntity> list = [];
    for (var element in result) {
      list.add(ProfileMapper.fromApi(element));
    }
    return list;
  }

  Future<List<ReplyEntity>>? getReplies(int postId) async {
    final result = await _favoriteService.getReplies(postId);
    List<ReplyEntity> list = [];
    for (var element in result) {
      list.add(ReplyMapper.fromApi(element));
    }
    return list;
  }

  Future<bool> setFavorite(
      {required bool isFavorite, required int modelId}) async {
    return await _favoriteService.setFavorite(
        isFavorite: isFavorite, modelId: modelId);
  }

  Future<Response> acceptReply({required int id}) async {
    return await _profileService.acceptReply(id: id);
  }

  Future<Response> declineReply({required int id}) async {
    return await _profileService.declineReply(id: id);
  }

  Future<List<ReplyEntity>>? getRepliesSelf() async {
    final result = await _favoriteService.getRepliesSelf();
    List<ReplyEntity> list = [];
    for (var element in result) {
      list.add(ReplyMapper.fromApi(element));
    }
    return list;
  }

  Future<Response> createReply({required int postId}) async {
    return await _profileService.createReply(postId: postId);
  }

  Future<Response> deleteReply({required int replyId}) async {
    return await _profileService.deleteReply(replyId: replyId);
  }

  Future<Response> updateProfileHirer(
      {required int id,
      required ProfileEntity body,
      required List<File> photos}) async {
    return await _profileService.updateProfileHirer(
        id: id, model: body, photos: photos);
  }

  Future<Response> deletePost({required int postId}) async {
    return await _profileService.deletePost(postId: postId);
  }

  Future<Response> updatePost(
      {required int postId,
      required String title,
      required String budget,
      required String description,
      required List<dynamic> photoList}) async {
    return await _profileService.updatePost(
        postId: postId,
        title: title,
        budget: budget,
        description: description,
        photoList: photoList);
  }
}
