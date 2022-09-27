import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/model/profile/create_review_entity.dart';
import '/domain/repository/profile_repository.dart';
import '/new_code/contacts/logic/services.dart';
import '/presentation/bloc/review/review_screen_state.dart';

class ReviewScreenBloc extends Cubit<ReviewScreenState> {
  final BoughtContactChecker _checkContact;
  final bool isSelf;

  var userId = 0;

  ReviewScreenBloc(this.userId, this.isSelf, this._checkContact) : super(ReviewScreenInitial()) {}

  String errorMessage = '';

  // Future<bool> _isSelf() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var token = parseJwt(preferences.getString("TOKEN") ?? "");
  //   if (userId == token['user_id']) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
  //
  // Map<String, dynamic> parseJwt(String token) {
  //   final parts = token.split('.');
  //   if (parts.length != 3) {
  //     throw Exception('invalid token');
  //   }
  //
  //   final payload = _decodeBase64(parts[1]);
  //   final payloadMap = json.decode(payload);
  //   if (payloadMap is! Map<String, dynamic>) {
  //     throw Exception('invalid payload');
  //   }
  //
  //   return payloadMap;
  // }
  //
  // String _decodeBase64(String str) {
  //   String output = str.replaceAll('-', '+').replaceAll('_', '/');
  //
  //   switch (output.length % 4) {
  //     case 0:
  //       break;
  //     case 2:
  //       output += '==';
  //       break;
  //     case 3:
  //       output += '=';
  //       break;
  //     default:
  //       throw Exception('Illegal base64url string!"');
  //   }
  //
  //   return utf8.decode(base64Url.decode(output));
  // }
  //
  final ProfileRepository _repository = serviceDiPost<ProfileRepository>();

  Future<void> getReviews(int userId) async {
    emit(ReviewLoadingState());
    final res = await _checkContact(userId);
    res.fold(
      (exception) {
        print(exception.toString());
        emit(ReviewLoadedErrorState(CatchException.convertException(exception)));
      },
      (canReview) async {
        _repository
            .getReviews(userId: userId)
            ?.then((value) => {emit(ReviewLoadedState(listReviews: value, canReview: canReview && !isSelf))})
            .catchError((onError) => {
                  print('ReviewError ===== $onError'),
                  if (onError.response.statusCode == 400)
                    {
                      errorMessage = onError.response.data['detail'],
                    },
                  emit(ReviewLoadedErrorState(CatchException.convertException(onError)))
                })
            .onError((error, stackTrace) => {emit(ReviewLoadedErrorState(CatchException.convertException(error)))});
      },
    );
  }

  Future<void> createReview(int userId, String textReview, double mark) async {
    emit(ReviewLoadingState());
    _repository
        .createReview(body: CreateReviewEntity(text: textReview, mark: mark.toInt(), author: userId))
        .then((value) => {emit(CreateReviewSuccessState()), getReviews(userId)})
        .catchError((onError) => {
              print('ReviewError ===== $onError'),
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(ReviewLoadedErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(ReviewLoadedErrorState(CatchException.convertException(error)))});
  }
}
