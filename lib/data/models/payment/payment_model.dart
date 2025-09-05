import 'dart:convert';

import 'package:equatable/equatable.dart';


import '../service/service_item.dart';
import '../service/service_package_model.dart';
import '../setting/currencies_model.dart';
import '../subscription/subscription_model.dart';
import 'payment_setting_model.dart';

class PaymentModel extends Equatable {
  final ServicePackageModel? listingPackage;
  final ServiceItem? servicePackage;
  final SubscriptionModel? plan;
  final String packageName;
  final double amount;
  final PaymentSettingModel? setting;
  final CurrenciesModel? razorPayCurrency;
  final CurrenciesModel? flutterWaveCurrency;
  final CurrenciesModel? payStackCurrency;
  const PaymentModel({
    required this.listingPackage,
    required this.servicePackage,
    required this.plan,
    required this.packageName,
    required this.amount,
    required this.setting,
    required this.razorPayCurrency,
    required this.flutterWaveCurrency,
    required this.payStackCurrency,
  });

  PaymentModel copyWith({
    ServicePackageModel? listingPackage,
    ServiceItem? servicePackage,
    SubscriptionModel? plan,
    String? packageName,
    double? amount,
    PaymentSettingModel? setting,
    CurrenciesModel? razorPayCurrency,
    CurrenciesModel? flutterWaveCurrency,
    CurrenciesModel? payStackCurrency,
  }) {
    return PaymentModel(
      listingPackage: listingPackage ?? this.listingPackage,
      servicePackage: servicePackage ?? this.servicePackage,
      plan: plan ?? this.plan,
      packageName: packageName ?? this.packageName,
      amount: amount ?? this.amount,
      setting: setting ?? this.setting,
      razorPayCurrency: razorPayCurrency ?? this.razorPayCurrency,
      flutterWaveCurrency: flutterWaveCurrency ?? this.flutterWaveCurrency,
      payStackCurrency: payStackCurrency ?? this.payStackCurrency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_package': listingPackage?.toMap(),
      'service': servicePackage?.toMap(),
      'package_name': packageName,
      'payable_amount': amount,
      'payment_setting': setting?.toMap(),
      'razorpay_currency': razorPayCurrency?.toMap(),
      'flutterwave_currency': flutterWaveCurrency?.toMap(),
      'paystack_currency': payStackCurrency?.toMap(),
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      listingPackage: map['service_package'] != null ? ServicePackageModel.fromMap(map['service_package'] as Map<String,dynamic>) : null,
      servicePackage: map['service'] != null ? ServiceItem.fromMap(map['service'] as Map<String,dynamic>) : null,
      plan: map['plan'] != null ? SubscriptionModel.fromMap(map['plan'] as Map<String,dynamic>) : null,
      packageName: map['package_name'] ?? '',
      amount: map['payable_amount'] != null? double.parse(map['payable_amount'].toString()):0.0,
      setting: map['payment_setting'] != null ? PaymentSettingModel.fromMap(map['payment_setting'] as Map<String,dynamic>) : null,
      razorPayCurrency: map['razorpay_currency'] != null ? CurrenciesModel.fromMap(map['razorpay_currency'] as Map<String,dynamic>) : null,
      flutterWaveCurrency: map['flutterwave_currency'] != null ? CurrenciesModel.fromMap(map['flutterwave_currency'] as Map<String,dynamic>) : null,
      payStackCurrency: map['paystack_currency'] != null ? CurrenciesModel.fromMap(map['paystack_currency'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) => PaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      listingPackage,
      servicePackage,
      plan,
      packageName,
      amount,
      setting,
      razorPayCurrency,
      flutterWaveCurrency,
      payStackCurrency,
    ];
  }
}
