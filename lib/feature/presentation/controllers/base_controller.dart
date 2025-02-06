import 'package:borgo/feature/data/repository/user_repo_impl.dart';
import 'package:borgo/feature/domain/repostitory/user_repo.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  bool isLoading = false;
  bool isError = false;
  String? errorText;
  final UserRepo userRepo = UserRepoImpl();

  void changeLoading(bool loading) {
    isLoading = loading;
    update();
  }

  void changeError(bool value, {String? text}) {
    isError = value;
    errorText = text;
    update();
  }
}
