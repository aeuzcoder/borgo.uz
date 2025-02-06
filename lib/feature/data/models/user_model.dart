import 'package:borgo/feature/domain/entities/user_entity.dart';

Map<String, dynamic> createUserFromEntity(UserEntity data) {
  var model = UserModel.convertEntityToModel(data);
  return model.toJson();
}

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.password,
    required super.email,
    required super.phoneNumber,
    required super.surname,
  });

  Map<String, dynamic> toJson() {
    return {
      if (phoneNumber != null) 'phone': phoneNumber,
      if (name != null) 'first_name': name,
      if (surname != null) 'last_name': surname,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phone'],
      name: json['name'],
      surname: json['last_name'],
      email: json['email'],
      password: json['password'],
    );
  }
  static UserModel convertEntityToModel(UserEntity entity) {
    return UserModel(
      name: entity.name,
      surname: entity.surname,
      password: entity.password,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
    );
  }
}
