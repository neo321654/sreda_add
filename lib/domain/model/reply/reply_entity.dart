import '/domain/model/auth/post_entity.dart';
import '/domain/model/profile/profile_entity.dart';

class ReplyEntity {
  final int? id;
  final String? acceptanceStatus;
  final ProfileEntity? profile;
  final PostEntity? post;

  ReplyEntity({
    required this.id,
    required this.acceptanceStatus,
    required this.profile,
    required this.post,
  });
}
