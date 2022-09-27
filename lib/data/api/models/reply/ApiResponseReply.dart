import '/data/api/models/post/api_post_response.dart';
import '/data/api/models/profile/api_profile_response.dart';

class ApiReplyResponse {
  final int? id;
  final String? acceptanceStatus;
  final ApiProfileResponse profile;
  final ApiPostResponse post;

  ApiReplyResponse.fromApi(Map<String, dynamic> map)
      : id = map['id'],
        acceptanceStatus = map['acceptance_status'],
        post = ApiPostResponse.fromApi(map['on_post']),
        profile = ApiProfileResponse.fromApi(map['profile_user']){
    print('vadvav');
  }
}
