import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '/presentation/bloc/review/review_screen_bloc.dart';
import '/presentation/bloc/review/review_screen_state.dart';
import '/presentation/colors.dart';
import '/presentation/widgets/submit_button.dart';

import '../../../new_code/common/app_bar.dart';
import '../../widgets/blue_button.dart';

class CreateReviewScreen extends StatefulWidget {
  int userId = 0;
  ReviewScreenBloc customBloc;

  CreateReviewScreen({Key? key, required this.userId, required this.customBloc}) : super(key: key);

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  var reviewController = TextEditingController();
  double _value = 4;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewScreenBloc, ReviewScreenState>(
      bloc: widget.customBloc,
      listener: (context, state) {
        if (state is CreateReviewSuccessState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar('Оставить отзыв'.tr()),
        body: SafeArea(
          child: Stack(
            children:[ Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Оценка'.tr(),
                    style:const TextStyle(
                     // fontFamily: 'GloryRegular',
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      height: 18.0 / 16.0,
                    ),
                  ),
                ),
                const SizedBox(height: 7.0),
        Padding(
            padding: const EdgeInsets.only(left:6),
            child: RatingBar.builder(
              itemSize: 28,
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding:const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _value = rating;
                });
              },
            ),
        ),

                const SizedBox(height: 24.0),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Отзыв'.tr(),
                      style:const TextStyle(
                        color: Colors.grey,
                        //fontFamily: 'GloryRegular',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        height: 18.0 / 16.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    controller: reviewController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "",
                        contentPadding: EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: borderGreyColor,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: silverGrayColor,
                            width: 0.5,
                          ),
                        )),
                  ),
                ),

              ],
            ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonWidget(
                  textButton: 'Оставить отзыв',
                    bloc: widget.customBloc,
                    userId: widget.userId,
                    textReview: reviewController.text.toString(),
                    mark: _value),
              ),
          ]
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: CircularProgressIndicator(
          color: vikingColor,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

class ButtonWidget extends StatefulWidget {
  int userId;
  String textReview;
  double mark;
  ReviewScreenBloc bloc;
  final String textButton;

  ButtonWidget({Key? key,this.textButton='Сохранить', required this.userId, required this.textReview, required this.mark, required this.bloc})
      : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: BlueButton(
        onTap: () {
          widget.bloc.createReview(widget.userId, widget.textReview, widget.mark);
        },
        textButton: widget.textButton.tr(),
      ),
    );
  }
}
