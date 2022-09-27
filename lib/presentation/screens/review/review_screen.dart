import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '/data/api/constants.dart';
import '/new_code/di.dart';
import '/presentation/bloc/review/review_screen_bloc.dart';
import '/presentation/bloc/review/review_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/screens/review/create_review_screen.dart';

import '../../../new_code/common/app_bar.dart';
import '../../widgets/blue_button.dart';

class ReviewScreen extends StatefulWidget {
  bool isEdit = false;
  bool isSelf = false;
  int userId = 0;

  ReviewScreen({Key? key, required this.isEdit, required this.isSelf, required this.userId}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late ReviewScreenBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ReviewScreenBloc(widget.userId, widget.isSelf, uiDeps.checkContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar('Отзывы'.tr()),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListReviewsWidget(userId: widget.userId, bloc: bloc),
            ),
          ],
        ),
      ),
    );
  }
}

class ListReviewsWidget extends StatefulWidget {
  int userId;
  ReviewScreenBloc bloc;

  ListReviewsWidget({Key? key, required this.userId, required this.bloc}) : super(key: key);

  @override
  State<ListReviewsWidget> createState() => _ListReviewsWidgetState();
}

class _ListReviewsWidgetState extends State<ListReviewsWidget> {
  @override
  void initState() {
    widget.bloc.getReviews(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewScreenBloc, ReviewScreenState>(
        bloc: widget.bloc,
        builder: (context, state) {
          if (state is ReviewScreenInitial) {
            context.read<ReviewScreenBloc>().getReviews(widget.userId);
            return SizedBox();
          } else if (state is ReviewLoadedErrorState) {
            return Center(child: Text("Что-то пошло не так".tr()));
          } else if (state is ReviewLoadedErrorState) {
            return Center(child: Text("Что-то пошло не так".tr()));
          } else if (state is ReviewLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: state.listReviews.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  if (state.listReviews[index].authorPhoto != null)
                                    CircleAvatar(
                                      radius: 27,
                                      backgroundColor: vikingColor,
                                      child: CircleAvatar(
                                        radius: 27,
                                        backgroundImage: NetworkImage(getLinkPhoto(
                                            state.listReviews[index].authorPhoto.toString(),
                                            state.listReviews[index].profilePhotos.toString())),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            state.listReviews[index].authorName.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              //fontFamily: 'GloryMedium',
                                              color: Color(0xff062226),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              //fontFamily: 'GloryMedium',
                                              fontWeight: FontWeight.w400,
                                              color: grayColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: RatingBarIndicator(
                                      rating: state.listReviews[index].mark!.toDouble(),
                                      itemBuilder: (context, index) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 15.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 16, top: 13),
                                  child: Text(
                                    state.listReviews[index].text.toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      //fontFamily: 'GloryLight',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff062226),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: color_Nab,
                              )
                            ],
                          ),
                        );
                      }),
                ),
                Visibility(
                  visible: state.canReview,
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: BlueButton(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateReviewScreen(userId: widget.userId, customBloc: widget.bloc),
                            ),
                          );
                        },
                        textButton: 'Оставить отзыв'.tr(),
                      )),
                )
              ],
            );
          } else {
            return SizedBox();
          }
        });
  }

  String getLinkPhoto(String photo, String profilePhoto) {
    try {
      if (photo != null) {
        return ApiConstants.BASE_URL_IMAGE + photo;
      } else if (profilePhoto != null) {
        return ApiConstants.BASE_URL_IMAGE + "/media/" + profilePhoto;
      } else {
        return "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
      }
    } on Exception catch (_) {
      return "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
    }
  }
}
