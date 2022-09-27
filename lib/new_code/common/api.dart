import 'package:dio/dio.dart';

import '../auth/services.dart';

typedef BaseOptionsGetter = Future<Options> Function();

BaseOptionsGetter newBaseOptionsGetter(AuthTokenGetter getAuthToken) => () async {
      final token = await getAuthToken();
      final options = Options(
        responseType: ResponseType.json,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print(options.headers);
      return options;
    };
