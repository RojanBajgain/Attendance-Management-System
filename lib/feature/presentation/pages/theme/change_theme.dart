import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/theme/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({super.key});

  @override
  State<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'Select Theme',
            style: smallStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  "Choose Theme Mode",
                  style: smallStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // for Light Mode
                _buildThemeOption(
                  context: context,
                  title: "Light Mode",
                  icon: Icons.light_mode,
                  themeMode: ThemeMode.light,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // for Dark Mode
                _buildThemeOption(
                  context: context,
                  title: "Dark Mode",
                  icon: Icons.dark_mode,
                  themeMode: ThemeMode.dark,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // for System Default
                _buildThemeOption(
                  context: context,
                  title: "System Default",
                  icon: Icons.settings_suggest,
                  themeMode: ThemeMode.system,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required ThemeMode themeMode,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () => themeController.changeThemeMode(themeMode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? Colors.white30 : Colors.black26,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Obx(() => Radio<ThemeMode>(
                  value: themeMode,
                  groupValue: themeController.currentThemeMode.value,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeController.changeThemeMode(value);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                )),
          ],
        ),
      ),
    );
  }
}
