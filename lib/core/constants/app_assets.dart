const baseLogoPath = "assets/logo";
const baseImagePngPath = "assets/images/png";

const baseImageSvgPath = "assets/images/svg";
const baseImageNavBarPath = "$baseImageSvgPath/navbar";
const baseImageOnboardingPath = "$baseImageSvgPath/onboarding";
const baseSvgIconsPath = "$baseImageSvgPath/icons";

class AssetsLogo {
  //Logo Images
  static String logoIcon = "$baseLogoPath/star.svg";
}

class AssetsOnboarding {
  //Onboarding Images
  static String onboarding1 = "$baseImageOnboardingPath/onboarding1.svg";
  static String onboarding2 = "$baseImageOnboardingPath/onboarding2.svg";
  static String onboarding3 = "$baseImageOnboardingPath/onboarding3.svg";
}

class AssetsNavBar {
  //Navbar Icons
  static String home = "$baseImageNavBarPath/home.svg";
  static String referral = "$baseImageNavBarPath/referral.svg";
  static String wallet = "$baseImageNavBarPath/wallet.svg";
  static String profile = "$baseImageNavBarPath/profile.svg";
}

class AssetsPngImages {
  //PNG Images
}

class AssetsSvgImages {
  //SVG IMAGES
  static String check = "$baseImageSvgPath/check.svg";
}

class AssetsSvgIcons {
  //SVG ICONS
  static String sun = "$baseSvgIconsPath/sun.svg";
  static String moon = "$baseSvgIconsPath/moon.svg";
  static String search = "$baseSvgIconsPath/search.svg";
  static String google = "$baseSvgIconsPath/google.svg";
  static String facebook = "$baseSvgIconsPath/facebook.svg";
}
