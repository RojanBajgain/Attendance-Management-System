import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/HR_Details/controller/hr_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ams/feature/presentation/pages/HR_Details/model/hr_detail_model.dart';

class HRDetailsPage extends StatelessWidget {
  const HRDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final controller = Get.find<OrganizationStaffController>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: isDarkMode ? Colors.white : Colors.black,
            titleSpacing: 0,
            title: Text(
              'View Teams',
              style: smallStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          body: RefreshIndicator(
            color: theme.colorScheme.primary,
            backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
            onRefresh: () async {
              await controller.getOrganizationStaff();
            },
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView(
                  children: const [
                    SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                );
              }

              if (controller.organizationStaff.isEmpty) {
                return ListView(
                  children: [
                    SizedBox(height: 80),
                    Center(
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
                    ),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
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
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final OrganizationStaffModel staff;
  final ThemeData theme;

  TeamMemberCard({
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    GetStorage box = GetStorage();
    final int userid = box.read('user_id');

    if (staff.id == userid) {
      return const SizedBox.shrink();
    }

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
                          : 'Admin',
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
                    staff.role == 'Admin'
                        ? ''
                        : staff.employeeType.isNotEmpty
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
                    staff.role == 'Admin' ? '' : staff.role,
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
                  ' ${DateFormat("d MMMM',' y").format(staff.joinedDate ?? DateTime.now())}',
                  secondaryTextColor,
                ),
            ],
          ),
          const SizedBox(height: 20),

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
                    backgroundColor: theme.colorScheme.primary,
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
                    backgroundColor: theme.colorScheme.primary,
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
        Icon(icon, size: 12, color: textColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ),
      ],
    );
  }
}

Future<void> _launchEmail(String email) async {
  final Uri emailUri = Uri(scheme: 'mailto', path: email);
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  }
}

Future<void> _launchPhone(String phone) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phone);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  }
}
