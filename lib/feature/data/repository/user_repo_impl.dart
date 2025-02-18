import 'package:borgo/feature/domain/repostitory/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRepoImpl implements UserRepo {
  @override
  Future<Either<String, String>> getRefresh(String refreshToken) async {
    try {
      final url = Uri.parse('https://api.borgo.uz/en/api/auth/token/refresh/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(data['access']); // Возвращаем access token
      } else {
        return Left('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
