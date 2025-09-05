import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../payment/payment_setting_model.dart';
import 'my_wallet_model.dart';
import 'wallet_transaction_model.dart';

class WalletModel extends Equatable {
  final MyWallet? myWallet;
  final double? currentBalance;
  final double? orderByWallet;
  final List<WalletTransaction?>? walletTransaction;
  final PaymentSettingModel? setting;
  const WalletModel({
    required this.myWallet,
    required this.currentBalance,
    required this.orderByWallet,
    required this.walletTransaction,
    required this.setting,
  });

  WalletModel copyWith({
    MyWallet? myWallet,
    double? currentBalance,
    double? orderByWallet,
    List<WalletTransaction?>? walletTransaction,
    final PaymentSettingModel? setting,
  }) {
    return WalletModel(
      myWallet: myWallet ?? this.myWallet,
      currentBalance: currentBalance ?? this.currentBalance,
      orderByWallet: orderByWallet ?? this.orderByWallet,
      walletTransaction: walletTransaction ?? this.walletTransaction,
      setting: setting ?? this.setting,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'my_wallet': myWallet?.toMap(),
      'current_balance': currentBalance,
      'orders_by_wallet': orderByWallet,
      'wallet_transactions': walletTransaction?.map((x) => x?.toMap()).toList(),
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
        myWallet: map['my_wallet'] != null ? MyWallet.fromMap(map['my_wallet'] as Map<String,dynamic>) : null,
        currentBalance: map['current_balance'] != null ? double.parse(map['current_balance'].toString()) : 0.0,
        orderByWallet: map['orders_by_wallet'] != null ? double.parse(map['orders_by_wallet'].toString()) : 0,
        walletTransaction: map['wallet_transactions'] != null ? List<WalletTransaction?>.from((map['wallet_transactions'] as List<dynamic>).map<WalletTransaction?>((x) => WalletTransaction?.fromMap(x as Map<String,dynamic>),),) : [],
        setting: map['payment_setting'] != null ? PaymentSettingModel.fromMap(map['payment_setting'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) => WalletModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [myWallet, currentBalance, orderByWallet, walletTransaction,setting];
}