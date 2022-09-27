import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '/data/api/service/profile_service.dart';
import '/new_code/common/functional.dart';

typedef UserTypeGetter = Future<Either<Exception, UserType>> Function();

class UserTypeUnset extends Equatable implements Exception {
  @override
  List get props => [];
}

enum UserType {
  hirer,
  model,
}

const _hirerValue = "HIRER";
const _modelValue = "MODEL";

UserTypeGetter newUserTypeGetter(ProfileService service) => () {
      return withExceptionHandling(() async {
        final profile = await service.getProfileSelf();
        switch (profile.userType) {
          case _hirerValue:
            return UserType.hirer;
          case _modelValue:
            return UserType.model;
          default:
            throw UserTypeUnset();
        }
      });
    };
