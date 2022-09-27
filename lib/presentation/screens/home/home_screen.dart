// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/api/constants.dart';
import '/domain/model/auth/post_entity.dart';
import '/domain/model/profile/profile_entity.dart';
import '/presentation/bloc/home/home_screen_bloc.dart';
import '/presentation/bloc/home/home_screen_state.dart';
import '/presentation/bloc/home/talents_widget_bloc.dart';
import '/presentation/bloc/home/talents_widget_state.dart';
import '/presentation/screens/announcement/announcement_screen.dart';
import '/presentation/screens/filters/filter_screen.dart';
import '/presentation/screens/home/detail_screen.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';
import '/presentation/widgets/post_card.dart';

import '../../colors.dart';
import '../../widgets/loading.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeScreenBloc>(create: (context) => HomeScreenBloc()),
        BlocProvider<TalentsWidgetBloc>(
          create: (context) => TalentsWidgetBloc(),
        )
      ],
      child: ContentWidget(),
    );
  }
}

class ContentWidget extends StatefulWidget {
  ContentWidget({Key? key}) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.0,
          centerTitle: true,
          leadingWidth: 68,
          leading: AddAdvertWidget(),
          title: Text(
            "Главная".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21,
                //fontFamily: "GloryMedium",
                fontWeight: FontWeight.w600,
                color: blackPearlColor),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: GestureDetector(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contextRoute) => FilterScreen(
                              city: context.read<HomeScreenBloc>().city ?? "",
                              workType: context.read<HomeScreenBloc>().workType ?? 0,
                              gender: context.read<HomeScreenBloc>().gender ?? 2,
                              fromPrice: context.read<HomeScreenBloc>().fromPrice ?? 0,
                              toPrice: context.read<HomeScreenBloc>().toPrice ?? 500000,
                              category: context.read<HomeScreenBloc>().category ?? 2,
                            )),
                  );
                  try {
                    var map = (result as Map<String, dynamic>);
                    context.read<HomeScreenBloc>().city = map['city'];
                    context.read<HomeScreenBloc>().workType = map['workType'];
                    context.read<HomeScreenBloc>().gender = map['gender'];
                    context.read<HomeScreenBloc>().category = map['category'];
                    context.read<HomeScreenBloc>().fromPrice = map['fromPrice'];
                    context.read<HomeScreenBloc>().toPrice = map['toPrice'];
                  } catch (error) {
                    context.read<HomeScreenBloc>().city = null;
                    context.read<HomeScreenBloc>().workType = null;
                    context.read<HomeScreenBloc>().gender = null;
                    context.read<HomeScreenBloc>().category = null;
                    context.read<HomeScreenBloc>().fromPrice = null;
                    context.read<HomeScreenBloc>().toPrice = null;
                  }
                  context.read<HomeScreenBloc>().getPosts();
                },
                child: SvgPicture.asset("assets/images/ic_filter_1.svg", width: 20, height: 20),
              ),
            ),
          ],
        ),
        body: BodyWidget());
  }
}

class BodyWidget extends StatefulWidget {
  BodyWidget({Key? key}) : super(key: key);

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  var userType = "";
  var filterCity = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserType();
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<HomeScreenBloc>().getPosts();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Лучшие таланты:".tr(),
                  style: TextStyle(fontSize: 18,
                      //fontFamily: "GloryMedium",
                      fontWeight:FontWeight.w500,color: lightText),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TalentsWidget(),
              SizedBox(
                height: 20,
              ),

              ListAdvert(userType: userType),
            ],
          ),
        ),
      ),
    );
  }

  void _getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userType = preferences.getString("TYPE") ?? "";
  }
}

class TalentsWidget extends StatefulWidget {
  TalentsWidget({Key? key}) : super(key: key);

  @override
  State<TalentsWidget> createState() => _TalentsWidgetState();
}

class _TalentsWidgetState extends State<TalentsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentsWidgetBloc, TalentsWidgetState>(
      builder: (BuildContext context, state) {
        if (state is TalentsWidgetInitial) {
          return Text('');
        } else if (state is TalentsWidgetLoading) {
          return LoadingIndicator();
        } else if (state is TalentsWidgetSuccess) {
          return SizedBox(
            height: 120,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return CircleItem(item: state.data![index]);
              },
              separatorBuilder: (context, index) => SizedBox(
                width: 16,
              ),
            ),
          );
        } else if (state is TalentsWidgetErrorState) {
          return Align(
            alignment: Alignment.topCenter,
            child: Text(state.message!.message.toString(),
                style: TextStyle(color: Colors.redAccent,
                    //fontFamily: 'GloryRegular',
                    fontSize: 16)),
          );
        } else {
          return Text('Ошибка'.tr());
        }
      },
    );
  }
}

class ListAdvert extends StatefulWidget {
  String userType;

  ListAdvert({Key? key, required this.userType}) : super(key: key);

  @override
  State<ListAdvert> createState() => _ListAdvertState();
}

class _ListAdvertState extends State<ListAdvert> {
  late HomeScreenBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<HomeScreenBloc>(context, listen: false);
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (BuildContext context, state) {
        if (state is HomeScreenInitial) {
          return Text('');
        } else if (state is HomeScreenLoading) {
          return LoadingIndicator();
        } else if (state is HomeScreenSuccess) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return WidgetItemAdvert(postEntity: state.data![index], userType: widget.userType);
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
          );
        } else if (state is HomeScreenErrorState) {
          return Align(
            alignment: Alignment.topCenter,
            child: Text(state.message!.message.toString(),
                style: TextStyle(color: Colors.redAccent,
                   // fontFamily: 'GloryRegular',
                    fontSize: 16)),
          );
        } else {
          return Center(child: Text(''.tr()));
        }
      },
    );
  }
}

class AddAdvertWidget extends StatefulWidget {
  AddAdvertWidget({Key? key}) : super(key: key);

  @override
  State<AddAdvertWidget> createState() => _AddAdvertWidgetState();
}

class _AddAdvertWidgetState extends State<AddAdvertWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 22.0,right: 22.0),
      child: GestureDetector(
        onTap: () {
          createPost();
        },
        child: SvgPicture.asset(
          "assets/images/ic_add.svg",
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  void createPost() async {
    // TODO поправить это
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('TYPE') == 'MODEL') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Создание додступно только для работников'.tr()),
        duration: Duration(milliseconds: 700),
      ));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AnnouncementScreen()),
      );
    }
  }
}

class WidgetItemAdvert extends StatelessWidget {
  final PostEntity postEntity;
  final String userType;

  WidgetItemAdvert({Key? key, required this.postEntity, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(id: postEntity.id, userType: userType)),
          );
        },
        child: PostCard(
          postEntity: postEntity,
        ),
      ),
    );
  }
}

class CircleItem extends StatelessWidget {
  final ProfileEntity item;

  CircleItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowProfileModelScreen(profileId: item.id ?? 0, isEdit: false, isSelf: false)),
            )
          },
          child: CircleAvatar(
            radius: 35,
            backgroundColor: vikingColor,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(getLinkPhoto(item)),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(item.name?.replaceAll(" ", "\n") ?? "",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontFamily: "GloryMedium", color: lightText))
      ],
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
        if (model.profilePhotos == null || model.profilePhotos!.isEmpty) {
          return "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
        } else {
          return ApiConstants.BASE_URL_IMAGE + "/media/" + model.profilePhotos![0].replaceAll(ApiConstants.TO_REPLACE_LINK_WHITH_HTTP, "");
        }
      }
    } on Exception catch (_) {
      return "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
    }
  }
}
