import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/new_code/common/functional.dart';

enum AuthState {
  authenticated,
  unauthenticated,
}

class NoAuthTokenException extends Equatable implements Exception {
  @override
  List get props => [];
}

// TODO: replace all of the previous dev usages of SharedPreferences with these services

typedef AuthTokenGetter = Future<String> Function();
typedef AuthTokenStorer = Future<Either<Exception, void>> Function(String token);
typedef AuthStateGetter = Future<Either<Exception, AuthState>> Function();

const _authTokenKey = "TOKEN";

AuthTokenGetter newAuthTokenGetter(SharedPreferences sp) => () async {
      return sp.getString(_authTokenKey) ?? (throw NoAuthTokenException());
    };

AuthTokenStorer newAuthTokenStorer(SharedPreferences sp) => (token) => withExceptionHandling(() async {
      await sp.setString(_authTokenKey, token);
    });

AuthStateGetter newAuthStateGetter(AuthTokenGetter getAuthToken) => () => withExceptionHandling(() async {
      try {
        await getAuthToken();
      } on NoAuthTokenException {
        return AuthState.unauthenticated;
      }
      return AuthState.authenticated;
    });
