class RemoteUrls {
  static const String rootUrl = "https://trustboy.com/"; //live url
  //static const String rootUrl = "https://workzone.minionionbd.com/"; //test url

  static const String baseUrl = '${rootUrl}api/';

  static const String homeUrl = baseUrl;

  static String register(String code) =>
      '${baseUrl}store-register?lang_code=$code';
  static const String login = '${baseUrl}store-login';
  static const String websiteSetup = '${baseUrl}website-setup';

  static String changePassword = '${baseUrl}store-reset-password';

  static String logout = '${baseUrl}user/logout';

  static String sendForgetPassword(String code) =>
      '${baseUrl}send-forget-password';

  static String resendRegisterCode(String code) =>
      '${baseUrl}resend-register-code?lang_code=$code';

  static String storeResetPassword = '${baseUrl}store-reset-password';

  static String updatePassword(bool isSeller) {
    if (isSeller) {
      return '${baseUrl}seller/update-password';
    } else {
      return '${baseUrl}buyer/update-password';
    }
  }

  static String submitKyc = '${baseUrl}seller/kyc-submit';

  static String getKycInfo = '${baseUrl}seller/kyc';

  static String userVerification(String code) =>
      '${baseUrl}user-verification?lang_code=$code';

  static String resendVerificationCode = '${baseUrl}resend-register';

  static String getWishList = '${baseUrl}buyer/wishlist';

  static String addToWishList = '${baseUrl}buyer/wishlist';

  static String removeWishList(String id) => '${baseUrl}buyer/wishlist/$id';

  static String serviceDetail(String slug) => '${baseUrl}service/$slug';

  static String sellerDetail(String slug) => '${baseUrl}freelancer/$slug';

  static String jobPostDetail(String slug) => '${baseUrl}job-post/$slug';

  static String serviceList = '${baseUrl}services';

  static String sellerList = '${baseUrl}freelancers';

  static String jobList = '${baseUrl}job-posts';

  static String filterData(String type) {
    if (type == 'service') {
      return '${baseUrl}service-filter-elements';
    } else if (type == 'seller') {
      return '${baseUrl}freelancers-filter-elements';
    } else {
      return '${baseUrl}job-posts-filter-elements';
    }
  }

  static const String getJobPostList = '${baseUrl}buyer/jobpost';

  static const String getJobReqList = '${baseUrl}seller/my-applicants';

  static String applyJobPost(String id) => '${baseUrl}seller/apply-job/$id';

  static String updateJobPost(String id) => '${baseUrl}buyer/jobpost/$id';

  static String editJobPost(String id) => '${baseUrl}buyer/jobpost/$id/edit';

  static const String getCreateJobInfo = '${baseUrl}buyer/jobpost/create';

  static String buyerJobApplicants(String id) =>
      '${baseUrl}buyer/job-post-applicants/$id';

  static String hiredApplicant(String id) =>
      '${baseUrl}buyer/job-application-approval/$id';

  static String buyerJobApproved(String id) =>
      '${baseUrl}buyer/job-application-approval/$id';

  static String accountDelete(bool type) {
    if (type) {
      return '${baseUrl}seller/account-delete';
    } else {
      return '${baseUrl}buyer/account-delete';
    }
  }

  static String orderList(bool type) {
    if (type) {
      return '${baseUrl}seller/orders';
    } else {
      return '${baseUrl}buyer/orders';
    }
  }

  static String buyerOrderDetail(bool type, String id) {
    if (type) {
      return '${baseUrl}seller/order/$id';
    } else {
      return '${baseUrl}buyer/order/$id';
    }
  }

  static String sellerOrderReject(String id) =>
      '${baseUrl}seller/order-rejected/$id';

  static String fileSubmission(String id) =>
      '${baseUrl}seller/order-submission/$id';

  static String refundReq = '${baseUrl}buyer/refund';

  static String orderCancel(bool type, String id) {
    if (type) {
      return '${baseUrl}seller/order-cancel/$id';
      // return '${baseUrl}seller/order-rejected/$id';
    } else {
      return '${baseUrl}buyer/order-cancel/$id';
    }
  }

  static String orderApproved(bool type, String id) {
    if (type) {
      return '${baseUrl}seller/order-approved/$id';
    } else {
      return '${baseUrl}buyer/order-complete/$id';
    }
  }

  static String chatRoute(ChatType type, int chatId) {
    String id = chatId.toString();
    switch (type) {
      case ChatType.buyerChat:
        return '${baseUrl}buyer/livechat';
      case ChatType.sellerChat:
        return '${baseUrl}seller/livechat';
      case ChatType.buyerMsg:
        return '${baseUrl}buyer/get-message-list/$id';
      case ChatType.sellerMsg:
        return '${baseUrl}seller/get-message-list/$id';
      case ChatType.buyerToSeller:
        return '${baseUrl}buyer/store-message';
      case ChatType.sellerToBuyer:
        return '${baseUrl}seller/store-message';
      case ChatType.fromService:
        return '${baseUrl}buyer/store-message-from-service';
    }
  }

  static String walletRoute(WalletType type, int chatId) {
    String id = chatId.toString();
    switch (type) {
      case WalletType.show:
        return '${baseUrl}wallet';
      case WalletType.stripe:
        return '${baseUrl}seller/livechat';
      case WalletType.bank:
        return '${baseUrl}buyer/get-message-list/$id';
    }
  }

  static String walletPayment(WalletPaymentType type) {
    switch (type) {
      case WalletPaymentType.bank:
        return '${rootUrl}wallet-api-payment/bank';
      case WalletPaymentType.stripe:
        return '${rootUrl}wallet-api-payment/stripe-store';
      case WalletPaymentType.molli:
        return '${rootUrl}wallet-api-payment/mollie';
      case WalletPaymentType.razorpay:
        return '${rootUrl}wallet-api-payment/razorpay-webview';
      case WalletPaymentType.flutterWave:
        return '${rootUrl}wallet-api-payment/flutterwave';
      case WalletPaymentType.payStack:
        return '${rootUrl}wallet-api-payment/paystack';
      case WalletPaymentType.instamojo:
        return '${rootUrl}wallet-api-payment/instamojo';
      // return '${rootUrl}wallet-api-payment/instamojo-webview';
      case WalletPaymentType.paypal:
        return '${rootUrl}wallet-api-payment/paypal-webview';
    }
  }

  static String subsRoute(SubsType type, int id) {
    final planId = id.toString();
    switch (type) {
      case SubsType.show:
        return '${rootUrl}seller/subscription-api/plan';
      case SubsType.payInfo:
        return '${rootUrl}seller/subscription-api/payment/pay/$planId';
      case SubsType.freePlan:
        return '${rootUrl}seller/subscription-api/payment/free-enroll/$planId';
      case SubsType.history:
        return '${rootUrl}seller/subscription-api/purchase-history';
      case SubsType.stripe:
        return '${rootUrl}seller/subscription-api/payment/stripe/$planId';
      case SubsType.bank:
        return '${rootUrl}seller/subscription-api/payment/bank/$planId';
      case SubsType.molli:
        return '${rootUrl}seller/subscription-api/payment/mollie-webview/$planId';
      case SubsType.razorpay:
        return '${rootUrl}seller/subscription-api/payment/razorpay-webview/$planId';
      case SubsType.flutterWave:
        return '${rootUrl}seller/subscription-api/payment/flutterwave-webview/$planId';
      case SubsType.instamojo:
        return '${rootUrl}seller/subscription-api/payment/instamojo-webview/$planId';
      case SubsType.payStack:
        return '${rootUrl}seller/subscription-api/payment/paystack-webview/$planId';
      case SubsType.paypal:
        return '${rootUrl}seller/subscription-api/payment/paypal-webview/$planId';
    }
  }

  static String dashboard(bool type) {
    if (type) {
      return '${baseUrl}seller/dashboard';
    } else {
      return '${baseUrl}buyer/dashboard';
    }
  }

  static String updateProfile(bool isSeller) {
    if (isSeller) {
      return '${baseUrl}seller/update-profile';
    } else {
      return '${baseUrl}buyer/update-profile';
    }
  }

  static String profileInfo(bool isSeller) {
    if (isSeller) {
      return '${baseUrl}seller/edit-profile';
    } else {
      return '${baseUrl}buyer/edit-profile';
    }
  }

  static String updateProfileAvatar(bool isSeller) {
    if (isSeller) {
      return '${baseUrl}seller/update-avatar';
    } else {
      return '${baseUrl}buyer/update-avatar';
    }
  }

  static String onlineStatus = '${baseUrl}seller/online-status';

  static String buyerRefunds = '${baseUrl}buyer/refund';

  static String termsConditions = '${baseUrl}terms-conditions';

  static String privacyPolicy = '${baseUrl}privacy-policy';

  static String sellerWithdraw = '${baseUrl}seller/my-withdraw';
  static String sellerMethod = '${baseUrl}seller/my-withdraw/create';
  static String sellerWithdrawDetail(String id) =>
      '${baseUrl}seller/my-withdraw/$id';

  static String paymentInfo(String id, String package) =>
      '${baseUrl}payment/pay/$id/$package';

  static String localPayment(PaymentType type, String id, String package) {
    switch (type) {
      case PaymentType.stripe:
        return '${baseUrl}payment/stripe/$id/$package';
      case PaymentType.bank:
        return '${baseUrl}payment/bank/$id/$package';
      case PaymentType.wallet:
        return '${baseUrl}payment/wallet/$id/$package';
    }
  }

  static String contact(ContactType type) {
    switch (type) {
      case ContactType.contactUs:
        return '${baseUrl}contact-us';
      case ContactType.submitContact:
        return '${baseUrl}store-contact-message';
      case ContactType.faqs:
        return '${baseUrl}faq';
    }
  }

  static String chatFileDownload(String fileName) {
    return '${baseUrl}download-submission-file/$fileName';
  }

  static String imageUrl(String imagePath) {
    if (imagePath.contains("wasabisys.com")) {
      return imagePath;
    }
    return "$rootUrl/public/$imagePath";
  }

  static String services(ServiceType type, int serviceId) {
    final id = serviceId.toString();
    switch (type) {
      case ServiceType.all || ServiceType.create:
        return '${baseUrl}seller/listing';
      case ServiceType.info:
        return '${baseUrl}seller/listing/create';
      case ServiceType.update || ServiceType.serviceDelete:
        return '${baseUrl}seller/listing/$id';
      case ServiceType.edit:
        return '${baseUrl}seller/listing/$id/edit';
      case ServiceType.status:
        return '${baseUrl}seller/listing-status/$id';
      case ServiceType.package:
        return '${baseUrl}seller/store-listing-package/$id';
      case ServiceType.imgAdd:
        return '${baseUrl}seller/upload-image/$id';
      case ServiceType.imgDelete:
        return '${baseUrl}seller/delete-gallery/$id';
      case ServiceType.seo:
        return '${baseUrl}seller/listing-seo/$id';
      case ServiceType.publish:
        return '${baseUrl}seller/listing-publish/$id';
    }
  }

  static String webViewPayment(WebPayType type, String id, String package) {
    // final id = packageId.toString();
    switch (type) {
      case WebPayType.molli:
        return '${rootUrl}payment/mollie-webview/$id/$package';
      case WebPayType.razorpay:
        return '${rootUrl}payment/razorpay-webview/$id/$package';
      case WebPayType.flutterWave:
        return '${rootUrl}payment/flutterwave-webview/$id/$package';
      case WebPayType.instamojo:
        return '${rootUrl}payment/instamojo-webview/$id/$package';
      case WebPayType.payStack:
        return '${rootUrl}payment/paystack-webview/$id/$package';
      case WebPayType.paypal:
        return '${rootUrl}payment/paypal-webview/$id/$package';
    }
  }
}

enum ServiceType {
  all,
  info,
  create,
  edit,
  update,
  package,
  imgAdd,
  imgDelete,
  seo,
  publish,
  serviceDelete,
  status
}

enum WebPayType { razorpay, flutterWave, instamojo, molli, payStack, paypal }

enum PaymentType { stripe, bank, wallet }

enum WalletPaymentType {
  stripe,
  bank,
  razorpay,
  flutterWave,
  molli,
  payStack,
  paypal,
  instamojo
}

enum WalletType { show, stripe, bank }

enum ChatType {
  buyerToSeller,
  sellerToBuyer,
  sellerChat,
  buyerChat,
  fromService,
  buyerMsg,
  sellerMsg
}

enum SubsType {
  show,
  history,
  freePlan,
  payInfo,
  stripe,
  bank,
  razorpay,
  flutterWave,
  molli,
  payStack,
  paypal,
  instamojo
}

enum ContactType { contactUs, submitContact, faqs }
