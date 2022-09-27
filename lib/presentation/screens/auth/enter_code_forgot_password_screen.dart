import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
// import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '/presentation/bloc/auth/enter_code_forgot_password_screen_bloc.dart';
import '/presentation/screens/auth/create_new_passwrod_screen.dart';
import '/presentation/widgets/custom_dialog_box.dart';

import '../../../new_code/common/app_bar.dart';
import '../../colors.dart';
import '../../widgets/green_button.dart';
import '../../widgets/loading.dart';

class EnterCodeForgotPasswordScreen extends StatefulWidget {
  const EnterCodeForgotPasswordScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<EnterCodeForgotPasswordScreen> createState() => _EnterCodeForgotPasswordScreenState();
}

class _EnterCodeForgotPasswordScreenState extends State<EnterCodeForgotPasswordScreen> {
  var smsCodeController = TextEditingController();
  var currentText = "";
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  var email = "";

  late EnterCodeForgotPasswordScreenBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = EnterCodeForgotPasswordScreenBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    email = widget.email;
    return Provider.value(
        value: bloc,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar("Код подтверждения".tr()),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    SizedBox(
                      height: 50,
                    ),
                    SvgPicture.asset("assets/images/ic_enter_code_forgot_password.svg"),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Пожалуйста, введите 4-значный код, отправленный на".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16,
                              //fontFamily: "GloryMedium",
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.email,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16,
                              //fontFamily: "GloryMedium",
                              color: Colors.lightBlue),
                        ),
                      ),
                    ),
                   const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        textStyle: TextStyle(
                                fontSize: 24.0,
                            //fontFamily: "GloryMedium"
                          ),
                        keyboardType: TextInputType.number,
                        controller: smsCodeController,
                        pinTheme: PinTheme(
                          inactiveColor: mintTulipColor,
                          activeColor: vikingColor,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                        ), onChanged: (String value) {  },

                      ),
                    ),
                   const  SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Я не получил код.".tr(),
                          style: TextStyle(
                              //fontFamily: "GloryMedium",
                              fontSize: 16),
                        ),
                        Text(" Отправить код еще раз".tr(),
                            style: TextStyle(
                                //fontFamily: "GloryMedium",
                                fontSize: 16, color:  Colors.lightBlue)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CountdownTimer(
                      endTime: endTime,
                      widgetBuilder: (context, CurrentRemainingTime? time) {
                        if (time == null) {
                          return GestureDetector(
                            onTap: () {
                              bloc.sendRepeatCode(widget.email);
                            },
                            child: Text('Отправить еще раз'.tr(),
                                style: TextStyle(
                                    //fontFamily: "GloryMedium",
                                    fontSize: 16, color:  Colors.lightBlue)),
                          );
                        }
                        return Text('Осталось секунд'.tr(args: [time.sec.toString()]),
                            style: TextStyle(
                                //fontFamily: "GloryMedium",
                                fontSize: 16, color: Colors.lightBlue));
                      },
                    ),
                    StateContentWidget(widget.email),
                    Flexible(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30, left: 15.0, bottom: 65.0),
                          child: BlueButton(
                              onPressed: () {
                                if (smsCodeController.text.isEmpty || smsCodeController.text.length < 4) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: "Ошибка ввода".tr(),
                                          descriptions: "Введите правильный код".tr(),
                                          text: "Ok",
                                        );
                                      });
                                } else {
                                  bloc.sendEmailCode(email, smsCodeController.text);
                                }
                              },
                              textButton: "Подтвердить".tr()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class StateContentWidget extends StatefulWidget {
  StateContentWidget(this.email, {Key? key}) : super(key: key);
  final String email;

  @override
  State<StateContentWidget> createState() => _StateContentWidgetState();
}

class _StateContentWidgetState extends State<StateContentWidget> {
  @override
  Widget build(BuildContext context) {
    final EnterCodeForgotPasswordScreenBloc bloc =
        Provider.of<EnterCodeForgotPasswordScreenBloc>(context, listen: false);
    return StreamBuilder<EnterCodeForgotPasswordScreenState>(
        stream: bloc.observeAuthState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }
          final EnterCodeForgotPasswordScreenState state = snapshot.data!;
          switch (state) {
            case EnterCodeForgotPasswordScreenState.loading:
              return LoadingIndicator();
            case EnterCodeForgotPasswordScreenState.sendEmailCodeError:
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
            case EnterCodeForgotPasswordScreenState.sendEmailCodeScreen:
              return SizedBox();
            case EnterCodeForgotPasswordScreenState.sendEmailCodeSuccess:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateNewPasswordScreen(email: bloc.email, token: bloc.token)),
                );
              });
              return Container();
          }
        });
  }
}
