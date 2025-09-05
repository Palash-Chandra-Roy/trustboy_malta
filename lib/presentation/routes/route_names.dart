import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


import '../screens/buyer_screen/more/components/my_job/seller_job_application_screen.dart';
import '../screens/buyer_screen/more/components/my_order/my_order_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/privacy_policy/contact_us_screen.dart';
import '../screens/privacy_policy/faq_screen.dart';
import '../screens/service_screen/seller_service_screen.dart';
import '../screens/user_screen/manage_service/buyer_job_application_screen.dart';
import '../screens/user_screen/user_more/components/my_job/job_application.dart';
import '../screens/wallet/add_balance_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/wallet_payment/subs_bank_payment_screen.dart';
import '../screens/wallet_payment/subs_stripe_payment_screen.dart';
import '../screens/wallet_payment/wallet_bank_payment_screen.dart';
import '../screens/wallet_payment/wallet_stripe_payment_screen.dart';
import '../subscription/subscription_history_screen.dart';
import '../subscription/subscription_payment_info_screen.dart';
import '../subscription/subscription_screen.dart';
import '../widgets/maintain_screen.dart';
import 'route_packages_name.dart';

class RouteNames {
  ///authentication routes
  static const String splashScreen = '/splashScreen';
  static const String onBoardingScreen = '/onBoardingScreen';
  static const String authScreen = '/authenticationScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String updatePasswordScreen = '/updatePasswordScreen';
  static const String verificationScreen = '/verificationScreen';
  static const String successfulScreen = '/successfulScreen';
  static const String mainScreen = '/mainScreen';
  static const String maintainScreen = '/maintainScreen';
  static const String homeScreen = '/homeScreen';
  static const String categoryScreen = '/categoryScreen';
  // static const String buyerMainScreen = '/buyerHomeScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String orderScreen = '/orderScreen';
  static const String buyerSellerOrderScreen = '/buyerSellerOrderScreen';
  static const String orderDetailsScreen = '/orderDetailsScreen';
  static const String sellerJobApplicationScreen = '/sellerJobApplicationScreen';

  /// User Route
  static const String buyerDashboardScreen = '/buyerDashboardScreen';
  static const String buyerSellerOrderDetailsScreen = '/userOrderDetailsScreen';
  static const String buyerJobApplicationScreen = '/buyerJobApplicationScreen';
  static const String jobApplicationScreen = '/jobApplicationScreen';
  static const String createServiceScreen = '/createServiceScreen';

  static const String allServiceScreen = '/allServiceScreen';
  static const String serviceDetailsScreen = '/serviceDetailsScreen';
  static const String allJobScreen = '/allJobScreen';
  static const String sellerDetailsScreen = '/sellerDetailsScreen';
  static const String jobDetailsScreen = '/jobDetailsScreen';
  static const String addJobScreen = '/addJobScreen';


  static const String addUpdateServiceScreen = '/addUpdateServiceScreen';
  static const String sellerServiceScreen = '/sellerServiceScreen';

  ///setting routes
  static const String privacyPolicyScreen = '/privacyPolicyScreen';
  static const String termsConditionScreen = '/termsConditionScreen';
  static const String faqScreen = '/faqScreen';
  static const String contactUsScreen = '/contactUsScreen';
  static const String aboutUsScreen = '/aboutUsScreen';

  ///profile routes
  static const String profileScreen = '/profileScreen';
  static const String updateProfileScreen = '/updateBuyerProfileScreen';
  static const String providerProfileScreen = '/updateShopScreen';
  static const String reviewScreen = '/reviewScreen';
  static const String buyerJobAppliedListScreen = '/buyerJobAppliedListScreen';
  static const String refundScreen = '/refundScreen';
  static const String buyerRefundScreen = '/buyerRefundScreen';
  static const String withdrawScreen = '/withdrawScreen';
  static const String newWithdrawScreen = '/newWithdrawScreen';
  static const String wishlistScreen = '/wishlistScreen';
  static const String buyerPaymentScreen = '/paymentScreen';


  static const String allSellerScreen = '/allSellerScreen';
  static const String kycScreen = '/kycScreen';


  ///payment route
  static const buyerStripePaymentScreen = '/buyerStripePaymentScreen';
  static const String buyerBankPaymentScreen = '/buyerBankPaymentScreen';
  static const String paypalScreen = '/paypalScreen';
  static const String razorpayScreen = '/razorpayScreen';
  static const String flutterWaveScreen = '/flutterWaveScreen';
  static const String molliePaymentScreen = '/molliePaymentScreen';
  static const String instamojoPaymentScreen = '/instamojoPaymentScreen';
  static const String paystackPaymentScreen = '/paystackPaymentScreen';

  static const String chatScreen = '/chatScreen';


  ///wallet route
  static const String addBalanceScreen = '/addBalanceScreen';
  static const String walletScreen = '/walletScreen';
  static const walletStripePaymentScreen = '/walletStripePaymentScreen';
  static const String walletBankPaymentScreen = '/walletBankPaymentScreen';

  ///wallet route
  static const String subsScreen = '/subsScreen';
  static const String subsHistoryScreen = '/subsHistoryScreen';
  static const String subsPaymentInfoScreen = '/subsPaymentInfoScreen';
  static const subsStripePaymentScreen = '/subsStripePaymentScreen';
  static const String subsBankPaymentScreen = '/subsBankPaymentScreen';


  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return PageTransition(
            settings: settings,
            child: const SplashScreen(),
            type: PageTransitionType.fade);

      case RouteNames.onBoardingScreen:
        return PageTransition(
            settings: settings,
            child: const OnBoardingScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.authScreen:
        return PageTransition(
            settings: settings,
            child: const AuthenticationScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.signUpScreen:
        return PageTransition(
            settings: settings,
            child: const SignUpScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.forgotPasswordScreen:
        return PageTransition(
            settings: settings,
            child: const ForgotPasswordScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.updatePasswordScreen:
        return PageTransition(
            settings: settings,
            child: const UpdatePasswordScreen(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.updateProfileScreen:
        return PageTransition(
            settings: settings,
            child: const UpdateProfileScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.verificationScreen:
        final isNew = settings.arguments as bool;
        return PageTransition(
            settings: settings,
            child: OtpVerificationScreen(isNewUser: isNew),
            type: PageTransitionType.rightToLeft);

        case RouteNames.successfulScreen:
        return PageTransition(
            settings: settings,
            child: const SuccessfulScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.changePasswordScreen:
        return PageTransition(
            settings: settings,
            child: const ChangePasswordScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.allSellerScreen:
        return PageTransition(
            settings: settings,
            child: const AllSellersScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.mainScreen:
        return PageTransition(
            settings: settings,
            child: const MainScreen(),
            type: PageTransitionType.rightToLeft);
        case RouteNames.addUpdateServiceScreen:
        return PageTransition(
            settings: settings,
            child: const AddUpdateServiceScreen(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.sellerServiceScreen:
        return PageTransition(
            settings: settings,
            child: const SellerServiceScreen(),
            type: PageTransitionType.rightToLeft);

      // case RouteNames.buyerMainScreen:
      //   return PageTransition(
      //       settings: settings,
      //       child: const BuyerMainScreen(),
      //       type: PageTransitionType.rightToLeft);

      case RouteNames.dashboardScreen:
        return PageTransition(
            settings: settings,
            child: const SellerDashboardScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.homeScreen:
        return PageTransition(
            settings: settings,
            child: const HomeScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.categoryScreen:
        return PageTransition(
            settings: settings,
            child: const CategoryScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.allServiceScreen:
        return PageTransition(
            settings: settings,
            child: const AllServiceScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.orderScreen:
        return PageTransition(
            settings: settings,
            child: const MyOrderScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.orderDetailsScreen:
        return PageTransition(
            settings: settings,
            child: const OrderDetails(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.sellerJobApplicationScreen:
        return PageTransition(
            settings: settings,
            child: const SellerJobApplicationScreen(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.kycScreen:
        return PageTransition(
            settings: settings,
            child: const KycScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.buyerJobAppliedListScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerJobAppliedListScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.refundScreen:
        return PageTransition(
            settings: settings,
            child: const RefundScreen(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.buyerRefundScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerRefundScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.withdrawScreen:
        return PageTransition(
            settings: settings,
            child: const WithdrawScreen(),
            type: PageTransitionType.rightToLeft);
        case RouteNames.newWithdrawScreen:
        return PageTransition(
            settings: settings,
            child: const NewWithdrawScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.wishlistScreen:
        return PageTransition(
            settings: settings,
            child: const WishlistScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.buyerPaymentScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerPaymentScreen(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.buyerStripePaymentScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerStripePaymentScreen(),
            type: PageTransitionType.rightToLeft);
        case RouteNames.buyerBankPaymentScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerBankPaymentScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.buyerDashboardScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerDashboardScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.allJobScreen:
        return PageTransition(
            settings: settings,
            child: const AllJobScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.serviceDetailsScreen:
        // final slug = settings.arguments as String;
        return PageTransition(
            settings: settings,
            child:  const ServiceDetailsScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.sellerDetailsScreen:
        return PageTransition(
            settings: settings,
            child: const SellerDetailsScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.jobDetailsScreen:
        return PageTransition(
            settings: settings,
            child: const JobDetails(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.addJobScreen:
        return PageTransition(
            settings: settings,
            child: const AddJobScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.buyerSellerOrderScreen:
        final isPayment = settings.arguments as String;
        return PageTransition(
            settings: settings,
            child:  BuyerSellerOrderScreen(isPayment:isPayment),
            type: PageTransitionType.rightToLeft);

        case RouteNames.buyerSellerOrderDetailsScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerSellerOrderDetails(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.buyerJobApplicationScreen:
        return PageTransition(
            settings: settings,
            child: const BuyerJobApplicationScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.jobApplicationScreen:
        return PageTransition(
            settings: settings,
            child: const JobApplicationScreen(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.privacyPolicyScreen:
          final type = settings.arguments as String;
        return PageTransition(
            settings: settings,
            child:  PrivacyPolicyScreen(type:type),
            type: PageTransitionType.rightToLeft);
        case RouteNames.contactUsScreen:
        return PageTransition(
            settings: settings,
            child:  ContactUsScreen(),
            type: PageTransitionType.rightToLeft);
        case RouteNames.faqScreen:
        return PageTransition(
            settings: settings,
            child:  FaqScreen(),
            type: PageTransitionType.rightToLeft);


      case RouteNames.paypalScreen:
        final paypalUrl = settings.arguments as Uri;
        return PageTransition(
            settings: settings,
            child:  PaypalScreen(url: paypalUrl),
            type: PageTransitionType.rightToLeft);

      case RouteNames.razorpayScreen:
        final paypalUrl = settings.arguments as Uri;
        return PageTransition(
            settings: settings,
            child:  RazorpayScreen(url: paypalUrl),
            type: PageTransitionType.rightToLeft);

      case RouteNames.flutterWaveScreen:
        final paypalUrl = settings.arguments as Uri;
        return PageTransition(
            settings: settings,
            child:  FlutterWaveScreen(url: paypalUrl),
            type: PageTransitionType.rightToLeft);

      case RouteNames.molliePaymentScreen:
        final paypalUrl = settings.arguments as Uri;
        return PageTransition(
            settings: settings,
            child:  MolliePaymentScreen(url: paypalUrl),
            type: PageTransitionType.rightToLeft);

      case RouteNames.instamojoPaymentScreen:
        final paypalUrl = settings.arguments as Uri;
        return PageTransition(
            settings: settings,
            child:  InstamojoPaymentScreen(url: paypalUrl),
            type: PageTransitionType.rightToLeft);

      case RouteNames.paystackPaymentScreen:
        final paypalUrl = settings.arguments as Uri;
        return PageTransition(
            settings: settings,
            child:  PaystackPaymentScreen(url: paypalUrl),
            type: PageTransitionType.rightToLeft);


        case RouteNames.maintainScreen:
        return PageTransition(
            settings: settings,
            child:  const MaintainScreen(),
            type: PageTransitionType.rightToLeft);

        case RouteNames.chatScreen:
        return PageTransition(
            settings: settings,
            child:  const ChatScreen(),
            type: PageTransitionType.rightToLeft);
        case RouteNames.walletScreen:
        return PageTransition(
            settings: settings,
            child:  const WalletScreen(),
            type: PageTransitionType.rightToLeft);
        case RouteNames.addBalanceScreen:
        return PageTransition(
            settings: settings,
            child:  const AddBalanceScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.walletStripePaymentScreen:
        return PageTransition(
            settings: settings,
            child: const WalletStripePaymentScreen(),
            type: PageTransitionType.rightToLeft);
      case RouteNames.walletBankPaymentScreen:
        return PageTransition(
            settings: settings,
            child: const WalletBankPaymentScreen(),
            type: PageTransitionType.rightToLeft);

      // case RouteNames.walletPaypalScreen:
      //   final paypalUrl = settings.arguments as Uri;
      //   return PageTransition(
      //       settings: settings,
      //       child:  PaypalScreen(url: paypalUrl),
      //       type: PageTransitionType.rightToLeft);
      //
      // case RouteNames.walletRazorpayScreen:
      //   final paypalUrl = settings.arguments as Uri;
      //   return PageTransition(
      //       settings: settings,
      //       child:  RazorpayScreen(url: paypalUrl),
      //       type: PageTransitionType.rightToLeft);
      //
      // case RouteNames.walletFlutterWaveScreen:
      //   final paypalUrl = settings.arguments as Uri;
      //   return PageTransition(
      //       settings: settings,
      //       child:  FlutterWaveScreen(url: paypalUrl),
      //       type: PageTransitionType.rightToLeft);
      //
      // case RouteNames.walletMolliePaymentScreen:
      //   final paypalUrl = settings.arguments as Uri;
      //   return PageTransition(
      //       settings: settings,
      //       child:  MolliePaymentScreen(url: paypalUrl),
      //       type: PageTransitionType.rightToLeft);
      //
      // case RouteNames.walletInstamojoPaymentScreen:
      //   final paypalUrl = settings.arguments as Uri;
      //   return PageTransition(
      //       settings: settings,
      //       child:  InstamojoPaymentScreen(url: paypalUrl),
      //       type: PageTransitionType.rightToLeft);
      //
      // case RouteNames.walletPaystackPaymentScreen:
      //   final paypalUrl = settings.arguments as Uri;
      //   return PageTransition(
      //       settings: settings,
      //       child:  PaystackPaymentScreen(url: paypalUrl),
      //       type: PageTransitionType.rightToLeft);


      case RouteNames.subsScreen:
        return PageTransition(
            settings: settings,
            child:  const SubscriptionScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.subsHistoryScreen:
        return PageTransition(
            settings: settings,
            child:  const SubscriptionHistoryScreen(),
            type: PageTransitionType.rightToLeft);
      case RouteNames.subsPaymentInfoScreen:
        return PageTransition(
            settings: settings,
            child:  const SubscriptionPaymentInfoScreen(),
            type: PageTransitionType.rightToLeft);

      case RouteNames.subsStripePaymentScreen:
        return PageTransition(
            settings: settings,
            child: const SubsStripePaymentScreen(),
            type: PageTransitionType.rightToLeft);
      case RouteNames.subsBankPaymentScreen:
        return PageTransition(
            settings: settings,
            child: const SubsBankPaymentScreen(),
            type: PageTransitionType.rightToLeft);


      default:
        return PageTransition(
          settings: settings,
          child: Scaffold(
            body: FetchErrorText(
                text: 'No Route Found ${settings.name}', textColor: blackColor),
          ),
          type: PageTransitionType.fade,
        );
    }
  }
}
