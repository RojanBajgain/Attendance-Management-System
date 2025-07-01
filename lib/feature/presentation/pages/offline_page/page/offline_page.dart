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
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // Handle navigation when connected
      if (controller.isConnected.value && !_hasNavigated) {
        _hasNavigated = true;
        print('OfflineView: Connection restored, scheduling navigation');

        // Use addPostFrameCallback to ensure navigation happens after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && controller.isConnected.value) {
            print('OfflineView: Executing navigation');
            controller.navigateToLastRoute();
          }
        });

        // Show loading indicator while navigating
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 20),
                Text(
                  'Reconnecting...',
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Reset navigation flag when disconnected
      if (!controller.isConnected.value) {
        _hasNavigated = false;
      }

      return PopScope(
        canPop: false, // Prevent back navigation from offline page
        onPopInvoked: (didPop) {
          // Optionally show a message that back navigation is disabled
        },
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator(
                color: isDarkMode ? Colors.white : Colors.black,
                onRefresh: () async {
                  await controller.refreshPage(context);
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
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.wifi_off,
                                size: 50,
                                color: isDarkMode ? Colors.white : Colors.black,
                              );
                            },
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
                              Obx(() => GestureDetector(
                                    onTap: controller.isChecking.value
                                        ? null
                                        : () async {
                                            await controller
                                                .refreshPage(context);
                                          },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: controller.isChecking.value
                                            ? Colors.grey
                                            : (isDarkMode
                                                ? Colors.white70
                                                : Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: controller.isChecking.value
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: isDarkMode
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'Refresh Now',
                                              style: smallStyle.copyWith(
                                                color: isDarkMode
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                    ),
                                  )),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  try {
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
                                    }
                                  } catch (e) {
                                    print('Error opening network settings: $e');
                                  }
                                },
                                child: Text(
                                  'Network Settings',
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
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
