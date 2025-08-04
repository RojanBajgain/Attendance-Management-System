import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color hexToColor(String? hex) {
  if (hex == null || hex.isEmpty || hex == "#") {
    return Colors.blue; // fallback color
  }

  hex = hex.replaceAll("#", "");
  if (hex.length == 6) hex = "FF$hex";

  try {
    return Color(int.parse("0x$hex"));
  } catch (e) {
    return Colors.blue;
  }
}

String stripHtmlTags(String htmlString) {
  return htmlString.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
}

//backkgrounfd color for vote
Color getBackgroundColor(double pollVotePercentage) {
  if (pollVotePercentage >= 90) {
    return const Color(0xFFD5E7BE);
  } else if (pollVotePercentage >= 80) {
    return const Color(0xB2DCE5CC);
  } else if (pollVotePercentage >= 60) {
    return const Color(0xFFE6E7BE);
  } else if (pollVotePercentage >= 40) {
    return const Color(0xFFE6E7BE);
  } else if (pollVotePercentage >= 20) {
    return const Color(0xFFE7CFBE);
  } else {
    return Colors.grey.shade200;
  }
}

String formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'N/A';
  }
  try {
    DateTime parsedDate = DateTime.parse(dateString);
    return DateFormat('MMM d, yyyy').format(parsedDate);
  } catch (e) {
    return dateString;
  }
}
