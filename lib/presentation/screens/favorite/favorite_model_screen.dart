import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/data/api/constants.dart';
import '/domain/model/profile/profile_entity.dart';
import '/new_code/common/flutter_helpers.dart';
import '/presentation/bloc/favorite/model/favorite_model_screen_bloc.dart';
import '/presentation/bloc/favorite/model/favorite_model_screen_state.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';
import '/presentation/screens/profile/widget/profile_card.dart';

import '../models/models_screen.dart';

class FavoriteModelScreen extends StatefulWidget {
  FavoriteModelScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteModelScreen> createState() => _FavoriteModelScreenState();
}

class _FavoriteModelScreenState extends State<FavoriteModelScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteModelScreenBloc>(create: (context) => FavoriteModelScreenBloc(), child: ListModels());
  }
}

class ListModels extends StatelessWidget {
  ListModels({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteModelScreenBloc, FavoriteModelScreenState>(
      builder: (context, state) {
        if (state is FavoriteModelScreenLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FavoriteModelScreenSuccess) {
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
                       const WovenGridTile(
                          0.91,
                          alignment: AlignmentDirectional.bottomStart,
                        ),
                       const WovenGridTile(1),
                      ],
                    ),
                    childrenDelegate: SliverChildBuilderDelegate((context, index){
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


