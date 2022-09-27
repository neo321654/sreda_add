import 'package:get_it/get_it.dart';
import '/data/api/service/favorite_service.dart';
import '/data/repository/favorite_repository_impl.dart';
import '/domain/repository/favorite_repository.dart';

import '../data/api/api_util.dart';
import '../data/api/service/post_service.dart';
import '../data/api/service/profile_service.dart';
import '../data/repository/post_repository_impl.dart';
import '../data/repository/profile_repository_impl.dart';
import '../domain/repository/post_repository.dart';
import '../domain/repository/profile_repository.dart';

final GetIt serviceDiPost = GetIt.I;

Future<void> setupDi() async {

  //Repositories
  serviceDiPost.registerFactory<PostRepository>(() => PostRepositoryImpl());
  serviceDiPost.registerFactory<ApiUtil>(() => ApiUtil());
  serviceDiPost.registerFactory<PostService>(() => PostService());

  //Repositories
  serviceDiPost.registerFactory<ProfileRepository>(() => ProfileRepositoryImpl());
  serviceDiPost.registerFactory<ProfileService>(() => ProfileService());

  //Repositories
  serviceDiPost.registerFactory<FavoriteRepository>(() => FavoriteRepositoryImpl());
  serviceDiPost.registerFactory<FavoriteService>(() => FavoriteService());
}