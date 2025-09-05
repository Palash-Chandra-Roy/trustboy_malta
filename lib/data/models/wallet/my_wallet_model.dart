import 'dart:convert';

import 'package:equatable/equatable.dart';

class MyWallet extends Equatable {
  final int id;
  final int buyerId;
  final double balance;
  final String status;
  final String createdAt;
  final String updatedAt;
  const MyWallet({
    required this.id,
    required this.buyerId,
    required this.balance,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  MyWallet copyWith({
    int? id,
    int? buyerId,
    double? balance,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return MyWallet(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id' : id,
      'buyer_id' : buyerId,
      'balance' : balance,
      'status' : status,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
  }

  factory MyWallet.fromMap(Map<String, dynamic> map) {
    return MyWallet(
      id: map['id'] ?? 0,
      buyerId: map['buyer_id']  != null? int.parse(map['buyer_id'].toString()):0,
      balance: map['balance']  != null? double.parse(map['balance'].toString()):0.0,
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyWallet.fromJson(String source) => MyWallet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      buyerId,
      balance,
      status,
      createdAt,
      updatedAt,
    ];
  }
}