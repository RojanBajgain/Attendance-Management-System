import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/offline_page/controller/connectivity_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';

class OfflineView extends StatefulWidget {
  OfflineView({super.key});

  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  final OfflineController controller = Get.find<OfflineController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isConnected.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.checkLoginAndNavigate();
        });
        return const SizedBox.shrink();
      }
      return PopScope(
        canPop: controller.isConnected.value,
        onPopInvoked: (didPop) {},
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator(
                // backgroundColor: Colors.white,
                color: Colors.cyan,
                onRefresh: () async {
                  controller.checkConnectivity(context);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.tranquility,
                            height: 50,
                          ),
                          const SizedBox(height: 40),
                          Column(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                size: 70,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                textAlign: TextAlign.center,
                                'Seems like you are offline.\nMake sure your internet is working fine',
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                  onTap: () async {
                                    await controller.refreshPage(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Refresh Now',
                                      style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 20),
                              GestureDetector(
                                  onTap: () async {
                                    if (OpenSettingsPlus.shared
                                        is OpenSettingsPlusAndroid) {
                                      (OpenSettingsPlus.shared
                                              as OpenSettingsPlusAndroid)
                                          .wifi();
                                    } else if (OpenSettingsPlus.shared
                                        is OpenSettingsPlusIOS) {
                                      (OpenSettingsPlus.shared
                                              as OpenSettingsPlusIOS)
                                          .wifi();
                                    } else {
                                      throw Exception('Platform not supported');
                                    }
                                  },
                                  child: Text(
                                    'Network Settings',
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
