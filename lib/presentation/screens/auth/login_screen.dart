// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '/new_code/auth/auth_gate_cubit.dart';
import '/presentation/colors.dart';
import '/presentation/screens/auth/choose_enter_screen.dart';
import '/presentation/screens/auth/forgot_password_screen.dart';
import '/presentation/widgets/email_field.dart';
import '/presentation/widgets/email_field_login.dart';
import '/presentation/widgets/green_button.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  final bool fromLogout;
  final http.Client? client;

  LoginScreen({
    Key? key,
    this.client,
    this.fromLogout = false,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => AuthBloc(() => BlocProvider.of<AuthGateCubit>(context).refresh()),
        dispose: (_, AuthBloc bloc) => bloc.dispose(),
        child: Builder(
          builder: (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                elevation: 0.0,
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding:const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: ListView(
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                     const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Вход".tr(),
                          style:const TextStyle(
                              fontSize: 24,
                              //fontFamily: "GloryMedium",
                              fontWeight: FontWeight.w700, color: sharkColor),
                        ),
                      ),
                     const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Пожалуйста, введите свои данные".tr(),
                          textAlign: TextAlign.center,
                          style:const TextStyle(fontSize: 16,
                              //fontFamily: "GloryMedium",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      EmailFieldLogin(controller: emailController),
                     const SizedBox(
                        height: 26,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Пароль".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400,
                              //fontFamily: "GloryMedium",
                              color:  Colors.grey),
                        ),
                      ),
                     const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.start,
                          obscureText: true,
                          enableSuggestions: false,
                          controller: passwordController,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'Введите пароль',
                              hintStyle:const TextStyle(color: Colors.grey,fontSize:16,fontWeight: FontWeight.w400),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: SvgPicture.asset('assets/images/ic_check_text_field.svg'),
                              ),
                              contentPadding:const EdgeInsets.all(12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:const BorderSide(
                                  color: silverGrayColor,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:const BorderSide(
                                  color: silverGrayColor,
                                  width: 1.5,
                                ),
                              )),
                        ),
                      ),

                     const SizedBox(
                        height: 24,
                      ),
                      BlueButton(
                        onPressed: () {
                          context.read<AuthBloc>().login(emailController.text, passwordController.text);
                        },
                        textButton: "Войти".tr(),
                      ),
                    const  SizedBox(
                        height: 26,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text("Забыли пароль?".tr(),
                            textAlign: TextAlign.center,
                            style:const TextStyle(
                              //decoration: TextDecoration.underline,
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w400,
                                //fontFamily: 'GloryMedium',
                                fontSize: 14)),
                      ),
                      const StateContentWidget(),
                      SizedBox(height: MediaQuery.of(context).size.height/3.5),
                      GestureDetector(
                        onTap: () {
                          widget.fromLogout == true
                              ? Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => ChooseEnterScreen(),
                              ),
                                  (route) => false)
                              : Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //Center Row contents horizontally,
                          children: <Widget>[
                            Text("Нет аккаунта?".tr(),
                                style:const TextStyle(color: grayColor,fontWeight: FontWeight.w400,
                                    //fontFamily: 'GloryRegular',
                                    fontSize: 13)),
                            const SizedBox(
                              width: 4,
                            ),
                            Padding(
                              padding:const EdgeInsets.only(top: 4.0),
                              child: Text("Зарегистрироваться".tr(),
                                  style:const TextStyle(
                                    //decoration: TextDecoration.underline,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w400,
                                      //fontFamily: 'GloryMedium',
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              )),
        ));
  }
}

class StateContentWidget extends StatelessWidget {
 const StateContentWidget({Key? key}) : super(key: key);

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc bloc = Provider.of<AuthBloc>(context, listen: false);
    return StreamBuilder<AuthState>(
        stream: bloc.observeAuthState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }
          final AuthState state = snapshot.data!;
          switch (state) {
            case AuthState.loading:
              return LoadingIndicator();
            case AuthState.loadingError:
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      bloc.errorMessage,
                      style: TextStyle(color: Colors.redAccent),
                    )
                  ],
                ),
              );
            case AuthState.loginScreen:
              return SizedBox();
            case AuthState.loginSuccess:
              return Container();
          }
        });
  }
}
