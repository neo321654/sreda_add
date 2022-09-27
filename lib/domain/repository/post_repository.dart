import 'package:dio/dio.dart';
import '/domain/model/auth/post_entity.dart';
import '/domain/model/post/create_post_request_entity.dart';
import '/domain/model/reply/reply_entity.dart';

abstract class PostRepository {
  Future<PostEntity>? getPostById({
    required int id,
  });

  Future<List<PostEntity>>? getPosts(
      {String? city,
      String? workType,
      String? category,
      String? gender,
      int? fromPrice,
      int? toPrice});

  Future<Response> createPost(
      {required CreatePostRequestEntity createPostRequestEntity});

  Future<List<ReplyEntity>>? getReplies(int postId);

  Future<Response> declineReply(int id);

  Future<Response> acceptReply(int id);

  Future<Response> createReply({required int postId});

  Future<Response> deleteReply({required int replyId});

  Future<Response> deletePost({required int postId});

  Future<Response> updatePost(
      {required int postId,
      required String title,
      required String budget,
      required String description,
      required List<dynamic> photoList});
}
