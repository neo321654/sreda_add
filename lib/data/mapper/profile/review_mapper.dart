import '/data/api/models/profile/api_review_response.dart';
import '/domain/model/profile/review_entity.dart';

class ReviewMapper {
  static ReviewEntity fromApi(ApiReviewResponse response) {
    return ReviewEntity(
      id: response.id,
      text: response.text,
      mark: response.mark,
      authorName: response.author!['name'],
      authorPhoto: response.author!['photo'],
      profilePhotos: response.author?['profile_photos']?[0],
    );
  }
}
