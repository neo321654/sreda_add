import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '/domain/model/auth/post_entity.dart';
import '/presentation/bloc/favorite/favorite_post_bloc.dart';
import '/presentation/bloc/favorite/favorite_post_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/announcement/edit_announcement_screen.dart';
import '/presentation/screens/favorite/favorite_replys_screen.dart';
import '/presentation/screens/home/detail_screen.dart';
import '/presentation/widgets/blue_button.dart';
import '/presentation/widgets/post_card.dart';

import '../../widgets/post_card_response.dart';
import '../../widgets/submit_button.dart';
import '../announcement/announcement_screen.dart';

class RespondScreen extends StatefulWidget {
  RespondScreen({Key? key}) : super(key: key);

  @override
  State<RespondScreen> createState() => _RespondScreenState();
}

class _RespondScreenState extends State<RespondScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritePostBloc>(
      create: (context) => FavoritePostBloc(),
      child: ListRespond(),
    );
  }
}

class ListRespond extends StatelessWidget {
  ListRespond({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritePostBloc, FavoritePostState>(builder: (context, state) {
      if (state is FavoritePostInitial) {
        context.read<FavoritePostBloc>().getPostSelf();
        return SizedBox();
      } else if (state is FavoritePostLoadedErrorState) {
        return Center(child: Text("Что-то пошло не так".tr()));
      } else if (state is FavoritePostLoadedState) {
        return Stack(
          children:[
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                itemCount: state.listFavoritePosts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemFavoritePost(postEntity: state.listFavoritePosts[index]);
                }),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20,right: 20,top: 5),
              color: primaryBackgroundColor,
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
          )
        ]);
      } else {
        return SizedBox();
      }
    });
  }
}

class ItemFavoritePost extends StatefulWidget {
  final PostEntity postEntity;

  ItemFavoritePost({Key? key, required this.postEntity}) : super(key: key);

  @override
  State<ItemFavoritePost> createState() => _ItemFavoritePostState();
}

class _ItemFavoritePostState extends State<ItemFavoritePost> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailScreen(id: widget.postEntity.id, userType: 'HIRER')),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            width: double.infinity,
            height: 180,
            child: PostCardResponse(postEntity: widget.postEntity,isModel: false),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: BlueButton(
                    sizeButton: 30,
                    sizeTextButton: 15,
                    colorText: grey,
                    textButton: 'Изменить'.tr(),
                    colorButton:const Color.fromRGBO(242, 243, 245, 1),
                    onTap: () async {
                      var value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAnnouncementScreen(
                              postId: widget.postEntity.id,
                              postTitle: widget.postEntity.title,
                              postBudget: widget.postEntity.budget,
                              postDetails: widget.postEntity.otherDetails,
                              postPhotos: widget.postEntity.photos,
                            )),
                      );
                      context.read<FavoritePostBloc>().getPostSelf();

                    },
                  ),
                ),
              ),

              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: BlueButton(
                    sizeButton: 30,
                    sizeTextButton: 15,
                    textButton: 'Отклики'.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoriteRepliesScreen(postId: widget.postEntity.id)),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  String getPostDateFormat(String executionDate) {
    DateFormat dateFormatFrom = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateFormat dateFormatTo = DateFormat("dd.MM");
    DateTime dateTime = dateFormatFrom.parse(executionDate);
    return dateFormatTo.format(dateTime);
  }

  String getPhoto(List<String> photos) {
    if (widget.postEntity.photos.isNotEmpty) {
      return widget.postEntity.photos[0];
    } else {
      return "https://www.signupgenius.com/cms/images/business/appointment-scheduling-tips-photographers-article-600x400.jpg";
    }
  }
}
