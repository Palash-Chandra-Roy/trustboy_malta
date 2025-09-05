// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/payment/payment_cubit.dart';

class CurrenciesModel extends Equatable {
  final int id;//
  final String currencyName;
  final String countryCode;
  final String currencyCode;
  final String currencyIcon;
  final String status;
  final double currencyRate;
  final double rate;
  String isDefault;
  String currencyPosition;
  String createdAt;
  String updatedAt;
  final PaymentState paymentState;

   CurrenciesModel({
    required this.id,
    required this.currencyName,
    required this.countryCode,
    required this.currencyCode,
    required this.currencyIcon,
    required this.currencyRate,
    required this.rate,
    required this.status,
    this.currencyPosition = '',
    this.isDefault = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.paymentState =  const PaymentInitial(),
  });

  CurrenciesModel copyWith({
    int? id,
    String? currencyName,
    String? countryCode,
    String? currencyCode,
    String? currencyIcon,
    String? isDefault,
    double? currencyRate,
    double? rate,
    String? currencyPosition,
    String? status,
    String? createdAt,
    String? updatedAt,
    PaymentState? paymentState,
  }) {
    return CurrenciesModel(
      id: id ?? this.id,
      currencyName: currencyName ?? this.currencyName,
      countryCode: countryCode ?? this.countryCode,
      currencyCode: currencyCode ?? this.currencyCode,
      currencyIcon: currencyIcon ?? this.currencyIcon,
      isDefault: isDefault ?? this.isDefault,
      currencyRate: currencyRate ?? this.currencyRate,
      rate: rate ?? this.rate,
      currencyPosition: currencyPosition ?? this.currencyPosition,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentState: paymentState ?? this.paymentState,
    );
  }


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    if(isDefault.trim().isNotEmpty){
      result.addAll({'card_number': isDefault});
      result.addAll({'month': currencyPosition});
      result.addAll({'year': createdAt});
      result.addAll({'cvc': updatedAt});
    }else{
      result.addAll({'tnx_info': updatedAt});
    }

    return result;
  }

  factory CurrenciesModel.fromMap(Map<String, dynamic> map) {
    return CurrenciesModel(
      id: map['id'] ?? 0,
      currencyName: map['currency_name'] ?? '',
      countryCode: map['country_code'] ?? '',
      currencyCode: map['currency_code'] ?? '',
      currencyIcon: map['currency_icon'] ?? '',
      isDefault: map['is_default'] ?? '',
      currencyRate: map['currency_rate'] != null
          ? double.parse(map['currency_rate'].toString())
          : 0.0,
      rate: map['currency_rate'] != null
          ? double.parse(map['currency_rate'].toString())
          : 0.0,
      currencyPosition: map['currency_position'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrenciesModel.fromJson(String source) =>
      CurrenciesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static CurrenciesModel init(){
    return CurrenciesModel(
      id : 0,
      currencyName : '',
      countryCode : '',
      currencyCode : '',
      currencyIcon : '',
      isDefault : '',
      currencyRate : 0.0,
      rate : 0.0,
      currencyPosition : '',
      status : '',
      createdAt : '',
      updatedAt : '',
      paymentState :  const PaymentInitial(),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      currencyName,
      countryCode,
      currencyCode,
      currencyIcon,
      isDefault,
      currencyRate,
      rate,
      currencyPosition,
      status,
      createdAt,
      updatedAt,
      paymentState,
    ];
  }
}
