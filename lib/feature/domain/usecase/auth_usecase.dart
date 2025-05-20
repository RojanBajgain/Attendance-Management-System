import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/domain/repository/auth_repository.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<ApiResponse<LoginModel>> login(
      String email, String pw, String role) async {
    return _authRepository.login(email, pw, role);
  }
}
