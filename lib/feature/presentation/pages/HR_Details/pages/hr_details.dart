import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/HR_Details/controller/hr_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ams/feature/presentation/pages/HR_Details/model/hr_detail_model.dart';

class HRDetailsPage extends StatelessWidget {
  const HRDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final controller = Get.put(OrganizationStaffController(
      organizationStaffRepo: Get.find(),
    ));

    return RefreshIndicator(
      onRefresh: controller.getOrganizationStaff,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                InkWell(
                  onTap: () => Get.back(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        'Team Directory',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${controller.organizationStaff.length} members',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Team Members List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.secondary,
                        ),
                      );
                    }

                    if (controller.organizationStaff.isEmpty) {
                      // return Center(
                      //   child: Text(
                      //     'No staff members found',
                      //     style: theme.textTheme.bodyMedium,
                      //   ),
                      // );
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_data.png',
                              height: 150,
                              width: 250,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "No Staffs Data Available",
                              style: smallStyle.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.organizationStaff.length,
                      itemBuilder: (context, index) {
                        final staff = controller.organizationStaff[index];
                        return TeamMemberCard(
                          staff: staff,
                          theme: theme,
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final OrganizationStaffModel staff;
  final ThemeData theme;

  const TeamMemberCard({
    super.key,
    required this.staff,
    required this.theme,
  });

  String getInitials(String name) {
    if (name.isEmpty) return 'NA';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String formatJoinDate(DateTime? date) {
    if (date == null) return 'Joined date not available';
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return 'Joined ${monthNames[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = theme.brightness == Brightness.dark;

    // final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (staff.profileImage.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    staff.profileImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildInitialsPlaceholder(staff.fullName);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildInitialsPlaceholder(staff.fullName);
                    },
                  ),
                )
              else
                _buildInitialsPlaceholder(staff.fullName),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.fullName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      staff.designation.isNotEmpty
                          ? staff.designation
                          : 'No designation',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    staff.employeeType.isNotEmpty
                        ? staff.employeeType
                        : 'No type',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    staff.role.isNotEmpty ? staff.role : 'No role',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Contact information
          Column(
            children: [
              _buildInfoRow(
                  Icons.email_outlined, staff.email, secondaryTextColor),
              const SizedBox(height: 8),
              _buildInfoRow(
                  Icons.phone_outlined, staff.phoneNumber, secondaryTextColor),
              const SizedBox(height: 8),
              if (staff.joinedDate != null)
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  formatJoinDate(staff.joinedDate),
                  secondaryTextColor,
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchEmail(staff.email),
                  icon: const Icon(
                    Icons.email_outlined,
                    size: 15,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Email',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    // backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchPhone(staff.phoneNumber),
                  icon: const Icon(
                    Icons.local_phone_outlined,
                    size: 15,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Call',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsPlaceholder(String name) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          getInitials(name),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color textColor) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: textColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _launchEmail(String email) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
  );
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  }
}

Future<void> _launchPhone(String phone) async {
  final Uri phoneUri = Uri(
    scheme: 'tel',
    path: phone,
  );
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  }
}
