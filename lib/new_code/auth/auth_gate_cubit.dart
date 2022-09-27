import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '/new_code/auth/services.dart';

typedef AuthGateState = Either<Exception, Option<AuthState>>; // None means "loading"

class AuthGateCubit extends Cubit<AuthGateState> {
  final AuthStateGetter _getAuthState;
  AuthGateCubit(this._getAuthState) : super(const Right(None())) {
    refresh();
  }

  Future<void> refresh() => _getAuthState().then(
        (stateEither) => emit(stateEither.fold(
          (exception) => Left(exception),
          (authState) => Right(Some(authState)),
        )),
      );
}

typedef AuthGateCubitFactory = AuthGateCubit Function();

AuthGateCubitFactory newAuthGateCubitFactory(AuthStateGetter getAuthState) => () => AuthGateCubit(getAuthState);
