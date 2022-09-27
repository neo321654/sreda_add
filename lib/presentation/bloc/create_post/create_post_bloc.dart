import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/model/post/create_post_request_entity.dart';
import '/domain/repository/post_repository.dart';
import '/presentation/bloc/create_post/create_post_state.dart';

class CreatePostBloc extends Cubit<CreatePostState> {
  CreatePostBloc() : super(CreatePostInitial());

  final PostRepository _repository = serviceDiPost<PostRepository>();
  String errorMessage = "";

  void createPost(
      {required String title,
      required String date,
      required String city,
      required int gender,
      required List<File> photos,
      required String ageFrom,
      required String ageTo,
      required String heightTo,
      required String heightFrom,
      required String hasTattoo,
      required bool hasInternPassword,
      required String budget,
      required String description,
      required String category}) {




    emit(CreatePostLoading());
    _repository
        .createPost(
            createPostRequestEntity: CreatePostRequestEntity(
          title: title,
          executionDate: date,
          budget: int.parse(budget),
          city: city,
          performerGender: "",
          photos: photos,
          ageFrom: int.parse(ageFrom),
          ageTo: int.parse(ageTo),
          growthFrom: int.parse(heightFrom),
          growthTo: int.parse(heightTo),
          isTattooOrPiercings: hasTattoo,
          isForeignPassport: hasInternPassword,
          otherDetails: description,
          category: "Модель".tr(),
        ))
        .then((value) => {emit(CreatePostSuccess())})
        .catchError((onError) {
          print('dfdf');
          return {

              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(CreatePostErrorState(CatchException.convertException(onError)))
            };
        })
        .onError((error, stackTrace) => {emit(CreatePostErrorState(CatchException.convertException(error)))});
  }
}
