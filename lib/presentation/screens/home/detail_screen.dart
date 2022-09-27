import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';

import '../../../new_code/common/app_bar.dart';
import '../../bloc/home/detail_post/detail_post_bloc.dart';
import '../../bloc/home/detail_post/detail_post_state.dart';
import '../../colors.dart';
import '../../widgets/loading.dart';
import 'gallery_screen.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String userType;

  DetailScreen({Key? key, required this.id, required this.userType}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late DetailPostBloc bloc;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _carouselIndex = 0;

  @override
  void initState() {
    super.initState();
    bloc = DetailPostBloc();
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
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: CustomAppBar("Детали работы".tr()),
        body: SafeArea(
          child: SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            child: BlocConsumer<DetailPostBloc, DetailPostState>(
              listener: (context, state) {
                if (state is ReplyLoadedErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message?.message ?? "Ошибка".tr())));
                }
                if (state is ReplySuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Вы успешно откликнулись".tr())));
                }
              },
              builder: (context, state) {
                if (state is DetailPostScreenInitial) {
                  context.read<DetailPostBloc>().getPostById(widget.id);
                  return SizedBox();
                } else if (state is DetailPostScreenError) {
                  return Center(child: Text("Что-то пошло не так".tr()));
                } else if (state is DetailPostScreenSuccess) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                          ),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowProfileModelScreen(
                                        profileId: state.data!.authorId, isEdit: false, isSelf: false)),
                              )
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: vikingColor,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(state.data!.authorAvatar),
                              ),
                            ),
                          ),
                         const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.data!.authorName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    //fontFamily: "GloryMedium",
                                  )),
                              Text("Автор".tr(),
                                  style: TextStyle(fontSize: 13,
                                     // fontFamily: "GloryMedium",
                                      color: grayColor)),
                            ],
                          ),
                          Expanded(child: Container()),
                          Text(getDate(state.data!.lastUpdatedDate),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 17,
                                color: grayColor,
                                //fontFamily: "GloryMedium",
                              )),
                          SizedBox(
                            width: 24,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            // Image border
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GalleryPhotoScreen(
                                          images: state.data!.photos,
                                          initialIndex: _carouselIndex,
                                        )));
                              },
                              child: CarouselSlider(
                                options: CarouselOptions(
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 0.8,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: false,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (page, reason) {
                                      _carouselIndex = page;
                                    }),
                                items: state.data!.photos.map((value) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: getPhoto(value),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      SizedBox(height: 23.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          state.data?.title ?? "",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            //fontFamily: 'GloryRegular',
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: mineShaft2GrayColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: SvgIconWithText(
                          sizeIcon: 20,
                          sizeText: 16,
                          paddingLeft: 1,
                          description: state.data?.city ?? "Не указано".tr(),
                          svgPath: 'assets/images/ic_location_1.svg',
                        ),
                      ),
                      SizedBox(height: 9.0),
                      Padding(
                        padding:  const EdgeInsets.only(left: 30),
                        child: SvgIconWithText(
                          sizeIcon: 20,
                          sizeText: 16,
                          description: 'Состоится'.tr() + " " + getDate(state.data!.executionDate).toString(),
                          svgPath: 'assets/images/ic_calendar_1.svg',
                        ),
                      ),
                      SizedBox(height: 9.0),
                      Padding(
                        padding:  const EdgeInsets.only(left: 25),
                        child: SvgIconWithText(
                          sizeIcon: 17,
                          sizeText: 16,
                          width: 8,
                          paddingLeft: 3,
                          description: '${state.data?.budget ?? 0} P',
                          svgPath: 'assets/images/ic_dollars_1.svg',
                        ),
                      ),
                      SizedBox(height: 26.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Описание:'.tr(),
                            style: TextStyle(
                              //fontFamily: 'GloryRegular',
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              height: 18.0 / 16.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        padding: EdgeInsets.only(bottom: 15,top: 10),
                        child: Text(
                          "${state.data!.otherDetails} ${state.data!.moreDescription}",
                          softWrap: true,
                          style: TextStyle(
                           // fontFamily: 'GloryRegular',
                            fontSize: 16.0,
                            height: 17.0 / 15.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 14.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Данные для модели:'.tr(),
                            style: TextStyle(
                              //fontFamily: 'GloryRegular',
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              height: 18.0 / 16.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 53),
                        child: Column(
                          children: [
                            RowItemElement(
                              description: 'Рост от:'.tr() + " " + state.data!.growthFrom.toString(),
                            ),
                            RowItemElement(
                              description: 'Возраст:'.tr() + " " + "${state.data!.ageFrom}-${state.data!.ageTo}",
                            ),
                            RowItemElement(
                              description:
                                  'Загранпаспорт:'.tr() + " " + getBoolValue(state.data!.isForeignPassport).toString(),
                            ),
                            RowItemElement(
                              description: 'Татуировки/Пирсинг:'.tr() + " " + getBoolValue(state.data!.isTatoo),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 14.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 27,
                          ),
                          Text(
                            'Категория:'.tr(),
                            style: TextStyle(
                              //fontFamily: 'GloryRegular',
                              fontSize: 16.0,
                              height: 17.0 / 15.0,
                              fontWeight: FontWeight.w600,
                              color: darkGreyColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 27, right: 23),
                        child: Text(
                          state.data?.category ?? "Не указано".tr(),
                          style: TextStyle(
                             // fontFamily: 'GloryMedium',
                              fontSize: 18.0,
                              color: lightText,
                              height: 19.0 / 17.0,),
                        ),
                      ),
                      Visibility(
                        visible: bloc.userType == 'MODEL',
                        child: GestureDetector(
                          onTap: () => {bloc.createReply(postId: state.data!.id)},
                          child: Container(
                            height: 45,
                            margin: EdgeInsets.only(left: 27, right: 23),
                            decoration: BoxDecoration(
                              color: vikingColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                                      ),
                            ),
                            child: Center(
                              child: Text(
                                'Откликнуться'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  //fontFamily: 'GloryMedium',
                                  fontSize: 19.0,
                                  height: 20.0 / 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: LoadingIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  String getDate(String date) {
    DateFormat dateFormatFrom = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateFormat dateFormatTo = DateFormat("dd.MM.yyyy");
    DateTime dateTime = dateFormatFrom.parse(date);
    return dateFormatTo.format(dateTime);
  }

  getBoolValue(bool value) {
    if (value) {
      return "Да".tr();
    } else {
      return "Нет".tr();
    }
  }

  String getPhoto(String value) {
    if (value.isNotEmpty && value != null) {
      return value;
    } else {
      return "https://www.signupgenius.com/cms/images/business/appointment-scheduling-tips-photographers-article-600x400.jpg";
    }
  }
}

class RowItemElement extends StatelessWidget {
  final String description;

  RowItemElement({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 5,
          width: 5,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        ),
        Text(
          description,
          style: TextStyle(
            //fontFamily: 'GloryRegular',
            fontSize: 16.0,
            height: 17.0 / 15.0,
          ),
        ),
      ],
    );
  }
}

String getDate(String date) {
  DateFormat dateFormatFrom = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  DateFormat dateFormatTo = DateFormat("dd.MM.yyyy");
  DateTime dateTime = dateFormatFrom.parse(date);
  return dateFormatTo.format(dateTime);
}

class SvgIconWithText extends StatelessWidget {
  final String svgPath;
  final String description;
  final double sizeText;
  final double sizeIcon;
  final double width;
  final double paddingLeft;

 const SvgIconWithText({
    Key? key,
    required this.sizeIcon,
    required this.sizeText,
    required this.svgPath,
    required this.description,
    this.width=10,
   this.paddingLeft=0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: paddingLeft,),
        SvgPicture.asset(
          svgPath,
          color: iconColor,
          width: sizeIcon,
          height: sizeIcon,
        ),
        SizedBox(width: width),
        Text(
          description,
          style: TextStyle(
            //fontFamily: 'GloryRegular',
            fontSize: sizeText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
