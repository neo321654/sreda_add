import 'package:dio/dio.dart';
import '/data/api/api_util.dart';
import '/di/post_di.dart';
import '/domain/model/auth/post_entity.dart';
import '/domain/model/post/create_post_request_entity.dart';
import '/domain/model/reply/reply_entity.dart';

import '../../domain/repository/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final ApiUtil _apiUtil = serviceDiPost<ApiUtil>();

  @override
  Future<PostEntity>? getPostById({required int id}) {
    return _apiUtil.getPostById(id: id);
  }

  @override
  Future<List<PostEntity>>? getPosts(
      {String? city,
      String? workType,
      String? category,
        String? gender,
      int? fromPrice,
      int? toPrice}) {
    return _apiUtil.getPosts(
      city: city,
      workType: workType,
      category: category,
      gender: gender,
      fromPrice: fromPrice,
      toPrice: toPrice,
    );
  }

  @override
  Future<Response> createPost(
      {required CreatePostRequestEntity createPostRequestEntity}) {
    return _apiUtil.createPost(body: createPostRequestEntity);
  }

  @override
  Future<List<PostEntity>>? getFavoritePost() {
    return _apiUtil.getFavoritePost();
  }

  @override
  Future<List<ReplyEntity>>? getReplies(int postId) {
    return _apiUtil.getReplies(postId);
  }

  @override
  Future<Response> acceptReply(int id) {
    return _apiUtil.acceptReply(id: id);
  }

  @override
  Future<Response> declineReply(int id) {
    return _apiUtil.declineReply(id: id);
  }

  @override
  Future<Response> createReply({required int postId}) {
    return _apiUtil.createReply(postId: postId);
  }

  @override
  Future<Response> deleteReply({required int replyId}) {
    return _apiUtil.deleteReply(replyId: replyId);
  }

  @override
  Future<Response> deletePost({required int postId}) {
    return _apiUtil.deletePost(postId: postId);
  }

  @override
  Future<Response> updatePost(
      {required int postId,
      required String title,
      required String budget,
      required String description,
      required List photoList}) {
    return _apiUtil.updatePost(
        postId: postId,
        title: title,
        budget: budget,
        description: description,
        photoList: photoList);
  }
}
