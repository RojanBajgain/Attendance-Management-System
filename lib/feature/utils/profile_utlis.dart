import 'package:ams/feature/presentation/pages/organization/model/organization_profile_model.dart';
import 'package:get_storage/get_storage.dart';

class ProfileUtil {
  static final GetStorage _box = GetStorage();

  static int? getProfileId() => _box.read('profile_id');

  static String? getOrganizationName() => _box.read('organization_name');

  static Map<String, dynamic>? getUserProfile() => _box.read('user_profile');

  static Future<void> saveProfileData(Profile profile) async {
    await _box.write('profile_id', profile.profileId);
    await _box.write('organization_name', profile.organization);
    await _box.write('user_profile', {
      'full_name': profile.fullName,
      'email': profile.email,
      'role': profile.role,
      'profile_image': profile.profileImage,
      'designation': profile.designation,
      'employee_type': profile.employeeType,
    });
  }
}
