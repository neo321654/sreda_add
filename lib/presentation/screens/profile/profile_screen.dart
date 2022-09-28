import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/constants.dart';
import '/domain/model/profile/profile_entity.dart';
import '/new_code/localization/language_select_item.dart';
import '/new_code/tariffs/ui/tariffs_page.dart';
import '/presentation/bloc/profile/profile_model_screen_bloc.dart';
import '/presentation/bloc/profile/profile_model_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/announcement/announcement_screen.dart';
import '/presentation/screens/profile/show_profile_hirer_screen.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';
import '/presentation/screens/profile/widget/profile_card.dart';
import '/presentation/screens/registration/registration_employer_screen.dart';
import '/presentation/widgets/submit_button.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var isTurnOnNotification = false;
  late ProfileModelScreenBloc _bloc;
  var userType = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserType();
    });
    _bloc = ProfileModelScreenBloc();
    _bloc.getProfileSelf();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _bloc,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: primaryBackgroundColor,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.0,
          title: Text(
            'Настройки'.tr(),
            style: TextStyle(
              //fontFamily: 'GloryMedium',
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: blackPearlColor,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  BlocBuilder<ProfileModelScreenBloc, ProfileModelScreenState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is ProfileLoadingState) {
                        return LoadingIndicator();
                      } else if (state is ProfileLoadedState) {
                        return ProfileCard(
                          profile: state.profileEntity,
                          phone: state.profileEntity.phone,
                          withLogout: true,
                        );
                      }
                      return Text(state.toString()); // TODO: handle this
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (userType == 'MODEL') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowProfileModelScreen(
                                    profileId: 0,
                                    isEdit: true,
                                    isSelf: true,
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowProfileHirerScreen(
                                    profileId: 0,
                                    isEdit: true,
                                    isSelf: true,
                                  )),
                        );
                      }
                    },
                    child: ItemProfileMenu(
                      iconPath: "assets/images/icons_profile/ic_data.svg",
                      title: "Данные".tr(),
                      isDivider: true,
                      leftPadding: 25,
                      rightPadding: 25,
                      width: 5,
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  LanguageSelectItem(),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/icons_profile/ic_notifi.svg", width: 20, height: 20),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Уведомление".tr(),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: CupertinoSwitch(
                              value: isTurnOnNotification,
                              onChanged: (value) {
                                setState(() {
                                  isTurnOnNotification = value;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => TariffsPage()));
                    },
                    child: ItemProfileMenu(
                      iconPath: "assets/images/icons_profile/ic_price.svg",
                      title: "Тарифы".tr(),
                      isDivider: true,
                      leftPadding: 20,
                      rightPadding: 25,
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // await launchUrlString('mailto:Sredamodels@gmail.com');
                    },
                    child: ItemProfileMenu(
                      iconPath: "assets/images/icons_profile/ic_mail.svg",
                      title: "Поддержка".tr(),
                      isDivider: false,
                      leftPadding: 22,
                      rightPadding: 25,
                      width: 1,
                    ),
                  ),


                  Visibility(
                    visible: userType == 'HIRER',
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 70),
                      child: SubmitButton(
                        textButton: 'Создать объявление'.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AnnouncementScreen()),
                          );
                        },
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

  String getLinkPhoto(ProfileEntity model) {
    try {
      if (model.photo != null && model.photo!.isNotEmpty) {
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

  void _getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userType = preferences.getString("TYPE") ?? "";
  }
}

class ItemProfileMenu extends StatelessWidget {
  ItemProfileMenu(
      {Key? key,
        this.width=0,
      required this.iconPath,
      required this.title,
      required this.isDivider,
      required this.leftPadding,
      required this.rightPadding})
      : super(key: key);
  final String iconPath;
  final String title;
  final bool isDivider;
  final double leftPadding;
  final double rightPadding;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, width: 20, height: 20),
              SizedBox(width: width),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    title,
                    style: TextStyle(
                      //fontFamily: 'GloryMedium',
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SvgPicture.asset("assets/images/ic_arrow_right.svg", width: 6, height: 12)
            ],
          ),

        ],
      ),
    );
  }
}
