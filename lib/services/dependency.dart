import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);

  // Initialize other dependencies
  Get.put<ApiClient>(ApiClient(sharedPreferences: Get.find()));
  Get.put<AuthRepositoryImpl>(
      AuthRepositoryImpl(apiClient: Get.find<ApiClient>()));
  Get.put<AuthController>(
    AuthController(authRepo: Get.find<AuthRepositoryImpl>()),
  );
}
