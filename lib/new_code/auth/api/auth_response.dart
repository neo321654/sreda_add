import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String authToken;
  final bool isNewUser;
  @override
  List get props => [authToken, isNewUser];
  const AuthResponse(this.authToken, this.isNewUser);

  AuthResponse.fromJson(Map<String, dynamic> json)
      : this(
          json["token"],
          json["is_new_user"],
        );
}
