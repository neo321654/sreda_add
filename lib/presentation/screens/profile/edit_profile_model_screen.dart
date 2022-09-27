import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/new_code/auth/auth_gate_cubit.dart';
import '/new_code/common/app_bar.dart';
import '/new_code/di.dart';
import '/presentation/bloc/auth/registration_model_bloc.dart';
import '/presentation/colors.dart';
import '/presentation/models/RequestProfileModel.dart';
import '/presentation/widgets/base_text_field.dart';
import '/presentation/widgets/custom_dialog_box.dart';
import '/presentation/widgets/submit_button.dart';

import '../../../domain/model/profile/profile_entity.dart';
import '../../widgets/segmented_control.dart';
import '../search/search_city_screen.dart';

class EditModelScreen extends StatefulWidget {
 final ProfileEntity profileEntity;

  EditModelScreen({Key? key,
    required this.profileEntity}) : super(key: key);

  @override
  State<EditModelScreen> createState() => _EditModelScreenState();
}

class _EditModelScreenState extends State<EditModelScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var isPassport = false;
  var isTattoo = false;
  var isEnglish = false;
  var isModelType = true;
  var gender = 0;
  var typeModel = 0;
  var city = "";

  final List<String> showAppearanceTypeItems = [
    "европейская".tr(),
    "африканская".tr(),
    "мулат".tr(),
    "кавказская".tr(),
    "азиатская".tr(),
    "индийская".tr(),
    "испанская".tr(),
    "другая".tr()
  ];
  var appearanceType = '';

  final List<String> skinTypeItems = ["бледный".tr(), "светлый".tr(), "смуглый".tr(), "темный".tr(), "другой".tr()];
  var skinType = '';
  final List<String> _cTattooList=['Да/Да','Нет/Нет','Да/Нет','Нет/Да'];
  final List<String> _cInternPasswordList=['Имеется','Нет'];
  final List<String> _cLenguageList=['Русский язык', 'Русский язык, Английский язык'];
  final List<String> hairColorItems = [
    "белокурые".tr(),
    "русые".tr(),
    "каштановые".tr(),
    "брюнет".tr(),
    "черные".tr(),
    "рыжие".tr(),
    "другие".tr()
  ];
  var hairColor = '';

  final List<String> hairLengthItems = [
    "очень длинные".tr(),
    "длинные".tr(),
    "средние".tr(),
    "короткие".tr(),
    "без волос".tr()
  ];
  final List<String> sizeClothesList = [
    "42".tr(),
    "46".tr(),
    "48".tr(),
    "50".tr(),
    "52".tr(),
    "54".tr(),
    "56".tr(),
    "58".tr(),
    "60".tr()
  ];
  final List<String> sizeShoesList = [
    "38".tr(),
    "39".tr(),
    "40".tr(),
    "41".tr(),
    "42".tr(),
    "43".tr(),
    "44".tr(),
    "45".tr(),
    "46".tr(),
    '47'.tr()
  ];
  var hairLength = '';
  var textLenguage = '';
  List<File?> photo = [];
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var cityController = TextEditingController();
  var facebookController = TextEditingController();
  var instagramController = TextEditingController();
  var linkedinController = TextEditingController();
  var siteController = TextEditingController();
  var sizeGrowthController = TextEditingController();
  var sizeBustController = TextEditingController();
  var sizeWaistController = TextEditingController();
  var sizeHipsController = TextEditingController();
  var aboutController = TextEditingController();
  var languageController = TextEditingController();
  String sizeClothes='';
  String sizeShoes='';
  String hasTattoo = 'Нет/Нет';
  String hasInternPass='Нет';
  final List<String> customMask = [
    '+7 (000) 000-00-00', //Россия / Казахстан
    '(00) 000-00-00', // Беларусь
  ];
  late MaskedTextController phoneController = MaskedTextController(mask: customMask.first);

  @override
  void initState() {
    super.initState();
    widget.profileEntity.name!=null?nameController.text=widget.profileEntity.name!:'';
    widget.profileEntity.age!=null?ageController.text=widget.profileEntity.age!.toString():'';
    widget.profileEntity.city!=null?city=widget.profileEntity.city!:'';
    widget.profileEntity.phone!=null?phoneController.text=widget.profileEntity.phone!.toString():'';
    widget.profileEntity.instagram!=null?instagramController.text=widget.profileEntity.instagram!.toString():'';
    widget.profileEntity.website!=null?siteController.text=widget.profileEntity.website!.toString():'';
    isModelType=widget.profileEntity.userType=='MODEL';
    sizeClothes=widget.profileEntity.closeSize==null?sizeClothesList[0]:widget.profileEntity.closeSize!.toString();
    sizeShoes=widget.profileEntity.shoesSize==null?sizeShoesList[0]:widget.profileEntity.shoesSize!.toString();
    widget.profileEntity.growth!=null?sizeGrowthController.text=widget.profileEntity.growth!.toString():'';
    widget.profileEntity.bust!=null?sizeBustController.text=widget.profileEntity.bust!.toString():'';
    widget.profileEntity.waist!=null?sizeWaistController.text=widget.profileEntity.waist!.toString():'';
    widget.profileEntity.hips!=null?sizeHipsController.text=widget.profileEntity.hips!.toString():'';
    widget.profileEntity.lookType!=null?appearanceType= widget.profileEntity.lookType!.toString():appearanceType="Выбрать".tr();
    widget.profileEntity.skinColor!=null?skinType= widget.profileEntity.skinColor!.toString():skinType="Выбрать".tr();
    widget.profileEntity.hairColor!=null?hairColor= widget.profileEntity.hairColor!.toString():hairColor="Выбрать".tr();
    widget.profileEntity.hairLength!=null?hairLength= widget.profileEntity.hairLength!.toString():hairLength="Выбрать".tr();
    widget.profileEntity.about!=null?aboutController.text=widget.profileEntity.about!:aboutController.text='';
    if(widget.profileEntity.isHaveEnglish!=null){
      widget.profileEntity.isHaveEnglish! ?textLenguage= "Русский язык, Английский язык".tr() :textLenguage= "Русский язык".tr();
      isEnglish=widget.profileEntity.isHaveEnglish!;
      languageController.text=textLenguage;
    }

    if(widget.profileEntity.isHaveInternationalPassport!=null){
      widget.profileEntity.isHaveInternationalPassport! ? hasInternPass="Имеется".tr() : hasInternPass="Нет".tr();
      isPassport=widget.profileEntity.isHaveInternationalPassport!;
    }
    if(widget.profileEntity.isHaveTattoo!=null){
      widget.profileEntity.isHaveTattoo! ?hasTattoo= "Да".tr() :hasTattoo= "Нет".tr();
      isTattoo=widget.profileEntity.isHaveTattoo!;
    }
    if(widget.profileEntity.profilePhotos!=null){
      //todo load network photo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => RegistrationModelBloc(uiDeps.dio, () => BlocProvider.of<AuthGateCubit>(context).refresh()),
      dispose: (_, RegistrationModelBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) => Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: CustomAppBar("Редактирование"),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25,bottom: 20),
                      child: Text(
                        'Личные данные'.tr(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          //fontFamily: 'GloryRegular',
                          color: Color(0xFF062226),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        children: <Widget>[

                          SegmentedControl(
                            selectedIndex: widget.profileEntity.gender!,
                            title: 'Пол:'.tr(),
                            items: [
                              'Девушка'.tr(),
                              'Мужчина'.tr(),
                            ],
                            valueIndex: (value) => {gender = value},
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          BaseTextField(
                              controller: nameController,
                              title: "Имя, Фамилия:".tr(),
                              hintText: "Имя".tr(),
                              inputType: TextInputType.text,
                              isVisibleTitle: true,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 15,
                          ),

                          BaseTextField(
                              controller: ageController,
                              title: "Возраст:".tr(),
                              hintText: "Введите ваш возраст".tr(),
                              inputType: TextInputType.number,
                              isVisibleTitle: true,
                              textAlign: TextAlign.start),
                          SizedBox(width: 10),
                          SizedBox(height: 20),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Город:".tr(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          //fontFamily: "GloryRegular",
                                          color: grey)),
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color(0xffffffff),
                                    border: Border.all(
                                      color: borderGreyColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(city),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Контактные данные'.tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'GloryRegular',
                                  color: Color(0xFF062226),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          BaseTextField(
                              controller: phoneController,
                              title: "Телефон для связи".tr(),
                              hintText: "Введите ваш номер телефона".tr(),
                              inputType: TextInputType.phone,
                              isVisibleTitle: true,
                              textAlign: TextAlign.start),
                          SizedBox(height: 20),
                          BaseTextField(
                              controller: instagramController,
                              title: "Instagram".tr(),
                              hintText: "Ссылка на ваш Instagram",
                              inputType: TextInputType.text,
                              isVisibleTitle: true,
                              textAlign: TextAlign.start),
                          SizedBox(height: 20),
                          BaseTextField(
                              controller: siteController,
                              title: "Сайт".tr(),
                              hintText: "Ссылка на ваш сайт".tr(),
                              inputType: TextInputType.text,
                              isVisibleTitle: true,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Информация для работы'.tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  //fontFamily: 'GloryRegular',
                                  color: Color(0xFF062226),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SegmentedControl(
                            selectedIndex: isModelType?0:1,
                            title: 'Тип работы:'.tr(),
                            items: [
                              'Модель'.tr(),
                              'Фотограф'.tr(),
                              'Другое'.tr(),
                            ],
                            onPressed: (value) => {},
                            valueIndex: (int) {
                              if (int == 0) {
                                isModelType = true;
                              } else {
                                isModelType = false;
                              }
                              typeModel = int;
                              setState(() {
                                isModelType;
                              });
                            },
                          ),
                          Visibility(
                            visible: isModelType,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text("Размер одежды".tr(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                   // fontFamily: "GloryMedium",
                                                    color: grey)),
                                          ),
                                        ),
                                        GestureDetector(
                            onTap: () async => {
                              _showSizeClothesDialog()

                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffffffff),
                                border: Border.all(
                                  color: silverGrayColor,
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(sizeClothes),
                                  RotatedBox(quarterTurns: 135,
                                      child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),

                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                              EdgeInsets.only(bottom: 10.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Размер обуви".tr(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        //fontFamily: "GloryMedium",
                                                        color: grey)),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async => {
                                                _showSizeShoesDialog()

                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  color: Color(0xffffffff),
                                                  border: Border.all(
                                                    color: silverGrayColor,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(sizeShoes),
                                                    RotatedBox(quarterTurns: 135,
                                                        child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: BaseTextField(
                                            controller: sizeGrowthController,
                                            title: "Рост".tr(),
                                            hintText: "171",
                                            inputType: TextInputType.number,
                                            isVisibleTitle: true,
                                            textAlign: TextAlign.start)),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: BaseTextField(
                                            controller: sizeBustController,
                                            title: "Грудь:".tr(),
                                            hintText: "75",
                                            inputType: TextInputType.number,
                                            isVisibleTitle: true,
                                            textAlign: TextAlign.start))
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BaseTextField(
                                          controller: sizeWaistController,
                                          title: "Талия:".tr(),
                                          hintText: "23",
                                          inputType: TextInputType.number,
                                          isVisibleTitle: true,
                                          textAlign: TextAlign.start),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: BaseTextField(
                                            controller: sizeHipsController,
                                            title: "Бедра:".tr(),
                                            hintText: "75",
                                            inputType: TextInputType.number,
                                            isVisibleTitle: true,
                                            textAlign: TextAlign.start))
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Tип внешности".tr(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  //fontFamily: "GloryRegular",
                                                  color: grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showAppearanceTypeDialog();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: silverGrayColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(appearanceType),
                                                  RotatedBox(quarterTurns: 135,
                                                      child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Цвет кожи".tr(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  //fontFamily: "GloryRegular",
                                                  color: grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showSkinTypeDialog();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: silverGrayColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(skinType),
                                                  RotatedBox(quarterTurns: 135,
                                                      child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Цвет волос:".tr(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  //fontFamily: "GloryRegular",
                                                  color: grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showHairColorDialog();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: silverGrayColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(hairColor),
                                                  RotatedBox(quarterTurns: 135,
                                                      child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Длина волос:".tr(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  //fontFamily: "GloryRegular",
                                                  color: grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showHairLengthDialog();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: silverGrayColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(hairLength),
                                                  RotatedBox(quarterTurns: 135,
                                                      child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Татуировки / Пирсинг".tr(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                       // fontFamily: "GloryMedium",
                                                        color: grey)),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async => {
                                                _showTattooDialog()

                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  color: Color(0xffffffff),
                                                  border: Border.all(
                                                    color: silverGrayColor,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(hasTattoo),
                                                    RotatedBox(quarterTurns: 135,
                                                        child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Загранпаспорт".tr(),
                                                    style:const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        //fontFamily: "GloryMedium",
                                                        color: grey)),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async => {
                                                _showPassportDialog()
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  color: Color(0xffffffff),
                                                  border: Border.all(
                                                    color: silverGrayColor,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(hasInternPass),
                                                    RotatedBox(quarterTurns: 135,
                                                        child: Icon(Icons.arrow_back_ios,color: grey,size: 10,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Знание языков:".tr(),
                                            style:const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                //fontFamily: "GloryMedium",
                                                color: grey)),
                                      ),
                                    ),
                                    TextField(
                                      maxLines: null,
                                      controller: languageController,
                                      keyboardType: TextInputType.multiline,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                          hintText: "Введите язык".tr(),
                                          hintStyle: TextStyle(
                                            color: grey,
                                            fontSize: 14,
                                           // fontFamily: "GloryRegular",
                                          ),
                                          contentPadding: EdgeInsets.all(15),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "О себе".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  //fontFamily: "GloryRegular",
                                  color: grey),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            maxLines: null,
                            controller: aboutController,
                            keyboardType: TextInputType.multiline,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                                hintText: "Информация о вас".tr(),
                                hintStyle: TextStyle(
                                  color: grey,
                                  fontSize: 14,
                                 // fontFamily: "GloryRegular",
                                ),
                                contentPadding: EdgeInsets.all(15),
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
                          SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: photo.isNotEmpty,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: photo.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Image.file(
                                                    File(photo[index]!.path),
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
                                                            photo.removeAt(index);
                                                            setState(() {
                                                              photo;
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Фото:".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  //fontFamily: "GloryRegular",
                                  color: grey),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DottedBorder(
                            borderType: BorderType.RRect,
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
                                       // fontFamily: "GloryMedium",
                                        color: mineShaft2GrayColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          HttpResultWidget(),
                          SizedBox(
                            height: 15,
                          ),
                          SubmitButton(
                            textButton: 'Сохранить'.tr(),
                            onTap: () {
                              updateProfileModelType();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
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

  void _showSkinTypeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 300,
            color: Colors.white,
            child: ListView.builder(
                itemCount: skinTypeItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(skinTypeItems[index]),
                    onTap: () {
                      setState(() {
                        skinType = skinTypeItems[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  Future<void> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    var result = await picker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    photo.add(File(result!.path));
    setState(() {
      photo;
    });
  }

  void _showAppearanceTypeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 500,
            color: Colors.white,
            child: ListView.builder(
                itemCount: showAppearanceTypeItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(showAppearanceTypeItems[index]),
                    onTap: () {
                      setState(() {
                        appearanceType = showAppearanceTypeItems[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  void _showSizeClothesDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 500,
            color: Colors.white,
            child: ListView.builder(
                itemCount: sizeClothesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(sizeClothesList[index]),
                    onTap: () {
                      setState(() {
                        sizeClothes = sizeClothesList[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  void _showLenguageDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 500,
            color: Colors.white,
            child: ListView.builder(
                itemCount: _cLenguageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_cLenguageList[index]),
                    onTap: () {
                      setState(() {
                        textLenguage = _cLenguageList[index];
                        if(textLenguage=='Английский язык'.tr()){
                          isEnglish=true;
                        }else{
                          isEnglish=false;
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  void _showTattooDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 500,
            color: Colors.white,
            child: ListView.builder(
                itemCount: _cTattooList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_cTattooList[index]),
                    onTap: () {
                      setState(() {
                        hasTattoo = _cTattooList[index];
                        if(hasTattoo.contains('Да'.tr())){
                          isTattoo=true;
                        }else{
                          isTattoo=false;
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  void _showPassportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 500,
            color: Colors.white,
            child: ListView.builder(
                itemCount: _cInternPasswordList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_cInternPasswordList[index]),
                    onTap: () {
                      setState(() {
                        hasInternPass = _cInternPasswordList[index];
                        if(hasInternPass=='Имеется'.tr()){
                          isPassport=true;
                        }else{
                          isPassport=false;
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  void _showSizeShoesDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 500,
            color: Colors.white,
            child: ListView.builder(
                itemCount: sizeShoesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(sizeShoesList[index]),
                    onTap: () {
                      setState(() {
                        sizeShoes = sizeShoesList[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  void _showHairColorDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 440,
            color: Colors.white,
            child: ListView.builder(
                itemCount: hairColorItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(hairColorItems[index]),
                    onTap: () {
                      setState(() {
                        hairColor = hairColorItems[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }

  void _showHairLengthDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: 300,
            color: Colors.white,
            child: ListView.builder(
                itemCount: hairLengthItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(hairLengthItems[index]),
                    onTap: () {
                      setState(() {
                        hairLength = hairLengthItems[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                }));
      },
    );
  }



  void updateProfileModelType() {
    try {
      if (nameController.text.isEmpty) {
        showDialogError("Заполните поле Имя".tr());
      } else if (ageController.text.isEmpty) {
        showDialogError("Заполните поле Возраст".tr());
      } else if (city.isEmpty) {
        showDialogError("Заполните поле Город".tr());
      } else if (phoneController.text.isEmpty) {
        showDialogError("Заполните поле Номер телефона".tr());
      } else if (sizeClothes.isEmpty) {
        showDialogError("Выберите Размер одежды".tr());
      } else if (sizeShoes.isEmpty) {
        showDialogError("Выберите поле Размер обуви".tr());
      } else if (sizeGrowthController.text.isEmpty) {
        showDialogError("Заполните поле Рост".tr());
      } else if (sizeWaistController.text.isEmpty) {
        showDialogError("Заполните поле Талия".tr());
      } else if (sizeHipsController.text.isEmpty) {
        showDialogError("Заполните поле Бедра".tr());
      } else if (aboutController.text.isEmpty) {
        showDialogError("Заполните поле О себе".tr());
      } else if (photo.isEmpty) {
        showDialogError("Загрузите фото".tr());
      } else {
        var body = RequestProfileModel(
          email: nameController.text,
          password: ageController.text,
          name: nameController.text,
          userType: "MODEL",
          gender: gender,
          workerType: typeModel,
          age: int.parse(ageController.text),
          city: city,
          phone: phoneController.text,
          instagram: instagramController.text,
          website: siteController.text,
          about: aboutController.text,
          closeSize: int.parse(sizeClothes),
          shoesSize: int.parse(sizeShoes),
          growth: int.parse(sizeGrowthController.text),
          bust: int.parse(sizeBustController.text),
          waist: int.parse(sizeWaistController.text),
          hips: int.parse(sizeHipsController.text),
          lookType: appearanceType,
          skinColor: skinType,
          hairColor: hairColor,
          hairLength: hairLength,
          isHaveInternationalPassport: isPassport,
          isHaveTattoo: isTattoo,
          //todo text
          isHaveEnglish: isEnglish,
        );
        context.read<RegistrationModelBloc>().registration(body, photo, 'MODEL');
      }
    } on Exception catch (e) {
      showDialogError("Ошибка".tr());
    }
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

class HttpResultWidget extends StatelessWidget {
  HttpResultWidget({Key? key}) : super(key: key);
  late RegistrationModelBloc bloc;

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RegistrationModelBloc>(context, listen: false);
    return StreamBuilder<RegistrationModelScreenState>(
        stream: bloc.observeRegistrationState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }
          final RegistrationModelScreenState state = snapshot.data!;
          switch (state) {
            case RegistrationModelScreenState.loading:
              return LoadingIndicator();
            case RegistrationModelScreenState.justScreen:
              return Container();
            case RegistrationModelScreenState.registrationSuccess:
              return Container();
            case RegistrationModelScreenState.registrationError:
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
