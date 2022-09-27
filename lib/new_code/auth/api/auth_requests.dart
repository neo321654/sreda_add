import 'package:equatable/equatable.dart';

abstract class SerializableRequest {
  Map<String, dynamic> toJson();
}

class GoogleAuthRequest extends Equatable implements SerializableRequest {
  final String token;
  @override
  List get props => [token];
  const GoogleAuthRequest(this.token);
  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

class AppleAuthRequest extends Equatable implements SerializableRequest {
  final String token;
  final String clientId;
  @override
  List get props => [token, clientId];
  const AppleAuthRequest(this.token, this.clientId);
  Map<String, dynamic> toJson() => {
        "token": token,
        "client_id": clientId,
      };
}
