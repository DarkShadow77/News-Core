class AuthUrl {
  static const String login = "public/admin/login.php";
  static const String changePassword = "public/admin/change-password.php";
}

class DashboardUrl {
  static const String getOverview = "public/admin/dashboard.php";
}

class UserUrl {
  static const String getAllUser = "public/admin/users.php";
  static const String deleteUser = "public/admin/delete-user.php";
  static const String updateUserStatus = "public/admin/update_user_status.php";
}

class ReferralUrl {
  static const String getAllReferrals = "public/admin/all_referals.php";
  static const String updateCommission = "public/admin/update_commission.php";
  static const String updateCommissionStatus =
      "public/admin/update_comm_stat.php";
  static const String deleteReferral = "public/admin/delete-referral.php";
  static const String updateReferralAppStatus =
      "public/admin/update_app_status.php";
  static const String updateEnrollStatus =
      "public/admin/update-enroll-status.php";
}

class WalletUrl {
  static const String getAllTransaction = "public/admin/all_transactions.php";
  static const String updateTransactionStatus =
      "public/admin/update-transaction.php";
}

class AdminUrl {
  static const String getAllAdmin = "public/admin/admin.php";
  static const String addAdmin = "public/admin/add_admin.php";
  static const String deleteAdmin = "public/admin/delete_admin.php";
  static const String updateAdminStatus =
      "public/admin/update_admin_status.php";
}
