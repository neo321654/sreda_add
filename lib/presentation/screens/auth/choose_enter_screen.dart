import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/presentation/colors.dart';
import '/presentation/screens/auth/welcome_screen.dart';

class ChooseEnterScreen extends StatefulWidget {
  ChooseEnterScreen({Key? key}) : super(key: key);

  @override
  State<ChooseEnterScreen> createState() => _ChooseEnterScreenState();
}

class _ChooseEnterScreenState extends State<ChooseEnterScreen> {
  bool _onTap_1=false;
  bool _onTap_2=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SvgPicture.asset("assets/images/ic_logo_choose_screen.svg"),
             const SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Кто вы?".tr(),
                  style:
                     const TextStyle(fontSize: 24,
                         //fontFamily: "GloryMedium",
                         fontWeight: FontWeight.w600,
                         color: sharkColor),
                ),
              ),
             const SizedBox(
                height: 20,
              ),
             // const Align(
             //    alignment: Alignment.center,
             //    child: Padding(
             //      padding: EdgeInsets.only(left: 30.0, right: 30.0),
             //      child: Text(
             //        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ",
             //        textAlign: TextAlign.center,
             //        style: TextStyle(fontSize: 16, fontFamily: "GloryMedium", color: Colors.grey),
             //      ),
             //    ),
             //  ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _onTap_1=true;
                    Future.delayed(const Duration(seconds: 1));
                    setPrefs('MODEL');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen(text: '')));
                  });

                },
                child: Container(
                  height: 100,
                  margin:const EdgeInsets.only(left: 30, right: 30,top: 15),
                  padding:const EdgeInsets.only(left: 18, right: 20,top: 16),
                  decoration: BoxDecoration(
                      color: _onTap_1?vikingColor:Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1,
                      color: _onTap_1?vikingColor:white235)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, //
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Модель".tr(),
                              style: TextStyle(fontSize: 18,
                                  //fontFamily: "GloryMedium",
                                  fontWeight: FontWeight.w400,
                                  color: _onTap_1?Colors.white:Colors.black),
                            ),
                            Padding(
                              padding:const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Найти работу никогда не было так \nпросто".tr(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    //fontFamily: "GloryRegular",
                                    color: _onTap_1?Colors.white:grey),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _onTap_1?SvgPicture.asset("assets/images/ic_arrow_next_button_model.svg"):SvgPicture.asset("assets/images/ic_chevronNext.svg"),
                      ),
                    ],
                  ),
                ),
              ),
             const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () async{
                  setState(() {
                    _onTap_2=true;
                    Future.delayed(const Duration(seconds: 1));
                    setPrefs('HIRER');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen(text: '')));
                  });

                },
                child: Container(
                  height: 100,
                  alignment: Alignment.center,
                  margin:const EdgeInsets.only(left: 30, right: 30,bottom: 15),
                  padding:const EdgeInsets.only(left: 18, right: 20, top: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _onTap_2?vikingColor:Colors.white,
                      border: Border.all(width: 1,
                          color: _onTap_2?vikingColor:white235)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Работодатель".tr(),
                              style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  //fontFamily: "GloryMedium",
                                  color: _onTap_2?Colors.white:Colors.black),
                            ),
                            Padding(
                              padding:const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Найдите подходящую модель или \nфотографа".tr(),
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    //fontFamily: "GloryRegular",
                                    color: _onTap_2?Colors.white:grey),
                              ),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _onTap_2?SvgPicture.asset("assets/images/ic_arrow_next_button_model.svg"):SvgPicture.asset("assets/images/ic_chevronNext.svg"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setPrefs(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('TYPE', type);
  }
}
