// ignore_for_file: prefer_const_constructors, unnecessary_const, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/new_code/di.dart';
import '/presentation/bloc/auth/new_code/welcome_screen_cubit.dart';
import '/presentation/colors.dart';
import '/presentation/screens/auth/login_screen.dart';
import '/presentation/screens/registration/registration_employer_screen.dart';
import '/presentation/screens/registration/registration_model_screen.dart';
import '/presentation/widgets/email_field.dart';
import '/presentation/widgets/green_button.dart';

import '../../../new_code/auth/auth_gate_cubit.dart';
import '../../../new_code/common/flutter_helpers.dart';
import '../../widgets/custom_dialog_box.dart';

class WelcomeScreen extends StatefulWidget {
  final http.Client? client;
  final String text;

  WelcomeScreen({Key? key, this.client, required this.text}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var isAgree = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void pushNextRegistration(BuildContext context) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final page = sharedPrefs.getString("TYPE") == "MODEL"
        ? RegistrationModelScreen()
        : RegistrationEmployerScreen();
    pushPage(context, page);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeScreenCubit(
        uiDeps.signInWithGoogle,
        uiDeps.signInWithApple,
        () => BlocProvider.of<AuthGateCubit>(context).refresh(),
      ),
      child: BlocConsumer<WelcomeScreenCubit, WelcomeScreenState>(
        listener: (context, state) async => state is WelcomeScreenSuccess
            ? pushNextRegistration(context)
            : null,
        builder: (context, state) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              elevation: 0.0,
              toolbarHeight: 0),
          body: Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Регистрация".tr(),
                    style: TextStyle(
                        fontSize: 24,
                        //fontFamily: "GloryMedium",
                        fontWeight: FontWeight.w700,
                        color: sharkColor),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Пожалуйста, войдите или зарегистрируйтесь, чтобы продолжить "
                        .tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        // fontFamily: "GloryMedium",
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ),
                EmailField(controller: emailController),
                SizedBox(
                  height: 26,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Пароль".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        //fontFamily: "GloryMedium",
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 45,
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    obscureText: true,
                    enableSuggestions: false,
                    controller: passwordController,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: 'Введите пароль',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        contentPadding: EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: silverGrayColor,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: silverGrayColor,
                            width: 1.5,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: vikingColor,
                  title: Text(
                      "Создавая учетную запись, вы должны согласиться с условиями использования"
                          .tr(),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          //fontFamily: "GloryMedium",
                          color: silverChaliceColor)),
                  value: isAgree,
                  onChanged: (newValue) {
                    setState(() {
                      isAgree = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                SizedBox(
                  height: 24,
                ),
                BlueButton(
                  onPressed: () {
                    runRegistration(context);
                  },
                  textButton: "Зарегистрироваться".tr(),
                ),
                _HttpResultWidget(state: state),
                SizedBox(
                  height: 28,
                ),
                SvgPicture.asset("assets/images/or_line.svg"),
                SizedBox(
                  height: 28,
                ),
                // (Platform.isAndroid)
                //     ? SizedBox(
                //         width:
                //             MediaQuery.of(context).size.width, // <-- Your width
                //         height: 45, // <-- Your height
                //         child: ElevatedButton.icon(
                //           icon: IconButton(
                //             icon:
                //                 SvgPicture.asset("assets/images/ic_google.svg"),
                //             onPressed: () {},
                //           ),
                //           onPressed: () => context
                //               .read<WelcomeScreenCubit>()
                //               .socialSignInPressed(SocialProvider.google),
                //           style: ElevatedButton.styleFrom(
                //               shape: RoundedRectangleBorder(
                //                 borderRadius:
                //                     BorderRadius.circular(10), // <-- Radius
                //               ),
                //               primary: Colors.black),
                //           label: Text("Войти через Google".tr(),
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   //fontFamily: 'GloryRegular',
                //                   fontWeight: FontWeight.w500,
                //                   fontSize: 17)),
                //         ),
                //       )
                //     : SignInWithAppleButton(
                //         onPressed: () => context
                //             .read<WelcomeScreenCubit>()
                //             .socialSignInPressed(SocialProvider.apple),
                //       ),
                SizedBox(
                  height: 46,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 78),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("У вас уже есть аккаунт?".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: grayColor,
                                fontWeight: FontWeight.w400,
                                //fontFamily: 'GloryRegular',
                                fontSize: 13)),
                        SizedBox(
                          width: 4,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text("Авторизируйтесь".tr(),
                              style: TextStyle(
                                  //decoration: TextDecoration.underline,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.w400,
                                  //fontFamily: 'GloryMedium',
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void runRegistration(BuildContext context) {
    if (emailController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Ошибка валидации".tr(),
              descriptions: "Заполните поле Email".tr(),
              text: "Ok",
            );
          });
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Ошибка валидации".tr(),
              descriptions: "Неверный формат Email".tr(),
              text: "Ok",
            );
          });
    } else if (passwordController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Ошибка валидации".tr(),
              descriptions: "Заполните поле Пароль".tr(),
              text: "Ok",
            );
          });
    } else if (!isAgree) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Ошибка валидации".tr(),
              descriptions:
                  "Создавая учетную запись, вы должны согласиться с условиями использования"
                      .tr(),
              text: "Ok",
            );
          });
    } else {
      context
          .read<WelcomeScreenCubit>()
          .registration(emailController.text, passwordController.text);
    }
  }
}

class _HttpResultWidget extends StatelessWidget {
  final WelcomeScreenState state;

  _HttpResultWidget({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is WelcomeScreenLoading) {
      return _LoadingIndicator();
    } else if (state is WelcomeScreenError) {
      final message = (state as WelcomeScreenError).errorMessage;
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          message,
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

class _LoadingIndicator extends StatelessWidget {
  _LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: CircularProgressIndicator(
          color: vikingColor,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
