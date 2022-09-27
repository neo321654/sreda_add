import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/presentation/bloc/favorite/replies_screen_bloc.dart';
import '/presentation/bloc/favorite/replies_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';
import '/presentation/widgets/blue_button.dart';
import '/presentation/widgets/submit_button.dart';

import '../../../new_code/common/app_bar.dart';
import '../../widgets/loading.dart';

class FavoriteRepliesScreen extends StatefulWidget {
  final int postId;

  FavoriteRepliesScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<FavoriteRepliesScreen> createState() => _FavoriteRepliesScreenState();
}

class _FavoriteRepliesScreenState extends State<FavoriteRepliesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RepliesScreenBloc>(
        create: (context) => RepliesScreenBloc(postId: widget.postId),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar("Отклики".tr()),
          body: Container(child: BodyWidget(postId: widget.postId)),
        ));
  }
}

class BodyWidget extends StatefulWidget {
  final int postId;
  BodyWidget({Key? key, required this.postId}) : super(key: key);

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final double customHeight = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepliesScreenBloc, RepliesScreenState>(
      builder: (BuildContext context, state) {

        if (state is RepliesInitial) {
          return Text('');
        } else if (state is RepliesLoadingState) {
          return LoadingIndicator();
        } else if (state is RepliesLoadedState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.815,
              child: ListView.separated(
                itemCount: 2,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => {print('sdsd')},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 222,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0,1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      debugPrint(''),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowProfileModelScreen(
                                                isEdit: false,
                                                isSelf: false,
                                                profileId: 23 ?? 0)),
                                      )
                                    },
                                    child: Container(
                                      decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
                                      width: 94,
                                      height: 94,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: getLinkPhoto(state.listReplies[index].profile),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.listReplies[index].profile?.name ?? "",
                                        maxLines: 1,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/ic_location_1.svg',
                                            color: iconColor,
                                            width: 12,
                                            height: 12,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            state.listReplies[index].profile?.city ?? "",
                                            style: TextStyle(
                                              //fontFamily: 'GloryRegular',
                                              fontSize: 12,
                                              color: grayColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 28),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => {
                                              context
                                                  .read<RepliesScreenBloc>()
                                                  .acceptReply(45, widget.postId)
                                            },
                                            child: SizedBox(
                                              width: 91,
                                              child: BlueButton(
                                                sizeButton: 30,
                                                sizeTextButton: 14,
                                                colorText: Colors.white,
                                                textButton: 'Принять'.tr(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          GestureDetector(
                                            onTap: () => {
                                              context
                                                  .read<RepliesScreenBloc>()
                                                  .declineReply(45, widget.postId)
                                            },
                                            child: SizedBox(
                                              width: 106,
                                              child: BlueButton(
                                                sizeButton: 30,
                                                sizeTextButton: 14,
                                                colorText: grayColor,
                                                colorButton: colorButton21,
                                                textButton: 'Отклонить'.tr(),

                                              ),
                                            ),
                                          ),


                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FavRowInfoCard(
                                    title: 'Рост:'.tr(),
                                    value: state.listReplies[index].profile?.growth.toString() ?? "" ' cm',
                                  ),
                                  SizedBox(height: 5),
                                  MySeparator(),
                                  SizedBox(height: 5),
                                  FavRowInfoCard(
                                    title: 'Грудь-Талия-Бедра:'.tr(),
                                    value: "${state.listReplies[index].profile?.bust}*${state.listReplies[index].profile?.waist}*${state.listReplies[index].profile?.hips}",
                                  ),
                                  SizedBox(height: 5),
                                  MySeparator(),
                                  SizedBox(height: 5),
                                  FavRowInfoCard(
                                    title: 'Размер обуви:'.tr(),
                                    value: state.listReplies[index].profile?.shoesSize.toString() ?? "",
                                  ),
                                  SizedBox(height: 5),
                                  MySeparator(),
                                  SizedBox(height: 5),
                                  FavRowInfoCard(
                                    title: 'Размер одежды:'.tr(),
                                    value: state.listReplies[index].profile?.closeSize.toString() ?? "",
                                  ),

                                ],
                              )

                            ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is RepliesLoadedErrorState) {
          return Align(
            alignment: Alignment.topCenter,
            child: Text(state.message!.message.toString(),
                style: TextStyle(color: Colors.redAccent, fontFamily: 'GloryRegular', fontSize: 16)),
          );
        } else {
          return Text('фывфы'.tr());
        }
      },
    );
  }
}

class FavRowInfoCard extends StatelessWidget {
  final String title;
  final String value;

  FavRowInfoCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

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
              fontSize: 12, color: lightText, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(
            //fontFamily: 'GloryRegular',
            fontWeight: FontWeight.w400,
            //fontStyle: FontStyle.italic,
            color: grayColor,
            fontSize: 12,
          ),
        )
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  MySeparator({Key? key, this.height = 1}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey[300]),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class WidgetItemAdvert extends StatelessWidget {
  WidgetItemAdvert({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 24, right: 24),
          width: double.infinity,
          height: 180,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: CachedNetworkImage(
                  imageUrl: "https://art-assorty.ru/wp-content/uploads/2018/09/222547.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 71,
                  height: 33,
                  decoration: BoxDecoration(
                      color: vikingColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '8000 ₽', // TODO: why is is this a constant (fix the error of the previous dev)?
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: Container(
                  height: 230,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x000f0f0f),
                          Color(0x660F0F0F),
                          Color(0x660F0F0F),
                        ],
                      )),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, bottom: 20),
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              "Модель для причёсики".tr(),
                              style: TextStyle(color: Colors.white,
                                  //fontFamily: "GloryRegular",
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Москва, Россия".tr(),
                                    style: TextStyle(color: Colors.white,
                                        //fontFamily: "GloryRegular",
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SvgPicture.asset("assets/images/ic_location.svg")
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Row(
                                  children: [
                                    Text(
                                      "29.03 - 30.03",
                                      style: TextStyle(color: Colors.white,
                                         // fontFamily: "GloryRegular",
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SvgPicture.asset("assets/images/ic_calendar.svg")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 24, right: 24),
          child: BlueButton(),
        )
      ],
    );
  }
}
