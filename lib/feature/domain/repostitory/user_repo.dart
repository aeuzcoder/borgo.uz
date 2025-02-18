import 'package:dartz/dartz.dart';

abstract class UserRepo {
  //REFRESH
  Future<Either<String, String>> getRefresh(String refreshToken);
}
