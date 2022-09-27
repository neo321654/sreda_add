import '/data/api/constants.dart';
import '/data/api/models/post/api_post_response.dart';
import '/domain/model/auth/post_entity.dart';

class PostMapper {
  static PostEntity fromApi(ApiPostResponse response) {
    return PostEntity(
      id: response.id,
      authorId: response.authorId,
      authorName: response.authorName,
      authorAvatar: getAvatar(response.authorAvatar),
      title: response.title,
      executionDate: response.executionDate,
      budget: response.budget,
      ageFrom: response.ageFrom,
      ageTo: response.ageTo,
      growthFrom: response.growthFrom,
      growthTo: response.growthTo,
      city: response.city,
      moreDescription: response.moreDescription,
      performerGender: response.performerGender,
      isTatoo: response.isTatoo,
      isForeignPassport: response.isForeignPassport,
      otherDetails: response.otherDetails,
      category: response.category,
      createdDate: response.createdDate,
      lastUpdatedDate: response.lastUpdatedDate,
      photos: getPhotos(response),
    );
  }

  static List<String> getPhotos(ApiPostResponse response) {
    if (response.photos.isNotEmpty && response.photos != null) {
      return response.photos
          .map((innerMap) => innerMap['photo']
              .replaceAll(ApiConstants.TO_REPLACE_LINK_WHITH_HTTP, ApiConstants.BASE_URL_IMAGE)
              .toString())
          .toList();
    } else {
      return response.photos
          .map((innerMap) =>
              "https://ichef.bbci.co.uk/news/976/cpsprodpb/12A9A/production/_120424467_joy2.jpg"
                  .toString())
          .toList();
    }
  }

  static String getAvatar(String url) {
    if (url != null && url.isNotEmpty) {
      return url.replaceAll(ApiConstants.TO_REPLACE_LINK_WHITH_HTTP, ApiConstants.BASE_URL_IMAGE);
    } else {
      return "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png";
    }
  }
}
