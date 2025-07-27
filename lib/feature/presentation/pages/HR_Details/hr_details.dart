import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class HRDetails extends StatelessWidget {
  const HRDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 15.0),
                    const Text(
                      'Team Directory',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '2 members',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Team Members Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 16,
                  children: const [
                    TeamMemberCard(
                      initials: 'SL',
                      name: 'Suyog Luitel',
                      role: 'Frontend Developer',
                      workType: 'Full Time',
                      level: 'Senior',
                      email: 'suyogluitel235@gmail.com',
                      phone: '9815007509',
                      location: 'Anamnagar, Kathmandu',
                      joinDate: 'Joined Feb, 2024',
                      avatarColor: Colors.teal,
                      isOnline: true,
                    ),
                    TeamMemberCard(
                      initials: 'JM',
                      name: 'Pawan Magar',
                      role: 'Backend Developer',
                      workType: 'Part Time',
                      level: 'Junior',
                      email: 'pawan.magar@gmail.com',
                      phone: '9876543212',
                      location: 'Baneshwor, Kathmandu',
                      joinDate: 'Joined June, 2024',
                      avatarColor: Colors.teal,
                      isOnline: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String initials;
  final String name;
  final String role;
  final String workType;
  final String level;
  final String email;
  final String phone;
  final String location;
  final String joinDate;
  final Color avatarColor;
  final bool isOnline;

  const TeamMemberCard({
    super.key,
    required this.initials,
    required this.name,
    required this.role,
    required this.workType,
    required this.level,
    required this.email,
    required this.phone,
    required this.location,
    required this.joinDate,
    required this.avatarColor,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
          // Header with avatar and basic info
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: avatarColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: avatarColor,
                        ),
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    workType,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
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
              _buildInfoRow(Icons.email_outlined, email),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.phone_outlined, phone),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on_outlined, location),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_today_outlined, joinDate),
            ],
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchEmail(email),
                  icon: const Icon(Icons.email_outlined, size: 15),
                  label: const Text('Email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
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
                  onPressed: () => _launchPhone(phone),
                  icon: const Icon(Icons.local_phone_outlined, size: 15),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
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
