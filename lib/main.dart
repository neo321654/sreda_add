import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './di/post_di.dart';
import './new_code/auth/auth_gate_cubit.dart';
import './new_code/auth/auth_gate_screen.dart';
import './new_code/di.dart';
import './new_code/localization/localization.dart';
import './new_code/tariffs/ui/purchase_gate.dart';
import './presentation/screens/auth/choose_enter_screen.dart';
import './presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await EasyLocalization.ensureInitialized();
  await setupDi();
  await newDi();
  runApp(AppLocalization(app: MyApp()));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<AuthGateCubit>(
        create: (_) => uiDeps.authGateCubitFactory(),
        child: MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            "gates/": (_) => PurchaseGate(child: AuthGate()),
            "main/": (_) => MainScreen(),
            "signin/": (_) => ChooseEnterScreen(),
          },
          initialRoute: "gates/",
        ),
      );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
