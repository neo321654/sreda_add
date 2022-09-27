import 'package:dartz/dartz.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/new_code/auth/api/auth_api.dart';
import '/new_code/auth/services.dart';

import '../common/functional.dart';

typedef SocialTokenGetter = Future<String?> Function();
// Returns true if it was a registration and false if it was a login (null if auth was canceled)
typedef SocialAuthenticator = Future<Either<Exception, bool?>> Function();

// SocialTokenGetter newGoogleTokenGetter(GoogleSignIn gSignIn) => () async {
//       final result = await gSignIn.signIn();
//       if (result == null) return null;
//       final auth = await result.authentication;
//       return auth.idToken;
//     };

const _appleAuthClientId = "com.sredaappleauth.sreda";
// TODO: update this to be in the django server
final _appleRedirectUri = Uri.parse(
  "https://irradiated-obtainable-venus.glitch.me/callbacks/sign_in_with_apple",
);
SocialTokenGetter newAppleTokenGetter() => () async {
      // final credential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [AppleIDAuthorizationScopes.email],
      //   webAuthenticationOptions: WebAuthenticationOptions(
      //     clientId: _appleAuthClientId,
      //     redirectUri: _appleRedirectUri,
      //   ),
      // );
      // return credential.authorizationCode;
    };

SocialAuthenticator newSocialAuthenticator(
  SocialTokenGetter getSocialToken,
  BackendSocialAuthenticator getBackendToken,
  AuthTokenStorer storeToken,
) =>
    () => withExceptionHandling(() async {
          final token = await getSocialToken();
          if (token == null) return null;
          final backendResp = await getBackendToken(token);
          await storeToken(backendResp.authToken).then((r) => r.fold(
                (exception) => throw exception,
                (_) => null,
              ));
          return backendResp.isNewUser;
        });
