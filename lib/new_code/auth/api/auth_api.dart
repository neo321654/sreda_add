import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import '/data/api/constants.dart';
import '/new_code/auth/api/auth_response.dart';

typedef BackendSocialAuthenticator = Future<AuthResponse> Function(String socialToken);

const _googleAuthEndpoint = "social-auth-google/";
const _appleAuthEndpoint = "social-auth-apple/";

BackendSocialAuthenticator newBackendGoogleAuthenticator(Dio dio) => _newBaseBackendSocialAuthenticator(
      dio,
      _googleAuthEndpoint,
    );

BackendSocialAuthenticator newBackendAppleAuthenticator(Dio dio) => _newBaseBackendSocialAuthenticator(
      dio,
      _appleAuthEndpoint,
    );

const _appleServiceId = "com.sredaappleauth.sreda";
const _appleBundleId = "com.sredamodels.sreda";

String _getClientId() => Platform.isIOS ? _appleBundleId : _appleServiceId;

BackendSocialAuthenticator _newBaseBackendSocialAuthenticator(Dio dio, String endpoint) => (token) async {
      final response = await dio.post(
        ApiConstants.BASE_URL + endpoint,
        data: {
          "token": token,
          "client_id": _getClientId(), // actually it is needed only for Sign In with Apple
        },
        options: Options(headers: {"accept": "application/json"}),
      );
      return AuthResponse.fromJson(response.data);
    };
