import '/data/api/models/reply/ApiResponseReply.dart';
import '/data/mapper/auth/post_mapper.dart';
import '/data/mapper/profile/profile_mapper.dart';
import '/domain/model/reply/reply_entity.dart';

class ReplyMapper {
  static ReplyEntity fromApi(ApiReplyResponse response) {
    return ReplyEntity(
      id: response.id,
      acceptanceStatus: response.acceptanceStatus,
      profile: ProfileMapper.fromApi(response.profile),
      post: PostMapper.fromApi(response.post)
    );
  }
}