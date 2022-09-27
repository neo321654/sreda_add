import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/data/api/constants.dart';
import '/domain/model/profile/profile_entity.dart';
import '/new_code/common/app_bar.dart';
import '/presentation/bloc/profile/profile_model_screen_bloc.dart';
import '/presentation/bloc/profile/profile_model_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';
import '/presentation/screens/registration/registration_employer_screen.dart';
import '/presentation/screens/search/search_city_screen.dart';
import '/presentation/widgets/base_text_field.dart';
import '/presentation/widgets/submit_button.dart';

import '../../widgets/custom_dialog_box.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isModel;
  final int id;
  final String? phone;
  final String? name;
  final String? age;
  final String? about;
  final String? city;
  final String? facebook;
  final String? instagram;
  final String? linkedin;
  final String? site;
  final List<String>? photos;

  EditProfileScreen({
    Key? key,
    required this.isModel,
    required this.id,
    this.phone,
    this.name,
    this.age,
    this.about,
    this.city,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.site,
    this.photos,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    // для проверки приходят ли фотки
    super.initState();
  }

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var cityController = TextEditingController();
  var facebookController = TextEditingController();
  var instagramController = TextEditingController();
  var linkedinController = TextEditingController();
  var siteController = TextEditingController();
  var aboutController = TextEditingController();
  var city = "";
  final List<String> customMask = [
    '+7 (000) 000-00-00', //Россия / Казахстан
    '(00) 000-00-00', // Беларусь
  ];
  late MaskedTextController phoneController = MaskedTextController(mask: customMask.first);

  @override
  Widget build(BuildContext context) {
    return HirerWidget(
      phone: widget.phone,
      about: widget.about,
      age: widget.age.toString(),
      city: widget.city,
      name: widget.name,
      facebook: widget.facebook,
      instagram: widget.instagram,
      linkedin: widget.linkedin,
      site: widget.site,
      photos: widget.photos,
      id: widget.id,
    );
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

class HirerWidget extends StatefulWidget {
  final String? phone;
  final int id;
  final String? name;
  final String? age;
  final String? about;
  final String? city;
  final String? facebook;
  final String? instagram;
  final String? linkedin;
  final String? site;
  final List<String>? photos;

  HirerWidget({
    Key? key,
    this.phone,
    required this.id,
    this.name,
    this.age,
    this.about,
    this.city,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.site,
    this.photos,
  }) : super(key: key);

  @override
  State<HirerWidget> createState() => _HirerWidgetState();
}

class InnerList {
  final String name;
  List<String> children;
  InnerList({required this.name, required this.children});
}

class _HirerWidgetState extends State<HirerWidget> {
  late ProfileModelScreenBloc bloc;
  List<dynamic> photoList = [];
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var cityController = TextEditingController();
  var facebookController = TextEditingController();
  var instagramController = TextEditingController();
  var linkedinController = TextEditingController();
  var siteController = TextEditingController();
  var aboutController = TextEditingController();
  var city = "";
  final List<String> customMask = [
    '+7 (000) 000-00-00', //Россия / Казахстан
    '(00) 000-00-00', // Беларусь
  ];
  late MaskedTextController phoneController = MaskedTextController(mask: customMask.first);

  @override
  void initState() {
    photoList = widget.photos!;
    bloc = ProfileModelScreenBloc();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    phoneController.text = widget.phone ?? "";
    ageController.text = widget.age ?? "";
    cityController.text = widget.city ?? "";
    city = widget.city ?? "";
    aboutController.text = widget.about ?? "";
    nameController.text = widget.name ?? "";
    facebookController.text = widget.facebook ?? "";
    instagramController.text = widget.instagram ?? "";
    siteController.text = widget.site ?? "";
    linkedinController.text = widget.linkedin ?? "";
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar("Редактирование"),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BaseTextField(
                          controller: nameController,
                          title: "Имя, Фамилия".tr(),
                          hintText: "Имя".tr(),
                          inputType: TextInputType.text,
                          isVisibleTitle: true,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BaseTextField(
                            controller: ageController,
                            title: "Возраст".tr(),
                            hintText: "23",
                            inputType: TextInputType.number,
                            isVisibleTitle: true,
                            textAlign: TextAlign.start),

                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0,top: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Город".tr(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                       // fontFamily: "GloryMedium",
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
                                    color: silverGrayColor,
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

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text("Способы связи:".tr(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              //fontFamily: "GloryMedium",
                              color: grey)),
                    ),
                        SocialInfoWidget(
                            controller: facebookController,
                            hintText: "www.facebook.com",
                            imagePath: "assets/images/ic_facebook_profile_hirer.svg"),
                        SocialInfoWidget(
                            controller: instagramController,
                            hintText: "www.instagran.com",
                            imagePath: "assets/images/ic_instagram_profile_hirer.svg"),
                        SocialInfoWidget(
                            controller: linkedinController,
                            hintText: "www.linkedin.com",
                            imagePath: "assets/images/ic_linkedin_profile_hirer.svg"),
                        SocialInfoWidget(
                            controller: siteController,
                            hintText: "www.yourwebsite.com",
                            imagePath: "assets/images/ic_web_profile_hirer.svg"),
                        SocialInfoWidget(
                            controller: phoneController,
                            hintText: "+X YY YYY XX XX",
                            imagePath: "assets/images/ic_phone_profile_hirer.svg"),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "О себе:".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                               // fontFamily: "GloryMedium",
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
                              hintText: "О себе".tr(),
                              contentPadding: EdgeInsets.all(15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: borderGreyColor,
                                  width:0.5,
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
                        Text(
                          "Фото:".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              //fontFamily: "GloryMedium",
                              color: grey),
                        ),
                        Visibility(
                          visible: photoList.isNotEmpty,
                          child: SizedBox(
                            height: 110,
                            child: ReorderableListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: photoList.length,
                              onReorder: ((oldIndex, newIndex) {
                                setState(() {
                                  _updateMyItems(oldIndex, newIndex);
                                });
                              }),
                              itemBuilder: (context, index) {
                                return Padding(
                                  key: ValueKey(photoList[index]),
                                  padding: EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: photoList[index].contains('user_profile_photo/')
                                            ? Image.network(
                                                getProfileLinkPhoto(
                                                  photoList[index],
                                                ),
                                                width: 110,
                                                height: 110,
                                              )
                                            : Image.file(
                                                File(photoList[index]),
                                                width: 110,
                                                height: 110,
                                              ),
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: 4,
                                            top: 10,
                                          ),
                                          child: GestureDetector(
                                              onTap: () {
                                                photoList.removeAt(index);
                                                setState(() {
                                                  photoList;
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
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10),
                          color: vikingColor,
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
                        HttpResultWidget(),
                        SizedBox(
                          height: 15,
                        ),
                        SubmitButton(
                          textButton: 'Сохранить'.tr(),
                          onTap: () {
                            if (nameController.text.isEmpty) {
                              showDialogError("Заполните поле Имя".tr());
                            } else if (city.isEmpty) {
                              showDialogError("Заполните поле Город".tr());
                            } else if (aboutController.text.isEmpty) {
                              showDialogError("Заполните поле Город".tr());
                            } else if (phoneController.text.isEmpty) {
                              showDialogError("Заполните поле Номер телефона".tr());
                            } else if (photoList.isEmpty) {
                              showDialogError("Загрузите фото".tr());
                            } else {
                              int? age;
                              if (ageController.text.isNotEmpty) {
                                age = int.parse(ageController.text);
                              }
                              var body = ProfileEntity(
                                name: nameController.text,
                                age: age,
                                userType: "HIRER",
                                city: cityController.text,
                                phone: phoneController.text,
                                facebook: facebookController.text,
                                linkedin: linkedinController.text,
                                instagram: instagramController.text,
                                website: siteController.text,
                                about: aboutController.text,
                              );
                              bloc.updateProfileHirer(widget.id, body, photoList);
                            }
                          },
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
    );
  }

  void _updateMyItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = photoList.removeAt(oldIndex);
    photoList.insert(newIndex, item);
  }

  String getLinkPhoto(String link) {
    return (ApiConstants.BASE_URL_IMAGE + "/media/" + link.replaceAll(ApiConstants.TO_REPLACE_LINK_WHITH_HTTP, ""));
  }

  Future<void> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    var photo = await picker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    String photoPath = File(photo!.path).toString().substring(6).replaceAll("'", "");

    photoList.add(photoPath);
    setState(() {
      photoList;
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

class HttpResultWidget extends StatelessWidget {
  HttpResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileModelScreenBloc, ProfileModelScreenState>(
      listener: (context, state) {
        if (state is ProfileLoadedErrorState) {
          buildShowDialog(context, state.message!.toString());
        } else if (state is UpdateProfileHirerLoadedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return LoadingIndicator();
        } else if (state is ProfileLoadedState) {
          return Container();
        } else {
          return Container();
        }
      },
    );
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
}
