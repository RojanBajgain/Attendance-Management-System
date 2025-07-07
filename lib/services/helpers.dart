import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  static Future<void> launchWebsite() async {
    final Uri url = Uri.parse('https://ayata.com.np');
    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // logger.e('Launch failed: $e');
      SSnackbarUtil.showSnackbar(
        'Error',
        'Could not open the website.',
        SnackbarType.error,
      );
    }
  }
}
