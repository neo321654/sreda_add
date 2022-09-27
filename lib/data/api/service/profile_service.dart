import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/constants.dart';
import '/data/api/models/profile/api_profile_response.dart';
import '/data/api/models/profile/api_review_response.dart';
import '/domain/model/post/create_post_request_entity.dart';
import '/domain/model/profile/create_review_entity.dart';
import '/domain/model/profile/profile_entity.dart';

class ProfileService {
  final String _baseUrl = ApiConstants.BASE_URL;
  final Dio _dio = Dio();

  Future<ApiProfileResponse> getProfile({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    final response = await _dio.get(
      '${_baseUrl}profile/$id/',
    );
    return ApiProfileResponse.fromApi(response.data);
  }

  Future<ApiProfileResponse> getProfileSelf() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("TOKEN"));
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    final response = await _dio.get(
      '${_baseUrl}self-profile/',
    );
    return ApiProfileResponse.fromApi(response.data[0]);
  }

  Future<List<ApiProfileResponse>> getProfiles({String? city, String? type, int? gender}) async {
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
    final response = await _dio.get('${_baseUrl}profiles/', queryParameters: {
      if (city != null) 'city': city,
      if (type != null) 'work_type': type,
      if (gender != null) 'gender': gender
    });
    List<ApiProfileResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiProfileResponse.fromApi(value))});
    return list;
  }

  Future<List<ApiReviewResponse>> getReviews({int? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    _dio.options.headers["authorization"] = "Bearer ${prefs.getString("TOKEN")}";
    final response = await _dio.get('${_baseUrl}feedback/', queryParameters: {
      if (userId != null) 'user': userId,
    });
    List<ApiReviewResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiReviewResponse.fromApi(value))});
    return list;
  }

  Future<List<ApiProfileResponse>> getTalents({String? city}) async {
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
    final response = await _dio.get('${_baseUrl}profiles/get-profiles-rating/', queryParameters: {'city': city});
    List<ApiProfileResponse> list = [];
    response.data.asMap().forEach((index, value) => {list.add(ApiProfileResponse.fromApi(value))});
    return list;
  }

  Future<Response> createPost(CreatePostRequestEntity body) async {
    DateFormat dateFormatTo = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateFormat dateFormatFrom = DateFormat("dd.MM.yyyy");
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



    var formData = FormData.fromMap({
      'title': body.title,
      'execution_date': dateFormatTo.format(dateFormatFrom.parse(body.executionDate)),
      'budget': body.budget,
      'city': body.city,
      'performer_gender': body.performerGender,
      'age_from': body.ageFrom,
      'age_to': body.ageTo,
      'growth_from': body.growthFrom,
      'growth_to': body.growthTo,
     'is_tatoo_or_piercings': body.isTattooOrPiercings.contains("Да")?true:false,
      //'is_tatoo_or_piercings': 'false',
      'is_foreign_passport': body.isForeignPassport,
      'other_details': body.otherDetails,
      'category': body.category,
    });
    body.photos.asMap().forEach((index, value) => {
          formData.files.addAll([
            MapEntry("photo[$index]", MultipartFile.fromFileSync(value.path, filename: "${getRandomString(15)}.jpg"))
          ])
        });
    final response = await _dio.post('${_baseUrl}posts/', data: formData);
    return response;
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Response> createReview({required CreateReviewEntity body}) async {
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
    var formData = FormData.fromMap({
      'mark': body.mark,
      'user': body.author,
      'text': body.text,
    });
    final response = await _dio.post('${_baseUrl}feedback/', data: formData);
    return response;
  }

  Future<Response> acceptReply({required int id}) async {
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
    var formData = FormData.fromMap({
      'acceptance_status': 'Принято',
    });
    final response = await _dio.patch('${_baseUrl}reply/$id/', data: formData);
    return response;
  }

  Future<Response> declineReply({required int id}) async {
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
    var formData = FormData.fromMap({
      'acceptance_status': 'Отклонено',
    });
    final response = await _dio.patch('${_baseUrl}reply/$id/', data: formData);
    return response;
  }

  Future<Response> createReply({required int postId}) async {
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
    var formData = FormData.fromMap({
      'on_post': postId,
    });
    final response = await _dio.post('${_baseUrl}reply/', data: formData);
    return response;
  }

  Future<Response> deleteReply({required int replyId}) async {
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
    final response = await _dio.delete('${_baseUrl}reply/$replyId/');
    return response;
  }

  Future<Response> updateProfileHirer(
      {required int id, required ProfileEntity model, required List<File> photos}) async {
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
    var formData = FormData.fromMap({
      'name': model.name,
      'gender': model.gender,
      'age': model.age,
      'city': model.city,
      'phone': model.phone,
      'instagram': model.instagram,
      'facebook': model.facebook,
      'linkedin': model.linkedin,
      'website': model.website,
      'about': model.about,
      'close_size': model.closeSize,
      'shoes_size': model.shoesSize,
      'growth': model.growth,
      'bust': model.bust,
      'waist': model.waist,
      'hips': model.hips,
      'look_type': model.lookType,
      'skin_color': model.skinColor,
      'hair_color': model.hairColor,
      'hair_length': model.hairLength,
      'is_have_international_passport': model.isHaveInternationalPassport,
      'is_have_tattoo': model.isHaveTattoo,
      'is_have_english': model.isHaveEnglish,
      "user_type": "HIRER"
    });
    photos.asMap().forEach((index, value) => {
          formData.files.addAll(
              [MapEntry("photos", MultipartFile.fromFileSync(value.path, filename: "${getRandomString(15)}.jpg"))])
        });
    final response = await _dio.patch('${_baseUrl}update-profile/$id/', data: formData);
    return response;
  }

  Future<Response> deletePost({required int postId}) async {
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
    final response = await _dio.delete('${_baseUrl}posts/$postId/');
    return response;
  }

  Future<Response> updatePost(
      {required int postId,
      required String title,
      required String budget,
      required String description,
      required List<dynamic> photoList}) async {
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
    var formData = FormData.fromMap({
      'title': title,
      'budget': budget,
      'otherDetails': description,
    });
    photoList.asMap().forEach((index, value) => {
          formData.files.addAll(
              [MapEntry("photos", MultipartFile.fromFileSync(value.path, filename: "${getRandomString(15)}.jpg"))])
        });
    final response = await _dio.patch('${_baseUrl}update-posts/$postId/', data: formData);

    return response;
  }
}
