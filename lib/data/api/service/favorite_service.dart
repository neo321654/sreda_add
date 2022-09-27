import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/constants.dart';
import '/data/api/models/favorite/api_favorite_response.dart';
import '/data/api/models/post/api_post_response.dart';
import '/data/api/models/profile/api_profile_response.dart';
import '/data/api/models/reply/ApiResponseReply.dart';

class FavoriteService {
  final String _baseUrl = ApiConstants.BASE_URL;
  final Dio _dio = Dio();

  Future<List<ApiFavoriteResponse>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    print("TOKEN: ${prefs.getString("TOKEN")}");
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    final response = await _dio.get(
      '${_baseUrl}get-reply-for-model/',
    );
    List<ApiFavoriteResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiFavoriteResponse.fromApi(value))});
    return list;
  }

  Future<List<ApiPostResponse>> getFavoritesPost() async {
    final prefs = await SharedPreferences.getInstance();
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final response = await _dio.get(
      '${_baseUrl}favorite-posts/',
    );
    List<ApiPostResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiPostResponse.fromApi(value))});
    return list;
  }

  Future<List<ApiProfileResponse>> getFavoritesModel() async {
    final prefs = await SharedPreferences.getInstance();
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final response = await _dio.get(
      '${_baseUrl}favorite-people/',
    );
    List<ApiProfileResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiProfileResponse.fromApi(value))});
    return list;
  }

  Future<List<ApiReplyResponse>> getReplies(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final response = await _dio
        .get('${_baseUrl}reply/', queryParameters: {'on_post': postId, 'acceptance_status': 'На рассмотрении'});
    List<ApiReplyResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiReplyResponse.fromApi(value))});
    return list;
  }

  Future<bool> setFavorite({required bool isFavorite, required int modelId}) async {
    final prefs = await SharedPreferences.getInstance();
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    if (isFavorite) {
      final response = await _dio.post('${_baseUrl}favorite/', data: {"favorite_models": modelId});
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } else {
      final response = await _dio.patch('${_baseUrl}update-favorite-people/', data: {"favorite_models": modelId});
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<List<ApiReplyResponse>> getRepliesSelf() async {
    final prefs = await SharedPreferences.getInstance();
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final response = await _dio.get('${_baseUrl}reply-self/');
    List<ApiReplyResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiReplyResponse.fromApi(value))});
    return list;
  }
}
