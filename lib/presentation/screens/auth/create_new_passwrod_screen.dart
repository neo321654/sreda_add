import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '/new_code/auth/auth_gate_cubit.dart';
import '/presentation/bloc/auth/create_new_passwrod_screen_bloc.dart';
import '/presentation/colors.dart';
import '/presentation/widgets/custom_dialog_box.dart';
import '/presentation/widgets/green_button.dart';

import '../../../new_code/common/app_bar.dart';
import '../../widgets/loading.dart';

class CreateNewPasswordScreen extends StatefulWidget {
 const CreateNewPasswordScreen({Key? key, required this.email, required this.token}) : super(key: key);
  final String email;
  final String token;

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  var repeatPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();

  late CreateNewPasswordScreenBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CreateNewPasswordScreenBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: CustomAppBar( "Создать пароль".tr(),),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  SizedBox(
                    height: 30,
                  ),
                  SvgPicture.asset("assets/images/ic_create_new_password_screen_logo.svg"),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Ваш новый пароль должен отличаться от ранее использованного пароля".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16,
                            //fontFamily: "GloryMedium",
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Новый пароль".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500,
                            //fontFamily: "GloryMedium",
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      obscureText: true,
                      enableSuggestions: false,
                      controller: newPasswordController,
                      autocorrect: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: silverGrayColor,
                              width: 1.5,
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
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Подтвердить пароль".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500,
                            //fontFamily: "GloryMedium",
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      obscureText: true,
                      enableSuggestions: false,
                      controller: repeatPasswordController,
                      autocorrect: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:const BorderSide(
                              color: silverGrayColor,
                              width: 1.5,
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
                  StateContentWidget(newPasswordController.text, repeatPasswordController.text),
                  Flexible(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 15.0, bottom: 65.0),
                        child: BlueButton(
                            onPressed: () {
                              createNewPassword(widget.email, widget.token, newPasswordController.text,
                                  repeatPasswordController.text);
                            },
                            textButton: "Сохранить пароль".tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createNewPassword(String email, String token, String password, String repeatPassword) {
    if (password.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Ошибка ввода".tr(),
              descriptions: "Заполните поле Пароль".tr(),
              text: "Ok",
            );
          });
    } else if (repeatPassword.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Ошибка ввода".tr(),
              descriptions: "Заполните поле Повторить пароль".tr(),
              text: "Ok",
            );
          });
    } else if (password != repeatPassword) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Ошибка ввода".tr(),
              descriptions: "Пароли не равны".tr(),
              text: "Ok",
            );
          });
    } else {
      bloc.createNewPassword(email, token, password, repeatPassword);
    }
  }
}

class StateContentWidget extends StatelessWidget {
  StateContentWidget(this.password, this.repeatPassword, {Key? key}) : super(key: key);
  final String password;
  final String repeatPassword;

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CreateNewPasswordScreenBloc bloc = Provider.of<CreateNewPasswordScreenBloc>(context, listen: false);
    return StreamBuilder<CreateNewPasswordScreenState>(
        stream: bloc.observeState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }
          final CreateNewPasswordScreenState state = snapshot.data!;
          switch (state) {
            case CreateNewPasswordScreenState.loading:
              return LoadingIndicator();
            case CreateNewPasswordScreenState.createNewPasswordError:
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16, left: 16),
                    child: Text(
                      bloc.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                ],
              );
            case CreateNewPasswordScreenState.createNewPasswordScreen:
              return SizedBox();
            case CreateNewPasswordScreenState.createNewPasswordSuccess:
              context.read<AuthGateCubit>().refresh();
              return Container();
          }
        });
  }
}
