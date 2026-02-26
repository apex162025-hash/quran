class ApiPaths {
  static const String baseUrl = stagingUrl;
  static const String stagingUrl = "https://panel.tordoo-stage.com/api/qr/v1/";
  static const String productionUrl = "https://panel.tordoo.com/api/qr/v1/";

  ///////////////////////////////////////////////////////////////////////

  static const String login = 'login';
  static const String userProfile = 'me';
  static const String merchantProfile = 'merchant/me';
  static const String companyProfile = 'company/me';
  static const String logoutCompany = 'company/logout';
  static const String logoutMerchant = 'merchant/logout';
  static const String merchantOrders = 'merchant/orders';
  static const String companyOrders = 'company/orders';
  static const String scanQrMerchant = 'merchant/orders/scan-qr';
  static const String scanQrCompany = 'company/orders/scan-qr';

  static String confirmReceived(String userType, int id) => '$userType/orders/$id/confirm-received';
  static String linkQr(String userType, int id) => '$userType/orders/$id/link-qr';

  static const String sharedPages = 'shared/pages';

  static const String deleteAccountMerchant = 'merchant/delete-account';
  static const String deleteAccountCompany = 'company/delete-account';
}
