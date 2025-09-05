import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/wallet/wallet_cubit.dart';

class WalletTransaction extends Equatable {
  final int id;
  final int buyerId;
  final double amount;
  final String paymentGateway;
  final String transactionId;
  final String paymentStatus;//tnx_info
  final String paymentType;//card_number
  final String description;//month
  final String status;//year
  final String createdAt;//amount
  final String updatedAt;//cvc
  final WalletState walletState;
  const WalletTransaction({
    required this.id,
    required this.buyerId,
    required this.amount,
    required this.paymentGateway,
    required this.transactionId,
    required this.paymentStatus,
    required this.paymentType,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.walletState = const WalletInitial(),
  });

  WalletTransaction copyWith({
    int? id,
    int? buyerId,
    double? amount,
    String? paymentGateway,
    String? transactionId,
    String? paymentStatus,
    String? paymentType,
    String? description,
    String? status,
    String? createdAt,
    String? updatedAt,
    WalletState? walletState,
  }) {
    return WalletTransaction(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      amount: amount ?? this.amount,
      paymentGateway: paymentGateway ?? this.paymentGateway,
      transactionId: transactionId ?? this.transactionId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentType: paymentType ?? this.paymentType,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      walletState: walletState ?? this.walletState,
    );
  }


  // final String paymentStatus;//tnx_info
  // final String paymentType;//card_number
  // final String description;//month
  // final String status;//year
  // final String createdAt;//amount
  // final String updatedAt;//cvc

  Map<String, String> toMap() {

    final result = <String, String>{};

    if(paymentGateway == 'stripe'){
      result.addAll({'card_number': paymentType});
      result.addAll({'month': description});
      result.addAll({'year': status});
      result.addAll({'cvc': updatedAt});
    }else{
      result.addAll({'tnx_info': paymentStatus});
    }
    result.addAll({'amount': createdAt});

    return result;
  }

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'] ?? 0,
      buyerId: map['buyer_id'] != null? int.parse(map['buyer_id'].toString()):0,
      amount: map['amount'] != null? double.parse(map['amount'].toString()):0.0,
      paymentGateway: map['payment_gateway'] ?? '',
      transactionId: map['transaction_id'] ?? '',
      paymentStatus: map['payment_status'] ?? '',
      paymentType: map['payment_type'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletTransaction.fromJson(String source) => WalletTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static WalletTransaction init(){
    return WalletTransaction(
      id : 0,
      buyerId : 0,
      amount : 0,
      paymentGateway : '',
      transactionId : '',
      paymentStatus : '',
      paymentType : '',
      description : '',
      status : '',
      createdAt : '',
      updatedAt : '',
      walletState : const WalletInitial(),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      buyerId,
      amount,
      paymentGateway,
      transactionId,
      paymentStatus,
      paymentType,
      description,
      status,
      createdAt,
      updatedAt,
      walletState,
    ];
  }
}