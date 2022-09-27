import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/new_code/auth/services.dart';

import 'auth_gate_cubit.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthGateCubit, AuthGateState>(
      child: _SplashScreen(),
      listener: (context, state) => state.fold(
        (exception) => Text(exception.toString()), // TODO: proper error handling
        (stateEither) => stateEither.fold(
          () {},
          (authState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              authState == AuthState.authenticated ? "main/" : "signin/",
              (route) => route.isFirst,
            );
          },
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset("assets/images/ic_logo.png", width: 250, height: 100),
    ));
  }
}
