import '/domain/model/auth/post_entity.dart';
import '/domain/model/favorite/favorite_entity.dart';
import '/domain/model/profile/profile_entity.dart';
import '/domain/model/reply/reply_entity.dart';

abstract class FavoriteRepository {

  Future<List<FavoriteEntity>>? getFavorites();

  Future<List<PostEntity>>? getFavoritePost();

  Future<List<ProfileEntity>>?  getFavoritesModel();

  Future<bool> setFavorite({required bool isFavorite, required int modelId});

  Future<List<ReplyEntity>>? getReplies();

}