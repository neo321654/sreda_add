// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/data/api/constants.dart';
import '/domain/model/profile/profile_entity.dart';
import '/presentation/bloc/models/list_models_bloc.dart';
import '/presentation/bloc/models/list_models_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/models/filter_models_screen.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';

class ModelsScreen extends StatelessWidget {
  ModelsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListModelsBloc(),
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
        title: Text(
          "Модели".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21,
              //fontFamily: "GloryMedium",
              fontWeight: FontWeight.w600,
              color: blackPearlColor),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 19),
            child: GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contextRoute) => FilterModelsScreen(
                      city: context.read<ListModelsBloc>().city,
                      type: context.read<ListModelsBloc>().type,
                      gender: context.read<ListModelsBloc>().gender,
                    ),
                  ),
                );
                try {
                  var data = result as Map<String, dynamic>;
                  context.read<ListModelsBloc>().city = data['city'];
                  context.read<ListModelsBloc>().type = data['type'];
                  context.read<ListModelsBloc>().gender = data['gender'];
                } catch (error) {
                  context.read<ListModelsBloc>().city = null;
                  context.read<ListModelsBloc>().type = null;
                  context.read<ListModelsBloc>().gender = null;
                }
                context.read<ListModelsBloc>().getProfiles();
              },
              child: SvgPicture.asset("assets/images/ic_filter_1.svg", width: 20, height: 20),
            ),
          )
        ],
      ),
      body: BodyWidget(),
    );
  }
}

class BodyWidget extends StatelessWidget {
  BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ListModelsBloc>().getProfiles();
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(children: <Widget>[
          ListModels()
        ]),
      ),
    );
  }
}

class ListModels extends StatefulWidget {
  ListModels({
    Key? key,
  }) : super(key: key);

  @override
  State<ListModels> createState() => _ListModelsState();
}

class _ListModelsState extends State<ListModels> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListModelsBloc, ListModelsScreenState>(
      listener: (context, state) {
        if (state is ListModelsScreenErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка".tr())));
        }
      },
      builder: (context, state) {
        if (state is ListModelsScreenLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ListModelsScreenSuccess) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GridView.custom(
                    shrinkWrap: true,
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
                    childrenDelegate: SliverChildBuilderDelegate(
                        (context, index){
                          return  Padding(
                            padding:index==0?const EdgeInsets.only(top: 10):const EdgeInsets.only(top: 0),
                            child: ItemModel(model: state.data![index]),
                          );
                        },

                        childCount: state.data!.length),
                  ),
                )),
          );
        }

        return SizedBox();
      },
    );
  }
}

class ItemModel extends StatelessWidget {
  final ProfileEntity model;

  ItemModel({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowProfileModelScreen(profileId: model.id ?? 0, isEdit: false, isSelf: false)),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Image border
            child: Image.network(
              getLinkPhoto(model),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, 1),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x000f0f0f),
                      Color(0x1A0F0F0F),
                      Color(0x660F0F0F),
                    ],
                  )),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, 1),
            child: SizedBox(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        model.name ?? "",
                        style: TextStyle(color: Colors.white,
                            //fontFamily: "GloryRegular",
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 16),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/ic_location_white.svg",
                          width: 12,
                          height: 13,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            model.city ?? "",
                            style: TextStyle(color: Colors.white,
                                //fontFamily: "GloryRegular",
                                fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
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
        if (model.profilePhotos!.isEmpty && model.profilePhotos == null) {
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
