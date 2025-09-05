import 'dart:convert';

import 'package:equatable/equatable.dart';

class WithdrawModel extends Equatable {
  final int id;
  final int sellerId;
  final int withdrawMethodId;
  final String withdrawMethodName;
  final double totalAmount;
  final double withdrawAmount;
  final double chargeAmount;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  const WithdrawModel({
    required this.id,
    required this.sellerId,
    required this.withdrawMethodId,
    required this.withdrawMethodName,
    required this.totalAmount,
    required this.withdrawAmount,
    required this.chargeAmount,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  WithdrawModel copyWith({
    int? id,
    int? sellerId,
    int? withdrawMethodId,
    String? withdrawMethodName,
    double? totalAmount,
    double? withdrawAmount,
    double? chargeAmount,
    String? description,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return WithdrawModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      withdrawMethodId: withdrawMethodId ?? this.withdrawMethodId,
      withdrawMethodName: withdrawMethodName ?? this.withdrawMethodName,
      totalAmount: totalAmount ?? this.totalAmount,
      withdrawAmount: withdrawAmount ?? this.withdrawAmount,
      chargeAmount: chargeAmount ?? this.chargeAmount,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    'id':id,
    'seller_id':sellerId,
    'withdraw_method_id':withdrawMethodId,
    'withdraw_method_name':withdrawMethodName,
    'total_amount':totalAmount,
    'withdraw_amount':withdrawAmount,
    'charge_amount':chargeAmount,
    'description':description,
    'status':status,
    'created_at':createdAt,
    'updated_at':updatedAt,
    };
  }

  factory WithdrawModel.fromMap(Map<String, dynamic> map) {
    return WithdrawModel(
      id: map['id'] ?? 0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      withdrawMethodId: map['withdraw_method_id'] != null? int.parse(map['withdraw_method_id'].toString()):0,
      withdrawMethodName: map['withdraw_method_name'] ?? '',
      totalAmount: map['total_amount'] != null? double.parse(map['total_amount'].toString()):0.0,
      withdrawAmount: map['withdraw_amount'] != null? double.parse(map['withdraw_amount'].toString()):0.0,
      chargeAmount: map['charge_amount'] != null? double.parse(map['charge_amount'].toString()):0.0,
      description: map['description'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WithdrawModel.fromJson(String source) => WithdrawModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      sellerId,
      withdrawMethodId,
      withdrawMethodName,
      totalAmount,
      withdrawAmount,
      chargeAmount,
      description,
      status,
      createdAt,
      updatedAt,
    ];
  }
}
