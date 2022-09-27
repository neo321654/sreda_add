import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '/presentation/bloc/create_post/create_post_bloc.dart';
import '/presentation/bloc/create_post/create_post_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/search/search_city_screen.dart';
import '/presentation/widgets/base_text_field.dart';
import '/presentation/widgets/custom_dialog_box.dart';
import '/presentation/widgets/segmented_control.dart';
import '/presentation/widgets/submit_button.dart';

import '../../../new_code/common/app_bar.dart';
import '../../widgets/loading.dart';
import '../../widgets/segmented_control.dart';
import '../filters/filter_screen_widgets.dart' as w;

class AnnouncementScreen extends StatefulWidget {
  AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  List<CategoryCard> items = [
    CategoryCard(title: 'Фотограф'.tr(), isSelected: false),
    CategoryCard(title: 'Модель'.tr(), isSelected: false),
    CategoryCard(title: 'Другое'.tr(), isSelected: false),
  ];
  int _selectedCategoryIndex = 0;
  bool showItems = false;
  String hasTattoo = 'Нет/Нет';
  bool hasInternPassword = false;
  String hasInternPass='Нет';
  int gender = 0;
  List<File> photo = [];
  var city = "Moscow";
  var category = "";
  final List<String> _cTattoo=['Да/Да','Нет/Нет','Да/Нет','Нет/Да'];
  final List<String> _cInternPassword=['Имеется','Нет'];
  var selectedTime=DateFormat("HH:mm").format(DateTime.now());
  var selectedDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
  final TextEditingController titleController = TextEditingController();
  final dateController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController ageFromController = TextEditingController();
  final TextEditingController ageToController = TextEditingController();
  final TextEditingController heightFromController = TextEditingController();
  final TextEditingController heightToController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostBloc>(
      create: (context) => CreatePostBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar('Создание объявления'.tr()),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BaseTextField(
                    controller: titleController,
                    title: "Название объявления:".tr(),
                    hintText: "Введите название",
                    inputType: TextInputType.text,
                    isVisibleTitle: true,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Дата".tr(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      //fontFamily: "GloryMedium",
                                      color: grey)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async => {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(currentDate.year, currentDate.month, currentDate.day),
                                  maxTime: DateTime(currentDate.year + 1, currentDate.month, currentDate.day),
                                  onConfirm: (date) {
                                setState(() {
                                  selectedDate = DateFormat("dd.MM.yyyy").format(date);
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.ru)
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
                                  Text(selectedDate),
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
                                  child: Text("Время".tr(),
                                      style:const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          //fontFamily: "GloryMedium",
                                          color: grey)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async => {
                                  DatePicker.showTimePicker(context,
                                      showTitleActions: true,
                                      // minTime: DateTime(currentDate.year, currentDate.month, currentDate.day),
                                      // maxTime: DateTime(currentDate.year + 1, currentDate.month, currentDate.day),
                                      onConfirm: (time) {
                                        setState(() {
                                          selectedTime = DateFormat("HH:mm").format(time);
                                        });
                                      }, currentTime: DateTime.now(), locale: LocaleType.ru)
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
                                      Text(selectedTime),
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
                  SizedBox(height: 20),
                  Row(

                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.4,
                        child: BaseTextField(
                          controller: budgetController,
                          title: "Бюджет:".tr(),
                          hintText: "\$",
                          inputType: TextInputType.number,
                          isVisibleTitle: true,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: true,
                              onChanged: ( value) {
                                setState(() {

                                });
                              },
                            ),
                            const Text('TFP',style: TextStyle(
                              fontSize: 15
                            ),)
                          ],
                        ),
                      )

                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Город".tr(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          //fontFamily: "GloryMedium",
                          color: grey)),
                  SizedBox(
                    height: 10,
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
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffffffff),
                        border: Border.all(
                          color: silverGrayColor,
                          width: 1.0,
                        ),
                      ),
                      child: city.isEmpty?const Text('Введите ваш город',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                        color: grey,
                        fontSize: 16
                      ),):Text(city),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                                        File(photo[index].path),
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
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius:const Radius.circular(12),
                    color: vikingColor,
                    strokeWidth: 1,
                    child: GestureDetector(
                      onTap: () async {
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
                            style:const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                //fontFamily: "GloryMedium",
                                color: mineShaft2GrayColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.0),
                  SegmentedControl(
                    selectedIndex: 0,
                    title: 'Пол исполнителя'.tr(),
                    items: [
                      'Женщины'.tr(),
                      'Мужчины'.tr(),
                      'Все'.tr(),
                    ],
                    valueIndex: (int) {
                      gender = int;
                    },
                  ),
                  Visibility(
                    visible: true,
                    child: Column(
                      children: [
                        SizedBox(height: 18.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: BaseTextField(
                                    controller: ageFromController,
                                    title: "Возраст".tr(),
                                    hintText: "От".tr(),
                                    inputType: TextInputType.number,
                                    isVisibleTitle: true,
                                    textAlign: TextAlign.start)),
                            SizedBox(width: 10),
                            Expanded(
                                child: BaseTextField(
                                    controller: ageToController,
                                    title: "",
                                    hintText: "До".tr(),
                                    inputType: TextInputType.number,
                                    isVisibleTitle: true,
                                    textAlign: TextAlign.start))
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: BaseTextField(
                                controller: heightFromController,
                                title: "Рост".tr(),
                                hintText: "От".tr(),
                                inputType: TextInputType.number,
                                isVisibleTitle: true,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: BaseTextField(
                                controller: heightToController,
                                title: "",
                                hintText: "До".tr(),
                                inputType: TextInputType.number,
                                isVisibleTitle: true,
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 17),
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
                                                //fontFamily: "GloryMedium",
                                                color: grey)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async => {
                                       showCupertinoModalPopup(context: context, builder: (_){
                                         return  Container(
                                           width: double.infinity,
                                           height: 150,
                                           child: CupertinoPicker(
                                               backgroundColor: Colors.white,
                                        onSelectedItemChanged: (int value) {
                                            setState(() {
                                              hasTattoo=_cTattoo[value];
                                            });
                                         },
                                      itemExtent: 30,
                                      children: [
                                      Text('${_cTattoo[0]}'),
                                      Text('${_cTattoo[1]}'),
                                      Text('${_cTattoo[2]}'),
                                      Text('${_cTattoo[3]}')
                                      ]),
                                         );
                                       })

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
                                        showCupertinoModalPopup(context: context, builder: (_){
                                          return  Container(
                                            width: double.infinity,
                                            height: 150,
                                            child: CupertinoPicker(
                                                backgroundColor: Colors.white,
                                                onSelectedItemChanged: (int value) {
                                                  setState(() {
                                                    if(_cInternPassword[value]=='Нет'){
                                                      hasInternPassword=false;

                                                    }else{
                                                      hasInternPassword=true;
                                                    }

                                                    hasInternPass=_cInternPassword[value];
                                                  });
                                                },
                                                itemExtent: 30,
                                                children: [
                                                  Text('${_cInternPassword[0]}'),
                                                  Text('${_cInternPassword[1]}'),

                                                ]),
                                          );
                                        })
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





                      ],
                    ),
                  ),
                  SizedBox(height: 18.0),
                  Text(
                    'Другие детали'.tr(),
                    style: TextStyle(
                      //fontFamily: 'GloryRegular',
                      fontSize: 14.0,
                      color: grey,
                      height: 18.0 / 16.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    maxLines: null,
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "",
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
                            width: 0.5,
                          ),
                        )),
                  ),
                  SizedBox(height: 20.0),

                  SegmentedControl(
                    selectedIndex:  _selectedCategoryIndex?? 0,
                    title: 'Категория'.tr(),
                    items: [
                      'Фотограф'.tr(),
                      'Модель'.tr(),
                      'Другое'.tr(),
                    ],
                    valueIndex: (int) {
                      setState(() {
                        _selectedCategoryIndex = int;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  HttpResultWidget(),
                  ButtonWidget(
                    title: titleController.text.toString(),
                    date: selectedDate,
                    city: city,
                    description: descriptionController.text.toString(),
                    photos: photo,
                    category: _selectedCategoryIndex,
                    ageTo: ageToController.text.toString(),
                    ageFrom: ageFromController.text.toString(),
                    heightTo: heightToController.text.toString(),
                    heightFrom: heightFromController.text.toString(),
                    hasTattoo: hasTattoo,
                    hasInternPassword: hasInternPassword,
                    budget: budgetController.text.toString(),
                    gender: gender,
                  ),
                  SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
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
}

class HttpResultWidget extends StatelessWidget {
  HttpResultWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostLocalErrorState) {
          buildShowDialog(context, state.message!.toString());
        } else if (state is CreatePostErrorState) {
          buildShowDialog(context, state.message!.toString());
        } else if (state is CreatePostSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is CreatePostInitial) {
          return Text('');
        } else if (state is CreatePostLoading) {
          return LoadingIndicator();
        } else {
          return Text('');
        }
      },
    );
  }
}

class ButtonWidget extends StatelessWidget {
  String title;
  String date;
  String city;
  int gender;
  int category;
  String description;
  String ageFrom;
  String ageTo;
  String heightTo;
  String heightFrom;
  String hasTattoo;
  bool hasInternPassword;
  String budget;
  List<File> photos;

  ButtonWidget(
      {Key? key,
      required this.title,
      required this.date,
      required this.city,
      required this.gender,
      required this.category,
      required this.description,
      required this.ageFrom,
      required this.ageTo,
      required this.heightTo,
      required this.heightFrom,
      required this.hasTattoo,
      required this.hasInternPassword,
      required this.budget,
      required this.photos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubmitButton(
      textButton: 'Опубликовать',
      onTap: () {
        if (title.isEmpty) {
          buildShowDialog(context, "Заполните название".tr());
        } else if (date.isEmpty) {
          buildShowDialog(context, "Заполните дату".tr());
        } else if (city.isEmpty) {
          buildShowDialog(context, "Заполните город".tr());
        } else if (description.isEmpty) {
          buildShowDialog(context, "Заполните описание".tr());
        } else if (photos.isEmpty) {
          buildShowDialog(context, "Загрузите фотографии".tr());
        } else if (budget.isEmpty) {
          buildShowDialog(context, "Заполните бюджет".tr());
        } else if (category == 1 && ageFrom.isEmpty || ageTo.isEmpty) {
          buildShowDialog(context, "Заполните возраст".tr());
        } else if (category == 1 && heightFrom.isEmpty || heightTo.isEmpty) {
          buildShowDialog(context, "Заполните рост".tr());
        } else {
          context.read<CreatePostBloc>().createPost(
                title: title,
                date: date,
                city: city,
                gender: gender,
                photos: photos,
                ageFrom: ageFrom,
                ageTo: ageTo,
                heightTo: heightTo,
                heightFrom: heightFrom,
                hasTattoo: hasTattoo,
                hasInternPassword: hasInternPassword,
                budget: budget,
                description: description,
                category: getCategory(category),
              );
        }
      },
    );
  }

  String getCategory(int category) {
    if (category == 0) {
      return 'PHOTOGRAPHER';
    } else if (category == 1) {
      return 'MODEL';
    } else {
      return 'OTHER';
    }
  }
}

Future<dynamic> buildShowDialog(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Ошибка ввода".tr(),
          descriptions: message,
          text: "Ok",
        );
      });
}

class SelectCardItem extends StatefulWidget {
  final bool isSelected;
  final String title;
  final String subTitle;
  final VoidCallback? onTap;

  SelectCardItem({
    Key? key,
    this.onTap,
    required this.isSelected,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  State<SelectCardItem> createState() => _SelectCardItemState();
}

class _SelectCardItemState extends State<SelectCardItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500,
                //fontFamily: "GloryMedium",
                color: mineShaft2GrayColor),
          ),
          SizedBox(height: 9),
          InkWell(
            borderRadius: BorderRadius.circular(7.0),
            onTap: widget.onTap,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: widget.isSelected ? Color(0xff6CC9E0) : Colors.white,
                border: widget.isSelected ? null : Border.all(color: Color(0xffBBBBBB)),
              ),
              child: Center(
                child: FittedBox(
                  child: Text(
                    widget.subTitle,
                    style: TextStyle(
                      color: widget.isSelected ? Colors.white : Color(0xff2B2B2B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard {
  String title;
  bool isSelected;

  CategoryCard({
    required this.title,
    required this.isSelected,
  });
}
