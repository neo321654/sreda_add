import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '/domain/model/auth/post_entity.dart';
import '/presentation/bloc/favorite/model/favorite_model_screen_bloc.dart';
import '/presentation/bloc/favorite/model/favorite_model_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/home/detail_screen.dart';
import '/presentation/widgets/blue_button.dart';
import '/presentation/widgets/post_card.dart';
import '/presentation/widgets/submit_button.dart';

import '../../widgets/loading.dart';
import '../../widgets/post_card_response.dart';

class FavoritesForModelScreen extends StatefulWidget {
  FavoritesForModelScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesForModelScreen> createState() => _FavoritesForModelScreenState();
}

class _FavoritesForModelScreenState extends State<FavoritesForModelScreen> {
  late FavoriteModelScreenBloc bloc;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bloc = FavoriteModelScreenBloc();
  }

  @override
  Widget build(BuildContext context) {
    print('kdjfkdfj');
    return Provider.value(
        value: bloc,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0.0,
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Text(
                'Отклики'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                 // fontFamily: 'GloryRegular',
                  color: Color(0xff062226),
                ),
              ),
            ),
            leadingWidth: 54.0,
            toolbarHeight: kToolbarHeight + 16.0,
          ),
          body: Container(child: BodyWidget()),
        ));
  }
}

class BodyWidget extends StatefulWidget {
  BodyWidget({Key? key}) : super(key: key);

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  late FavoriteModelScreenBloc? bloc;
  final double customHeight = 3.8;

  @override
  Widget build(BuildContext context) {
    //bloc = Provider.of<FavoriteModelScreenBloc>(context, listen: false);
    return BlocBuilder<FavoriteModelScreenBloc, FavoriteModelScreenState>(
      builder: (BuildContext context, state) {

        if (state is FavoriteModelScreenInitial) {
          print('111111');
          return Text('');
        } else if (state is FavoriteModelScreenLoading) {
          print('2222222');
          return LoadingIndicator();
        } else if (state is FavoriteModelRepliesScreenSuccess) {
          print('333333');

          return ListView.builder(

              itemCount: state.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemFavoritePost(postEntity: state.data![index].post!, replyId: state.data![index].id ?? 0);
              });
        } else if (state is FavoriteModelScreenErrorState) {
          print('444444');

          return Align(
            alignment: Alignment.topCenter,
            child: Text(state.message!.message.toString(),
                style: TextStyle(color: Colors.redAccent,
                    //fontFamily: 'GloryRegular',
                    fontSize: 16)),
          );
        } else {
          print('5555');
          // return Center(child: Text(''.tr()));
          var state1 = state as FavoriteModelScreenSuccess;
          return ListView.builder(
              itemCount: state.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(state.data![index].toString());
                // return ItemFavoritePost(postEntity: state.data![index]., replyId: state.data![index].id ?? 0);
              });
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
              fontSize: 9, color: grayColor, fontWeight: FontWeight.w300),
        ),
        Text(
          value,
          style: TextStyle(
            //fontFamily: 'GloryRegular',
            fontWeight: FontWeight.w100,
            fontStyle: FontStyle.italic,
            color: Color(0xff6CC9E0).withOpacity(0.6),
            fontSize: 9,
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

class ItemFavoritePost extends StatelessWidget {
  final PostEntity postEntity;
  final int replyId;
  late FavoriteModelScreenBloc? bloc;

  ItemFavoritePost({
    Key? key,
    required this.postEntity,
    required this.replyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<FavoriteModelScreenBloc>(context, listen: false);
    return Column(
      children: [
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailScreen(id: postEntity.id, userType: 'HIRER')),
            )
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 24, right: 24),
            width: double.infinity,
            height: 180,
            child: PostCardResponse(postEntity: postEntity,isModel: true),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 24, right: 24),
          child: SubmitButton(
            textButton: 'Отменить отклик'.tr(),
            onTap: () {
              bloc?.deleteReply(replyId: replyId);
            },
          ),
        )
      ],
    );
  }
}
