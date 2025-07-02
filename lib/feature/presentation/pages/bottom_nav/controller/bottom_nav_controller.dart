import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedTab = 0.obs;
  // final storage = GetStorage();

  void changeTab(int index) {
    selectedTab.value = index;
  }

  // final HomeController controller = Get.put(
  //   HomeController(testrepo: Get.find()),
  // );
  @override
  void onInit() {
    // selectedTab.value = 0;
    // logger.d("heloooooooooooo");
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
