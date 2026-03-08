import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_assets.dart';

class Strings {
  static const appName = 'Thessford';
  static const appFailure = 'An unknown error occurred';
  static const noInternet =
      'Please check your internet connection and try again';
  static const unknown = 'Something went wrong. Try again.';
}

class HiveStrings {
  static const box1 = 'System';
}

class AppSize {
  static double width = 390.w;
  static double height = 844.h;
}
/*

class SocketMessages {
  static String checking = "checking";
  static String getMessage = "getMessage";
  static String getNewMessage = "getNewMessage";
}
*/

class Lists {
  static List<Map<String, dynamic>> onBoardingData = [
    {
      "image": AssetsOnboarding.onboarding1,
      "title": "Earn by Referring Students",
      "subtitle":
          "Refer students to Thessford Global and earn commissions for every successful enrollment.",
    },
    {
      "image": AssetsOnboarding.onboarding2,
      "title": "Track Every Referal",
      "subtitle": "Monitor referral status from submission to enrollment.",
    },
    {
      "image": AssetsOnboarding.onboarding3,
      "title": "Withdraw Your Earnings",
      "subtitle": "Get paid directly into your bank account",
    },
  ];

  static List<Map<String, dynamic>> navBar = [
    {"icon": AssetsNavBar.home, "label": "Home"},
    {"icon": AssetsNavBar.referral, "label": "Referrals"},
    {"icon": AssetsNavBar.wallet, "label": "Wallet"},
    {"icon": AssetsNavBar.profile, "label": "Profile"},
  ];
}
