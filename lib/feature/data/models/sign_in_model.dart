import 'package:borgo/feature/domain/entities/sign_in_entity.dart';

class SignInModel extends SignInEntity {
  SignInModel({
    required super.accessToken,
    required super.refreshToken,
  });
  Map<String, dynamic> toJson() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
    };
  }

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }
}
