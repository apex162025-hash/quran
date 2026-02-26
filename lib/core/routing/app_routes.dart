import 'package:get/get.dart';
import 'package:tordoo_qr/features/more/peresentation/screens/more_screen.dart';
import 'package:tordoo_qr/features/more/peresentation/screens/profile_screen.dart';
import 'package:tordoo_qr/features/more/peresentation/screens/privacy_policy_screen.dart';
import 'package:tordoo_qr/features/more/peresentation/screens/settings_screen.dart';
import 'package:tordoo_qr/features/more/peresentation/screens/terms_of_use_screen.dart';
import 'package:tordoo_qr/features/more/peresentation/screens/dynamic_page_screen.dart';
import 'package:tordoo_qr/features/more/peresentation/screens/pages_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/scanner/presentation/screens/scanner_screen.dart';
import '../../features/orders/presentation/screens/order_details_screen.dart';
import '../../features/splash/splash_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String mainRoute = '/main';
  static const String authRoute = '/auth';
  static const String loginRoute = '/login';
  static const String moreRoute = '/more';
  static const String scannerRoute = '/scanner';
  static const String profileRoute = '/profile';
  static const String orderDetailsRoute = '/orderDetails';
  static const String settingsRoute = '/settings';
  static const String privacyPolicyRoute = '/privacyPolicy';
  static const String termsOfUseRoute = '/termsOfUse';
  static const String dynamicPageRoute = '/dynamicPage';
  static const String pagesRoute = '/pages';
}

List<GetPage<dynamic>> appPages = [
  GetPage(
    name: Routes.splashRoute,
    page: () => const SplashScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.mainRoute,
    page: () => const MainScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.loginRoute,
    page: () => const LoginScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: Routes.moreRoute,
    page: () => const MoreScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.scannerRoute,
    page: () => const ScannerScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.profileRoute,
    page: () => const ProfileScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.orderDetailsRoute,
    page: () => const OrderDetailsScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.settingsRoute,
    page: () => const SettingsScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.privacyPolicyRoute,
    page: () => const PrivacyPolicyScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.termsOfUseRoute,
    page: () => const TermsOfUseScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.dynamicPageRoute,
    page: () => const DynamicPageScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.pagesRoute,
    page: () => const PagesScreen(),
    transitionDuration: const Duration(milliseconds: 300),
  ),
];
