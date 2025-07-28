import 'package:ams/feature/domain/model/environment.dart';

class ApiUrls {
  static final String baseUrl = Environment.apiBaseUrl;

  static const String login = "api/login/";

  static const String logout = "api/logout/";

  static const String wsUrl = "ws://backend.ams.ayata.com.np/ws/";
  static const String chatmessage = "ws://backend.ams.ayata.com.np/ws/chat/";

  // static const String wsUrl = "ws://tranquility.backend.ams.ayata.com.np/ws/";
  // static const String chatmessage =
  //     "ws://tranquility.backend.ams.ayata.com.np/ws/chat/";

  // static const String register = "auth/register/";

  static const String imageBrand = "api/image/brand/";

  static const String organization = "api/getorganizations/";
  static const String organizationProfile = "api/get-organization-profile/";

  static const String profile = "api/profiles/";
  static const String profiledetail = "api/profiles/";

  static const String updateprofile = "api/profiles/";

  static const String postuseraddress = "api/address/";
  static const String updateaddress = "api/address/";
  static const String getcountry = "api/get_countries/";

  static const String updatedocuments = "api/documents/";
  static const String postnewedocuments = "api/documents/";

  static const String updatebankdetail = "api/bankdetails/";
  static const String postnewbankdetail = "api/bankdetails/";

  static const String deletedocument = "api/documents/";
  static const String deletebankdetails = "api/bankdetails/";

  static const String policydetail = "api/policies/policydetail/";

  static const String leavepolicy = "api/policies/userleavebypolicy/";

  static const String changePassword = "api/smtp/changepassword/";

  static const String payroll = "api/payrolls/payroll/";
  static const String payrolldetail = "api/payrolls/payroll/";

  static const String timeoff = "api/timeoffs/timeoff/";
  static const String posttimeoff = "api/timeoffs/timeoff/";
  static const String reapplytimeoff = "api/timeoffs/timeoff/";

  static const String timesheet = "api/timesheets/attendencelogs/";
  static const String timesheetdetail = "api/timesheets/attendencelogs/";
  static const String buttonTimesheet = "api/timesheets/attendencelogs/";

  static const String notification = "api/inbox/notifications/";

  static const String addremainder = "api/policies/reminder/";

  static const String organizationStaff = "api/get_organization_staff/";

  static const String dashboardtimesheet = "api/dashboard/timesheet/user";

  static const String officelocation = "api/geolocation/office/";

  static const String hasClockedIn =
      "api/timesheets/attendencelogs/hasClockedIn/";

  static const String postclockin =
      "api/timesheets/attendencelogs/postClockIn/";

  static const String postclockout =
      "api/timesheets/attendencelogs/postClockOut/";

  static const String ipaddress = "https://api.ipify.org/?format=json";

  static const String accesspoint = "api/geolocation/check-access-point/";

  static const String onbreak = "api/timesheets/breaktime/start/";
  static const String onresume = "api/timesheets/breaktime/resume/";

  static const String chat = "api/message/chat/";

  // static const String chatmessage = "ws://backend.ams.ayata.com.np/ws/chat/";

  static const String eventpolicy = "api/policies/calender/";

  static const String passwordreset = "api/smtp/password-reset/";

  // static const String token = "";
}
