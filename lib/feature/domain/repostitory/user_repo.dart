import 'package:borgo/feature/domain/entities/sign_in_entity.dart';
import 'package:borgo/feature/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepo {
  //SET USER
  Future<Either<String, String>> setUser(String phone, String password);

  //GET USER
  Future<Either<String, Map<String, dynamic>>> getUser();

  //SIGN IN
  Future<Either<String, SignInEntity>> signIn(
      {required String phone, required String password});

  //SIGN UP
  Future<Either<String, String>> signUp({required UserEntity user});
}
