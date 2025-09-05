// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class PaymentSettingModel extends Equatable {
  final int stripeStatus;
  final String stripeImage;
  final int stripeCurrencyId;
  final String stripeKey;
  final String stripeSecret;
  final int paypalStatus;
  final String paypalImage;
  final String paypalAccountMode;
  final int paypalCurrencyId;
  final String paypalClientId;
  final String paypalSecretKey;
  final int razorpayStatus;
  final String razorpayImage;
  final int razorpayCurrencyId;
  final String razorpayKey;
  final String razorpaySecret;
  final String razorpayName;
  final String razorpayDescription;
  final String razorpayThemeColor;
  final int flutterwaveStatus;
  final String flutterwaveLogo;
  final int flutterwaveCurrencyId;
  final String flutterwavePublicKey;
  final String flutterwaveSecretKey;
  final String flutterwaveTitle;
  final int mollieStatus;
  final String mollieImage;
  final int mollieCurrencyId;
  final String mollieKey;
  final int paystackStatus;
  final String paystackImage;
  final int paystackCurrencyId;
  final String paystackPublicKey;
  final String paystackSecretKey;
  final int instamojoStatus;
  final String instamojoImage;
  final String instamojoAccountMode;
  final int instamojoCurrencyId;
  final String instamojoApiKey;
  final String instamojoAuthToken;
  final int bankStatus;
  final String bankImage;
  final String bankAccountInfo;
  const PaymentSettingModel({
    required this.stripeStatus,
    required this.stripeImage,
    required this.stripeCurrencyId,
    required this.stripeKey,
    required this.stripeSecret,
    required this.paypalStatus,
    required this.paypalImage,
    required this.paypalAccountMode,
    required this.paypalCurrencyId,
    required this.paypalClientId,
    required this.paypalSecretKey,
    required this.razorpayStatus,
    required this.razorpayImage,
    required this.razorpayCurrencyId,
    required this.razorpayKey,
    required this.razorpaySecret,
    required this.razorpayName,
    required this.razorpayDescription,
    required this.razorpayThemeColor,
    required this.flutterwaveStatus,
    required this.flutterwaveLogo,
    required this.flutterwaveCurrencyId,
    required this.flutterwavePublicKey,
    required this.flutterwaveSecretKey,
    required this.flutterwaveTitle,
    required this.mollieStatus,
    required this.mollieImage,
    required this.mollieCurrencyId,
    required this.mollieKey,
    required this.paystackStatus,
    required this.paystackImage,
    required this.paystackCurrencyId,
    required this.paystackPublicKey,
    required this.paystackSecretKey,
    required this.instamojoStatus,
    required this.instamojoImage,
    required this.instamojoAccountMode,
    required this.instamojoCurrencyId,
    required this.instamojoApiKey,
    required this.instamojoAuthToken,
    required this.bankStatus,
    required this.bankImage,
    required this.bankAccountInfo,
  });

  PaymentSettingModel copyWith({
    int? stripeStatus,
    String? stripeImage,
    int? stripeCurrencyId,
    String? stripeKey,
    String? stripeSecret,
    int? paypalStatus,
    String? paypalImage,
    String? paypalAccountMode,
    int? paypalCurrencyId,
    String? paypalClientId,
    String? paypalSecretKey,
    int? razorpayStatus,
    String? razorpayImage,
    int? razorpayCurrencyId,
    String? razorpayKey,
    String? razorpaySecret,
    String? razorpayName,
    String? razorpayDescription,
    String? razorpayThemeColor,
    int? flutterwaveStatus,
    String? flutterwaveLogo,
    int? flutterwaveCurrencyId,
    String? flutterwavePublicKey,
    String? flutterwaveSecretKey,
    String? flutterwaveTitle,
    int? mollieStatus,
    String? mollieImage,
    int? mollieCurrencyId,
    String? mollieKey,
    int? paystackStatus,
    String? paystackImage,
    int? paystackCurrencyId,
    String? paystackPublicKey,
    String? paystackSecretKey,
    int? instamojoStatus,
    String? instamojoImage,
    String? instamojoAccountMode,
    int? instamojoCurrencyId,
    String? instamojoApiKey,
    String? instamojoAuthToken,
    int? bankStatus,
    String? bankImage,
    String? bankAccountInfo,
  }) {
    return PaymentSettingModel(
      stripeStatus: stripeStatus ?? this.stripeStatus,
      stripeImage: stripeImage ?? this.stripeImage,
      stripeCurrencyId: stripeCurrencyId ?? this.stripeCurrencyId,
      stripeKey: stripeKey ?? this.stripeKey,
      stripeSecret: stripeSecret ?? this.stripeSecret,
      paypalStatus: paypalStatus ?? this.paypalStatus,
      paypalImage: paypalImage ?? this.paypalImage,
      paypalAccountMode: paypalAccountMode ?? this.paypalAccountMode,
      paypalCurrencyId: paypalCurrencyId ?? this.paypalCurrencyId,
      paypalClientId: paypalClientId ?? this.paypalClientId,
      paypalSecretKey: paypalSecretKey ?? this.paypalSecretKey,
      razorpayStatus: razorpayStatus ?? this.razorpayStatus,
      razorpayImage: razorpayImage ?? this.razorpayImage,
      razorpayCurrencyId: razorpayCurrencyId ?? this.razorpayCurrencyId,
      razorpayKey: razorpayKey ?? this.razorpayKey,
      razorpaySecret: razorpaySecret ?? this.razorpaySecret,
      razorpayName: razorpayName ?? this.razorpayName,
      razorpayDescription: razorpayDescription ?? this.razorpayDescription,
      razorpayThemeColor: razorpayThemeColor ?? this.razorpayThemeColor,
      flutterwaveStatus: flutterwaveStatus ?? this.flutterwaveStatus,
      flutterwaveLogo: flutterwaveLogo ?? this.flutterwaveLogo,
      flutterwaveCurrencyId: flutterwaveCurrencyId ?? this.flutterwaveCurrencyId,
      flutterwavePublicKey: flutterwavePublicKey ?? this.flutterwavePublicKey,
      flutterwaveSecretKey: flutterwaveSecretKey ?? this.flutterwaveSecretKey,
      flutterwaveTitle: flutterwaveTitle ?? this.flutterwaveTitle,
      mollieStatus: mollieStatus ?? this.mollieStatus,
      mollieImage: mollieImage ?? this.mollieImage,
      mollieCurrencyId: mollieCurrencyId ?? this.mollieCurrencyId,
      mollieKey: mollieKey ?? this.mollieKey,
      paystackStatus: paystackStatus ?? this.paystackStatus,
      paystackImage: paystackImage ?? this.paystackImage,
      paystackCurrencyId: paystackCurrencyId ?? this.paystackCurrencyId,
      paystackPublicKey: paystackPublicKey ?? this.paystackPublicKey,
      paystackSecretKey: paystackSecretKey ?? this.paystackSecretKey,
      instamojoStatus: instamojoStatus ?? this.instamojoStatus,
      instamojoImage: instamojoImage ?? this.instamojoImage,
      instamojoAccountMode: instamojoAccountMode ?? this.instamojoAccountMode,
      instamojoCurrencyId: instamojoCurrencyId ?? this.instamojoCurrencyId,
      instamojoApiKey: instamojoApiKey ?? this.instamojoApiKey,
      instamojoAuthToken: instamojoAuthToken ?? this.instamojoAuthToken,
      bankStatus: bankStatus ?? this.bankStatus,
      bankImage: bankImage ?? this.bankImage,
      bankAccountInfo: bankAccountInfo ?? this.bankAccountInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    'stripe_status':stripeStatus,
    'stripe_image':stripeImage,
    'stripe_currency_id':stripeCurrencyId,
    'stripe_key':stripeKey,
    'stripe_secret':stripeSecret,
    'paypal_status':paypalStatus,
    'paypal_image':paypalImage,
    'paypal_account_mode':paypalAccountMode,
    'paypal_currency_id':paypalCurrencyId,
    'paypal_client_id':paypalClientId,
    'paypal_secret_key':paypalSecretKey,
    'razorpay_status':razorpayStatus,
    'razorpay_image':razorpayImage,
    'razorpay_currency_id':razorpayCurrencyId,
    'razorpay_key':razorpayKey,
    'razorpay_secret':razorpaySecret,
    'razorpay_name':razorpayName,
    'razorpay_description':razorpayDescription,
    'razorpay_theme_color':razorpayThemeColor,
    'flutterwave_status':flutterwaveStatus,
    'flutterwave_logo':flutterwaveLogo,
    'flutterwave_currency_id':flutterwaveCurrencyId,
    'flutterwave_public_key':flutterwavePublicKey,
    'flutterwave_secret_key':flutterwaveSecretKey,
    'flutterwave_title':flutterwaveTitle,
    'mollie_status':mollieStatus,
    'mollie_image':mollieImage,
    'mollie_currency_id':mollieCurrencyId,
    'mollie_key':mollieKey,
    'paystack_status':paystackStatus,
    'paystack_image':paystackImage,
    'paystack_currency_id':paystackCurrencyId,
    'paystack_public_key':paystackPublicKey,
    'paystack_secret_key':paystackSecretKey,
    'instamojo_status':instamojoStatus,
    'instamojo_image':instamojoImage,
    'instamojo_account_mode':instamojoAccountMode,
    'instamojo_currency_id':instamojoCurrencyId,
    'instamojo_api_key':instamojoApiKey,
    'instamojo_auth_token':instamojoAuthToken,
    'bank_status':bankStatus,
    'bank_image':bankImage,
    'bank_account_info':bankAccountInfo,
    };
  }

  factory PaymentSettingModel.fromMap(Map<String, dynamic> map) {
    return PaymentSettingModel(
      stripeStatus: map['stripe_status'] != null? int.parse(map['stripe_status'].toString()):0,
      stripeImage: map['stripe_image'] ?? '',
      stripeCurrencyId: map['stripe_currency_id'] != null? int.parse(map['stripe_currency_id'].toString()):0,
      stripeKey: map['stripe_key'] ?? '',
      stripeSecret: map['stripe_secret'] ?? '',
      paypalStatus: map['paypal_status'] != null? int.parse(map['paypal_status'].toString()):0,
      paypalImage: map['paypal_image'] ?? '',
      paypalAccountMode: map['paypal_account_mode'] ?? '',
      paypalCurrencyId: map['paypal_currency_id'] != null? int.parse(map['paypal_currency_id'].toString()):0,
      paypalClientId: map['paypal_client_id'] ?? '',
      paypalSecretKey: map['paypal_secret_key'] ?? '',
      razorpayStatus: map['razorpay_status'] != null? int.parse(map['razorpay_status'].toString()):0,
      razorpayImage: map['razorpay_image'] ?? '',
      razorpayCurrencyId: map['razorpay_currency_id'] != null? int.parse(map['razorpay_currency_id'].toString()):0,
      razorpayKey: map['razorpay_key'] ?? '',
      razorpaySecret: map['razorpay_secret'] ?? '',
      razorpayName: map['razorpay_name'] ?? '',
      razorpayDescription: map['razorpay_description'] ?? '',
      razorpayThemeColor: map['razorpay_theme_color'] ?? '',
      flutterwaveStatus: map['flutterwave_status'] != null? int.parse(map['flutterwave_status'].toString()):0,
      flutterwaveLogo: map['flutterwave_logo'] ?? '',
      flutterwaveCurrencyId: map['flutterwave_currency_id'] != null? int.parse(map['flutterwave_currency_id'].toString()):0,
      flutterwavePublicKey: map['flutterwave_public_key'] ?? '',
      flutterwaveSecretKey: map['flutterwave_secret_key'] ?? '',
      flutterwaveTitle: map['flutterwave_title'] ?? '',
      mollieStatus: map['mollie_status'] != null? int.parse(map['mollie_status'].toString()):0,
      mollieImage: map['mollie_image'] ?? '',
      mollieCurrencyId: map['mollie_currency_id'] != null? int.parse(map['mollie_currency_id'].toString()):0,
      mollieKey: map['mollie_key'] ?? '',
      paystackStatus: map['paystack_status'] != null? int.parse(map['paystack_status'].toString()):0,
      paystackImage: map['paystack_image'] ?? '',
      paystackCurrencyId: map['paystack_currency_id'] != null? int.parse(map['paystack_currency_id'].toString()):0,
      paystackPublicKey: map['paystack_public_key'] ?? '',
      paystackSecretKey: map['paystack_secret_key'] ?? '',
      instamojoStatus: map['instamojo_status'] != null? int.parse(map['instamojo_status'].toString()):0,
      instamojoImage: map['instamojo_image'] ?? '',
      instamojoAccountMode: map['instamojo_account_mode'] ?? '',
      instamojoCurrencyId: map['instamojo_currency_id'] != null? int.parse(map['instamojo_currency_id'].toString()):0,
      instamojoApiKey: map['instamojo_api_key'] ?? '',
      instamojoAuthToken: map['instamojo_auth_token'] ?? '',
      bankStatus: map['bank_status'] != null? int.parse(map['bank_status'].toString()):0,
      bankImage: map['bank_image'] ?? '',
      bankAccountInfo: map['bank_account_info'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentSettingModel.fromJson(String source) =>
      PaymentSettingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      stripeStatus,
      stripeImage,
      stripeCurrencyId,
      stripeKey,
      stripeSecret,
      paypalStatus,
      paypalImage,
      paypalAccountMode,
      paypalCurrencyId,
      paypalClientId,
      paypalSecretKey,
      razorpayStatus,
      razorpayImage,
      razorpayCurrencyId,
      razorpayKey,
      razorpaySecret,
      razorpayName,
      razorpayDescription,
      razorpayThemeColor,
      flutterwaveStatus,
      flutterwaveLogo,
      flutterwaveCurrencyId,
      flutterwavePublicKey,
      flutterwaveSecretKey,
      flutterwaveTitle,
      mollieStatus,
      mollieImage,
      mollieCurrencyId,
      mollieKey,
      paystackStatus,
      paystackImage,
      paystackCurrencyId,
      paystackPublicKey,
      paystackSecretKey,
      instamojoStatus,
      instamojoImage,
      instamojoAccountMode,
      instamojoCurrencyId,
      instamojoApiKey,
      instamojoAuthToken,
      bankStatus,
      bankImage,
      bankAccountInfo,
    ];
  }
}
