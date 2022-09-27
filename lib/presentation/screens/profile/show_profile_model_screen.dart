// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/data/api/constants.dart';
import '/domain/model/profile/profile_entity.dart';
import '/new_code/common/profile_image.dart';
import '/new_code/contacts/ui/contacts_dialog.dart';
import '/presentation/bloc/profile/profile_model_screen_bloc.dart';
import '/presentation/bloc/profile/profile_model_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/review/review_screen.dart';

import 'edit_profile_model_screen.dart';

class ShowProfileModelScreen extends StatefulWidget {
  final int profileId;
  final bool isEdit;
  final bool isSelf;

  ShowProfileModelScreen({Key? key, required this.profileId, required this.isEdit, required this.isSelf})
      : super(key: key);

  @override
  State<ShowProfileModelScreen> createState() => _ShowProfileModelScreenState();
}

class _ShowProfileModelScreenState extends State<ShowProfileModelScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ProfileModelScreenBloc _bloc;

  void onContactsPressed(ProfileEntity profile) {
    if (profile.userId != null) {
      showContactsDialog(context, profile.userId!);
    }
  }

  @override
  void initState() {
    _bloc = ProfileModelScreenBloc();
    if (widget.isEdit) {
      _bloc.getProfileSelf();
    } else {
      _bloc.getProfile(widget.profileId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: grey),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        centerTitle: true,
        leadingWidth: 68,
        title: Text(
          "Профиль".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 21,
              // fontFamily: "GloryMedium",
              fontWeight: FontWeight.w600,
              color: blackPearlColor),
        ),
        actions: [
          BlocBuilder<ProfileModelScreenBloc, ProfileModelScreenState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is ProfileLoadedState) {
                  return Visibility(
                    visible: widget.isEdit,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditModelScreen(profileEntity: state.profileEntity),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SvgPicture.asset(
                          "assets/images/icons_profile/ic_edit.svg",
                          width: 21.0,
                          height: 21.0,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              })
        ],
      ),
      body: BlocBuilder<ProfileModelScreenBloc, ProfileModelScreenState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: vikingColor,
                strokeWidth: 4,
              ),
            );
          } else if (state is ProfileLoadedState) {
            return SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ProfileImage(
                                  profile: state.profileEntity,
                                  size: 145,
                                ),
                              ),
                              Visibility(
                                visible: widget.isEdit,
                                child: Positioned.fill(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 1.5),
                                    child: SvgPicture.asset(
                                      'assets/images/ic_photo.svg',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        state.profileEntity.name.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //fontFamily: 'GloryRegular',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B2B2B),
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: state.profileEntity.feedbackCount == 0,
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewScreen(
                                      isEdit: widget.isEdit,
                                      isSelf: widget.isSelf,
                                      userId: state.profileEntity.userId!)),
                            )
                          },
                          child: Text(
                            'Нет отзывов'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //fontFamily: 'GloryRegular',
                              color: Color(0xFF2B2B2B),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: state.profileEntity.feedbackCount! > 0,
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewScreen(
                                        isEdit: widget.isEdit,
                                        isSelf: widget.isSelf,
                                        userId: state.profileEntity.userId!,
                                      )),
                            )
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Отзывы:'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  //fontFamily: 'GloryMedium',
                                  color: Color(0xFF2B2B2B),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                state.profileEntity.feedbackCount.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  //fontFamily: 'GloryMedium',
                                  fontWeight: FontWeight.w700,
                                  color: vikingColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => onContactsPressed(state.profileEntity),
                            child: SvgPicture.asset(
                              'assets/images/ic_instagram_show_profile.svg',
                              width: 38,
                              height: 38,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onContactsPressed(state.profileEntity),
                            child: SvgPicture.asset(
                              'assets/images/ic_phone_show_profile.svg',
                              width: 38,
                              height: 38,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onContactsPressed(state.profileEntity),
                            child: SvgPicture.asset(
                              'assets/images/ic_mail_show_profile.svg',
                              width: 38,
                              height: 38,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              _bloc.setFavorite(
                                isFavorite: state.profileEntity.isFavorite!,
                                modelId: state.profileEntity.id!,
                              )
                            },
                            child: SvgPicture.asset(
                              getIconFavorite(state.profileEntity.isFavorite!),
                              width: 38,
                              height: 38,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor: Colors.black,
                                unselectedLabelColor: grayColor,
                                labelStyle: TextStyle(
                                  //fontFamily: 'GloryItalic',
                                  fontSize: 16,
                                ),
                                indicatorColor: vikingColor,
                                tabs: [
                                  Tab(
                                    text: 'Фото'.tr(),
                                  ),
                                  Tab(
                                    text: 'Данные'.tr(),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    TabPhoto(
                                      profileEntity: state.profileEntity,
                                    ),
                                    InfoTab(
                                      profileEntity: state.profileEntity,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator(
              color: vikingColor,
              strokeWidth: 4,
            );
          }
        },
      ),
    );
  }

  String getIconFavorite(bool isFavorite) {
    if (isFavorite) {
      return "assets/images/icons_profile/ic_favorite_true.svg";
    } else {
      return "assets/images/icons_profile/ic_favorite_false.svg";
    }
  }
}

String getLinkPhoto(ProfileEntity? model) {
  try {
    if (model!.photo != null && model.photo!.isNotEmpty) {
      if (!model.photo!.contains(ApiConstants.TO_REPLACE_LINK)) {
        return ApiConstants.BASE_URL_IMAGE + model.photo!;
      } else {
        return model.photo!;
      }
    } else {
      if (model.profilePhotos!.isEmpty || model.profilePhotos == null) {
        return "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
      } else {
        return ApiConstants.BASE_URL_IMAGE + "/media/" + model.profilePhotos![0].replaceAll(ApiConstants.TO_REPLACE_LINK_WHITH_HTTP, "");
      }
    }
  } on Exception catch (_) {
    return "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
  }
}

getProfileLinkPhoto(String? link) {
  if (link != null && link.isNotEmpty) {
    if (!link.contains(ApiConstants.TO_REPLACE_LINK)) {
      return ApiConstants.BASE_URL_IMAGE + '/media/' + link;
    } else {
      return link;
    }
  }
}

class InfoTab extends StatelessWidget {
  final ProfileEntity profileEntity;

  InfoTab({
    required this.profileEntity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.only(left: 18, right: 20, top: 12, bottom: 14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Город:".tr(),
                          style: TextStyle(
                              //fontFamily: 'GloryRegular',
                              fontSize: 16,
                              color: lightText)),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(profileEntity.city!,
                            style: TextStyle(
                                //fontFamily: 'GloryRegular',
                                fontSize: 16,
                                color: lightText)),
                      ),
                    ],
                  )),
              padding: EdgeInsets.only(top: 20)),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 210,
              padding: EdgeInsets.only(left: 18, right: 20, top: 12, bottom: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: LineWidgetInfo(title: 'Рост:'.tr(), description: '${profileEntity.growth} cm'),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LineWidgetInfo(
                        title: 'Грудь-Талия-Бедра:'.tr(),
                        description: '${profileEntity.bust} ${profileEntity.waist} ${profileEntity.hips}'),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LineWidgetInfo(title: 'Размер обуви:'.tr(), description: profileEntity.shoesSize.toString()),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child:
                        LineWidgetInfo(title: 'Размер одежды:'.tr(), description: profileEntity.closeSize.toString()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 290,
              padding: EdgeInsets.only(left: 18, right: 20, top: 12, bottom: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: LineWidgetInfo(title: 'Тип внешности:'.tr(), description: '${profileEntity.lookType}'),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LineWidgetInfo(
                        title: 'Цвет кожи:'.tr(),
                        description: '${profileEntity.bust} ${profileEntity.waist} ${profileEntity.skinColor}'),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LineWidgetInfo(title: 'Цвет волос:'.tr(), description: profileEntity.hairColor.toString()),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LineWidgetInfo(title: 'Длина волос:'.tr(), description: profileEntity.hairLength.toString()),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LineWidgetInfo(
                        title: 'Загранпаспорт:'.tr(),
                        description: profileEntity.isHaveInternationalPassport! ? 'Имеется'.tr() : 'Нет'.tr()),
                  ),
                  Divider(color: Color(0xffc9c9c9)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LineWidgetInfo(
                      title: 'Татуировки/пирсинг:'.tr(),
                      description: profileEntity.isHaveTattoo! ? 'Да'.tr() : 'Нет'.tr(),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.only(left: 18, right: 20, top: 12, bottom: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Знание языков:".tr(),
                      style: TextStyle(
                          // fontFamily: 'GloryRegular',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: lightText),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        profileEntity.isHaveEnglish! ? "Русский язык, Английский язык".tr() : "Русский язык".tr(),
                        style: TextStyle(
                            //fontFamily: 'GloryRegular',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 120,
              padding: EdgeInsets.only(left: 18, right: 20, top: 12, bottom: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Опыт работы:".tr(),
                      style: TextStyle(
                          // fontFamily: 'GloryItalic',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: lightText),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        profileEntity.about.toString(),
                        style: TextStyle(
                            //fontFamily: 'GloryRegular',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineWidgetInfo extends StatelessWidget {
  final String title;
  final String description;

  LineWidgetInfo({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              //fontFamily: 'GloryRegular',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: lightText),
        ),
        Text(
          description,
          style: TextStyle(
            //fontFamily: 'GloryRegular',
            fontWeight: FontWeight.w300,
            color: grey,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}

class TabPhoto extends StatelessWidget {
  final ProfileEntity profileEntity;

  TabPhoto({
    required this.profileEntity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.custom(
          gridDelegate: SliverWovenGridDelegate.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            pattern: [
              WovenGridTile(
                0.91,
                alignment: AlignmentDirectional.bottomStart,
              ),
              WovenGridTile(1),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
                padding: index == 0 ? const EdgeInsets.only(top: 10) : const EdgeInsets.only(top: 0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      imageUrl: ApiConstants.BASE_URL_IMAGE +
                          ('/media/' + (profileEntity.profilePhotos?[index].toString() ?? '')),
                      fit: BoxFit.cover,
                    )));
          }, childCount: (profileEntity.profilePhotos?.length) ?? 0),
        ));
  }
}
