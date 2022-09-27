import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/new_code/auth/auth_gate_cubit.dart';
import '/new_code/common/app_bar.dart';
import '/new_code/di.dart';
import '/presentation/bloc/auth/registration_employer_bloc.dart';
import '/presentation/colors.dart';
import '/presentation/screens/search/search_city_screen.dart';

import '../../models/RequestProfileModel.dart';
import '../../widgets/base_text_field.dart';
import '../../widgets/custom_dialog_box.dart';
import '../../widgets/submit_button.dart';

class RegistrationEmployerScreen extends StatefulWidget {
  RegistrationEmployerScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationEmployerScreen> createState() => _RegistrationEmployerScreenState();
}

class _RegistrationEmployerScreenState extends State<RegistrationEmployerScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<File> photos = [];
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var cityController = TextEditingController();
  var facebookController = TextEditingController();
  var instagramController = TextEditingController();
  var linkedinController = TextEditingController();
  var siteController = TextEditingController();
  var aboutController = TextEditingController();
  var city = "Moscow";
  final List<String> customMask = [
    '+7 (000) 000-00-00', //Россия / Казахстан
    '(00) 000-00-00', // Беларусь
  ];
  late MaskedTextController phoneController = MaskedTextController(mask: customMask.first);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) =>
          RegistrationEmployerBloc(uiDeps.dio, () => BlocProvider.of<AuthGateCubit>(context).refresh()),
      dispose: (_, RegistrationEmployerBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) => Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(""),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(-0.25, -0.15),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                child: Text(
                                  'Профиль'.tr(),
                                  textAlign: TextAlign.center,
                                  style:const TextStyle(
                                    //fontFamily: 'GloryMedium',
                                    color: Color(0xFF062226),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        children: <Widget>[
                          BaseTextField(
                              controller: nameController,
                              title: "Имя, Фамилия:".tr(),
                              hintText: "Имя".tr(),
                              inputType: TextInputType.text,
                              isVisibleTitle: true,
                              textAlign: TextAlign.center),
                         const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: BaseTextField(
                                      controller: ageController,
                                      title: "Возраст:".tr(),
                                      hintText: "23",
                                      inputType: TextInputType.number,
                                      isVisibleTitle: true,
                                      textAlign: TextAlign.center)),
                             const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding:const EdgeInsets.only(bottom: 8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Город:".tr(),
                                          style:const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                             // fontFamily: "GloryMedium",
                                              color: mineShaft2GrayColor)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async => {
                                      city = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SearchPage()),
                                      ),
                                      setState(() {
                                        city;
                                      })
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                          color: silverGrayColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(city),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                          SocialInfoWidget(
                              controller: facebookController,
                              hintText: "www.facebook.com",
                              imagePath: "assets/images/ic_facebook_employer.svg"),
                          SocialInfoWidget(
                              controller: instagramController,
                              hintText: "www.instagran.com",
                              imagePath: "assets/images/ic_instagram_employer.svg"),
                          SocialInfoWidget(
                              controller: linkedinController,
                              hintText: "www.linkedin.com",
                              imagePath: "assets/images/ic_linkedin_employer.svg"),
                          SocialInfoWidget(
                              controller: siteController,
                              hintText: "www.yourwebsite.com",
                              imagePath: "assets/images/ic_website_employer.svg"),
                          SocialInfoWidget(
                              controller: phoneController,
                              hintText: "+X YY YYY XX XX",
                              imagePath: "assets/images/ic_phone_employer.svg"),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "О себе".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  //fontFamily: "GloryMedium",
                                  color: mineShaft2GrayColor),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            maxLines: null,
                            controller: aboutController,
                            keyboardType: TextInputType.multiline,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "О себе".tr(),
                                contentPadding: EdgeInsets.all(15),
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
                          SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: photos.isNotEmpty,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: photos.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Image.file(
                                                    File(photos[index].path),
                                                    width: 110,
                                                    height: 110,
                                                  ),
                                                ),
                                                Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: 4, top: 10),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            photos.removeAt(index);
                                                            setState(() {
                                                              photos;
                                                            });
                                                          },
                                                          child: Icon(Icons.close)),
                                                    ))
                                              ],
                                            ));
                                      }),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          DottedBorder(
                            color: vikingColor,
                            radius: Radius.circular(10),
                            strokeWidth: 1,
                            child: GestureDetector(
                              onTap: () {
                                _getImageFromGallery();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0x1A1B877E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "+ Загрузите фото".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        //fontFamily: "GloryMedium",
                                        color: mineShaft2GrayColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SubmitButton(
                            onTap: () {
                              if (nameController.text.isEmpty) {
                                showDialogError("Заполните поле Имя".tr());
                              } else if (city.isEmpty) {
                                showDialogError("Заполните поле Город".tr());
                              } else if (aboutController.text.isEmpty) {
                                showDialogError("Заполните поле Город".tr());
                              } else if (phoneController.text.isEmpty) {
                                showDialogError("Заполните поле Номер телефона".tr());
                              } else if (photos.isEmpty) {
                                showDialogError("Загрузите фотографии".tr());
                              } else {
                                int? age;
                                if (ageController.text.isNotEmpty) {
                                  age = int.parse(ageController.text);
                                }
                                var body = RequestProfileModel(
                                  name: nameController.text,
                                  age: age,
                                  userType: "HIRER",
                                  city: cityController.text,
                                  phone: phoneController.text,
                                  instagram: instagramController.text,
                                  website: siteController.text,
                                  about: aboutController.text,
                                );
                                context.read<RegistrationEmployerBloc>().registration(body, photos);
                              }
                            },
                          ),
                          _HttpResultWidget()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    var photo = await picker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    photos.add(File(photo!.path));
    setState(() {
      photos;
    });
  }

  void showDialogError(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Ошибка валидации".tr(),
            descriptions: text,
            text: "Ok",
          );
        });
  }
}

class _HttpResultWidget extends StatelessWidget {
  _HttpResultWidget({Key? key}) : super(key: key);
  late RegistrationEmployerBloc bloc;

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RegistrationEmployerBloc>(context, listen: false);
    return StreamBuilder<RegistrationEmployerScreenState>(
        stream: bloc.observeRegistrationState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }
          final RegistrationEmployerScreenState state = snapshot.data!;
          switch (state) {
            case RegistrationEmployerScreenState.loading:
              return LoadingIndicator();
            case RegistrationEmployerScreenState.justScreen:
              return Container();
            case RegistrationEmployerScreenState.registrationSuccess:
              return Container();
            case RegistrationEmployerScreenState.registrationError:
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    bloc.errorMessage,
                    style: TextStyle(color: Colors.redAccent),
                  )
                ],
              );
          }
        });
  }
}

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({
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

class SocialInfoWidget extends StatelessWidget {
  SocialInfoWidget({Key? key, required this.controller, required this.hintText, required this.imagePath})
      : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 10),
      Row(
        children: [
          Flexible(flex: 1, child: Container(
            alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10,bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderGreyColor)
              ),
              child: SvgPicture.asset(imagePath))),
          SizedBox(width: 10),
          Flexible(
              flex: 5,
              child: BaseTextField(
                  controller: controller,
                  title: "Город:".tr(),
                  hintText: hintText,
                  inputType: TextInputType.text,
                  isVisibleTitle: false,
                  textAlign: TextAlign.start))
        ],
      ),
    ]);
  }
}
