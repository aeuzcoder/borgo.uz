import 'dart:convert';

import 'package:borgo/core/errors/exception.dart';
import 'package:borgo/core/network/api_constants.dart';
import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/data/datasources/network/network_service.dart';
import 'package:borgo/feature/data/models/sign_in_model.dart';
import 'package:borgo/feature/data/models/user_model.dart';
import 'package:borgo/feature/domain/entities/sign_in_entity.dart';
import 'package:borgo/feature/domain/entities/user_entity.dart';
import 'package:borgo/feature/domain/repostitory/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:http_interceptor/http_interceptor.dart';

class UserRepoImpl implements UserRepo {
  @override
  Future<Either<String, Map<String, dynamic>>> getUser() async {
    try {
      var result = await DBService.to.getUser();

      return Right(result);
    } on CacheException {
      return Left('User ro`yhatdan o`tmagan');
    }
  }

  @override
  Future<Either<String, SignInEntity>> signIn(
      {required String phone, required String password}) async {
    try {
      final response = await NetworkService.POST(
        ApiConstants.TOKEN,
        {
          'phone': phone,
          'password': password,
        },
        isAuth: true,
      );
      final resultJson = jsonDecode(response!);

      final result = SignInModel.fromJson(resultJson);

      return Right(result);
    } on InvalidInputException {
      return Left('Login yoki parolda xatolik');
    } on ClientException {
      return Left('Internet bilan bog`lanib bolmadi');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> signUp({required UserEntity user}) async {
    try {
      var response = await NetworkService.POST(
          ApiConstants.REGISTER, createUserFromEntity(user));
      var result = jsonDecode(response ?? '');
      return Right(result['message'] ?? 'Ro\'yhatdan otdingiz');
    } on BadRequestException {
      return Left('Bu raqam orqali oldin ro`yhatdan o`tilgan');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> setUser(String phone, String password) async {
    var response = await DBService.to.setUser(phone, password);
    if (response) {
      return Right('User saqlandi');
    } else {
      return Left('User ma`lumoti bor');
    }
  }
}
