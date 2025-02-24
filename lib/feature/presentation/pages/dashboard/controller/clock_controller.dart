/* import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockController extends GetxController {
  // State variables
  var isClockedIn = false.obs;
  var isOnBreak = false.obs;
  var isClockedOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPersistedState(); // Load saved state when the controller initializes
  }

  // Load persisted state from SharedPreferences
  Future<void> _loadPersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    isClockedIn.value = prefs.getBool('isClockedIn') ?? false;
    isOnBreak.value = prefs.getBool('isOnBreak') ?? false;
    isClockedOut.value = prefs.getBool('isClockedOut') ?? false;
  }

  // Save state to SharedPreferences
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isClockedIn', isClockedIn.value);
    await prefs.setBool('isOnBreak', isOnBreak.value);
    await prefs.setBool('isClockedOut', isClockedOut.value);
  }

  // Handle clock-in
  Future<void> handleClockIn() async {
    isClockedIn.value = true;
    isClockedOut.value = false;
    isOnBreak.value = false;
    await _saveState();
  }

  // Handle clock-out
  Future<void> handleClockOut() async {
    isClockedIn.value = false;
    isClockedOut.value = true;
    isOnBreak.value = false;
    await _saveState();
  }

  // Handle break/resume
  Future<void> handleBreak() async {
    isOnBreak.value = !isOnBreak.value;
    await _saveState();
  }
}
 */
