import 'package:dio/dio.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/service/profile_service.dart';
import '/new_code/auth/api/auth_api.dart';
import '/new_code/auth/auth_gate_cubit.dart';
import '/new_code/auth/services.dart';
import '/new_code/auth/social_auth.dart';
import '/new_code/common/api.dart';
import '/new_code/common/user_type_getter.dart';
import '/new_code/contacts/logic/api/api.dart';
import '/new_code/contacts/logic/services.dart';
import '/new_code/tariffs/logic/api.dart';
import '/new_code/tariffs/logic/cubit/tariffs_cubit.dart';
import '/new_code/tariffs/logic/purchase_services.dart';

class UIDeps {
  final AuthGateCubitFactory authGateCubitFactory;
  final TariffsCubitFactory tariffsCubitFactory;
  final SocialAuthenticator signInWithGoogle;
  final SocialAuthenticator signInWithApple;

  final ContactsGetter getContacts;
  final BoughtContactChecker checkContact;

  final PurchaseHandler handlePurchase;

  // for old code
  final Dio dio;

  const UIDeps(
    this.authGateCubitFactory,
    this.tariffsCubitFactory,
    this.signInWithGoogle,
    this.signInWithApple,
    this.getContacts,
    this.checkContact,
    this.handlePurchase,
    this.dio,
  );
}

late final UIDeps uiDeps;

Future<void> newDi() async {
  final sp = await SharedPreferences.getInstance();
  final getAuthToken = newAuthTokenGetter(sp);

  final getAuthState = newAuthStateGetter(getAuthToken);
  final authGateCubitFactory = newAuthGateCubitFactory(getAuthState);

  final getUserType = newUserTypeGetter(ProfileService());

  final iap = InAppPurchase.instance;

  final getTariffs = newTariffsGetter(iap);
  final getGroups = newTariffGroupsGetter(getTariffs);
  final buyTariff = newTariffBuyer(iap);
  final tariffsCubitFactory = newTariffsCubitFactory(getUserType, getGroups, buyTariff);

  final dio = Dio();
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90));

  final baseOptionsGetter = newBaseOptionsGetter(getAuthToken);
  final authTokenStorer = newAuthTokenStorer(sp);
  // final googleTokenGetter = newGoogleTokenGetter(GoogleSignIn(scopes: ["email"]));
  final googleBackendTokenGetter = newBackendGoogleAuthenticator(dio);
  // final googleAuthenticator = newSocialAuthenticator(googleTokenGetter, googleBackendTokenGetter, authTokenStorer);
  final appleTokenGetter = newAppleTokenGetter();
  final appleBackendTokenGetter = newBackendAppleAuthenticator(dio);
  final appleAuthenticator = newSocialAuthenticator(appleTokenGetter, appleBackendTokenGetter, authTokenStorer);
  final getContacts = newContactsGetter(newAPIContactsGetter(dio, baseOptionsGetter));
  final checkContact = newBoughtContactChecker(newAPIBoughtContactChecker(dio, baseOptionsGetter));
  final handlePurchase = newPurchaseHandler(dio, baseOptionsGetter);

  // uiDeps = UIDeps(
  //   authGateCubitFactory,
  //   tariffsCubitFactory,
  //   googleAuthenticator,
  //   appleAuthenticator,
  //   getContacts,
  //   checkContact,
  //   handlePurchase,
  //   dio,
  // );
}
