// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../home/seller_model.dart';

class ChatModel extends Equatable {
  final int buyerId;
  final int sellerId;
  final int maxId;
  final SellerModel? seller;
  final SellerModel? buyer;
  const ChatModel({
    required this.buyerId,
    required this.sellerId,
    required this.maxId,
    required this.seller,
    required this.buyer,
  });

  ChatModel copyWith({
    int? buyerId,
    int? sellerId,
    int? maxId,
    SellerModel? seller,
    SellerModel? buyer,
  }) {
    return ChatModel(
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      maxId: maxId ?? this.maxId,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'max_id': maxId,
      'seller': seller?.toMap(),
      'buyer': buyer?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      buyerId: map['buyer_id'] != null? int.parse(map['buyer_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      maxId: map['max_id'] != null? int.parse(map['max_id'].toString()):0,
      seller: map['seller'] != null ? SellerModel.fromMap(map['seller'] as Map<String, dynamic>) : null,
      buyer: map['buyer'] != null ? SellerModel.fromMap(map['buyer'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      buyerId,
      sellerId,
      maxId,
      seller,
      buyer,
    ];
  }
}
