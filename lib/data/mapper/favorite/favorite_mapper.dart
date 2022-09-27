import '/data/api/models/favorite/api_favorite_response.dart';
import '/domain/model/favorite/favorite_entity.dart';

class FavoriteMapper {
  static FavoriteEntity fromApi(ApiFavoriteResponse response) {
    return FavoriteEntity(
      id: response.id,
    );
  }
}
