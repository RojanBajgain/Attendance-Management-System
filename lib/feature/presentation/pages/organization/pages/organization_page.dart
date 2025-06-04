import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/presentation/pages/organization/controller/organization_controller.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_model.dart';
import 'package:ams/feature/presentation/pages/organization/pages/organization_container.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final controller = Get.put(OrganizationController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Departments',
          style: normalStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Department',
              style: normalStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Click on your desired department to proceed. If you do not see your department.',
              style: miniStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.organizationList.isEmpty) {
                  return ListView.builder(
                    itemCount: controller.organizationList.length,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ShrimmerEffect.rectangular(height: 100),
                      );
                    },
                  );
                } else if (controller.organizationList.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Department found.',
                          style: miniStyle.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: controller.organizationList.length,
                    itemBuilder: (context, index) {
                      final organization = controller.organizationList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // Save selected organization and navigate
                            selectOrganization(organization);
                          },
                          child: OrganizationContainer(
                            title: organization.title,
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void selectOrganization(Datum organization) {
    // Save selected organization
    GetStorage box = GetStorage();
    box.write('selectedOrganization', {
      'title': organization.title,
      'api_key': organization.apiKey,
    });

    // Update ApiClient with selected organization's apiKey
    final apiClient = Get.find<ApiClient>();
    apiClient.saveTokens(
      apiClient.token,
      apiClient.refreshToken,
      organization.apiKey ?? '',
    );

    Get.offAll(
      () => const BottomNavPage(),
      transition: Transition.rightToLeft,
    );

    SSnackbarUtil.showSnackbar(
      'Department Selected',
      'You have selected ${organization.title}',
      SnackbarType.success,
    );
  }
}
