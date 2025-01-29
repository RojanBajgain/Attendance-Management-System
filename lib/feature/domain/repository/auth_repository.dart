import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';

abstract class AuthRepository {
  Future<ApiResponse<LoginModel>> login(String email, String pw);
}
