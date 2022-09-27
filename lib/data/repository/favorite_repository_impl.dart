import '/data/api/api_util.dart';
import '/di/post_di.dart';
import '/domain/model/auth/post_entity.dart';
import '/domain/model/favorite/favorite_entity.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/model/reply/reply_entity.dart';
import '/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  final ApiUtil _apiUtil = serviceDiPost<ApiUtil>();

  @override
  Future<List<FavoriteEntity>>? getFavorites() {
    return _apiUtil.getFavorites();
  }

  @override
  Future<List<PostEntity>>? getFavoritePost() {
    return _apiUtil.getFavoritePost();
  }

  @override
  Future<List<ProfileEntity>>? getFavoritesModel() {
    return _apiUtil.getFavoritesModel();
  }

  @override
  Future<bool> setFavorite(
      {required bool isFavorite, required int modelId}) {
    return _apiUtil.setFavorite(
        isFavorite: isFavorite, modelId: modelId);
  }

  @override
  Future<List<ReplyEntity>>? getReplies() {
    return _apiUtil.getRepliesSelf();
  }
}
