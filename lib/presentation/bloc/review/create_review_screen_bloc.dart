import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/model/profile/create_review_entity.dart';
import '/domain/repository/profile_repository.dart';
import '/presentation/bloc/review/create_review_screen_state.dart';

class CreateReviewScreenBloc extends Cubit<CreateReviewScreenState> {
  CreateReviewScreenBloc() : super(CreateReviewScreenInitial());

  String errorMessage = '';

  final ProfileRepository _repository = serviceDiPost<ProfileRepository>();

}
