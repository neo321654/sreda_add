import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/new_code/common/app_bar.dart';
import '/new_code/common/profile_image.dart';
import '/presentation/bloc/profile/profile_model_screen_bloc.dart';
import '/presentation/bloc/profile/profile_model_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/profile/edit_profile_screnn.dart';
import '/presentation/screens/review/review_screen.dart';

import '../../widgets/loading.dart';

class ShowProfileHirerScreen extends StatefulWidget {
  final int profileId;
  final bool isEdit;
  final bool isSelf;

  ShowProfileHirerScreen({Key? key, required this.profileId, required this.isEdit, required this.isSelf})
      : super(key: key);

  @override
  State<ShowProfileHirerScreen> createState() => _ShowProfileHirerScreenState();
}

class _ShowProfileHirerScreenState extends State<ShowProfileHirerScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ProfileModelScreenBloc _bloc;

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
        iconTheme:const IconThemeData(color: grey),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        centerTitle: true,
        leadingWidth: 68,
        title:  Text(
          "Профиль компании".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21,
              //fontFamily: "GloryMedium",
              fontWeight: FontWeight.w600,
              color: blackPearlColor),
        ),
        actions: [
    BlocBuilder<ProfileModelScreenBloc, ProfileModelScreenState>(
    bloc: _bloc,
    builder: (context, state) {
      if (state is ProfileLoadedState){
        return  Visibility(
          visible: widget.isEdit,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    id: state.profileEntity.id!,
                    isModel: false,
                    phone: state.profileEntity.phone,
                    about: state.profileEntity.about,
                    age: state.profileEntity.age.toString(),
                    city: state.profileEntity.city,
                    name: state.profileEntity.name,
                    facebook: state.profileEntity.facebook,
                    instagram: state.profileEntity.instagram,
                    linkedin: state.profileEntity.linkedin,
                    site: state.profileEntity.website,
                    photos: state.profileEntity.profilePhotos,
                  ),
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
      }else{
       return Container();
      }

    })

        ],
      ),
      body: BlocBuilder<ProfileModelScreenBloc, ProfileModelScreenState>(
        bloc: _bloc,
        builder: (context, state) {

          if (state is ProfileLoadingState) {
            return LoadingIndicator();
          } else if (state is ProfileLoadedState) {
            return SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: ProfileImage(profile: state.profileEntity, size: 145),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          state.profileEntity.name.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'GloryRegular',
                            color: Color(0xFF2B2B2B),
                            fontSize: 28,
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
                                        isSelf: widget.isEdit,
                                        userId: state.profileEntity.userId!)),
                              )
                            },
                            child: Text(
                              'Нет отзывов'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                               // fontFamily: 'GloryRegular',
                                color: grey,
                                fontSize: 16,
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
                                    color: grey,
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
                                   // fontFamily: 'GloryMedium',
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
                          height: MediaQuery.of(context).size.height * 0.615,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 18, right: 20, top: 12, bottom: 14),
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "О компании:".tr(),
                                          style: TextStyle(
                                              //fontFamily: 'GloryItalic',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            state.profileEntity.about.toString(),
                                            style:
                                                TextStyle(
                                                   // fontFamily: 'GloryRegular',
                                                    fontSize: 16, color: grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 18, right: 20, top: 12, bottom: 14),
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Способы связи:".tr(),
                                          style: TextStyle(
                                              //fontFamily: 'GloryItalic',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Column(
                                          children: [
                                            Visibility(
                                                visible: state.profileEntity.facebook?.isNotEmpty ?? false,
                                                child: ButtonSocial(
                                                    icon: "assets/images/ic_facebook_profile_hirer.svg",
                                                    textButton: state.profileEntity.instagram.toString())),
                                            Visibility(
                                                visible: state.profileEntity.instagram?.isNotEmpty ?? false,
                                                child: ButtonSocial(
                                                    icon: "assets/images/ic_instagram_profile_hirer.svg",
                                                    textButton: state.profileEntity.instagram.toString())),
                                            Visibility(
                                                visible: state.profileEntity.linkedin?.isNotEmpty ?? false,
                                                child: ButtonSocial(
                                                    icon: "assets/images/ic_linkedin_profile_hirer.svg",
                                                    textButton: state.profileEntity.linkedin.toString())),
                                            Visibility(
                                                visible: state.profileEntity.website?.isNotEmpty ?? false,
                                                child: ButtonSocial(
                                                    icon: "assets/images/ic_web_profile_hirer.svg",
                                                    textButton: state.profileEntity.website.toString())),
                                            Visibility(
                                                visible: state.profileEntity.phone?.isNotEmpty ?? false,
                                                child: ButtonSocial(
                                                    icon: "assets/images/ic_phone_profile_hirer.svg",
                                                    textButton: state.profileEntity.phone.toString())),
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
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class ButtonSocial extends StatelessWidget {
  final VoidCallback? onTap;
  final String? textButton;
  final String icon;

  ButtonSocial({
    this.onTap,
    this.textButton,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: borderGreyColor,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        icon,
                        width: 22,
                        height: 22,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        textButton ?? 'Применить'.tr(),
                        style: TextStyle(
                          color: grey,
                          fontSize: 14.0,
                         // fontFamily: 'GloryRegular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
