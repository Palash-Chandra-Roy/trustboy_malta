import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../logic/cubit/refund/refund_cubit.dart';
import '../order/order_item_model.dart';

class RefundItem extends Equatable {
  final int id; //
  final int buyerId;
  final int sellerId;
  final int orderId;
  final String note;
  final double refundAmount;
  final String status;
  final String isPayment;
  final String createdAt;//used as file submission
  final String updatedAt;//used as file extension
  final OrderItem? order;
  final BuyerOrderState orderState;
  final bool isListen;
  final RefundState refundState;
  const RefundItem({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.orderId,
    required this.note,
    required this.refundAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isPayment,
    required this.order,
    this.isListen = true,
    this.orderState = const BuyerOrderInitial(),
    this.refundState = const RefundInitial(),
  });

  RefundItem copyWith({
    int? id,
    int? buyerId,
    int? sellerId,
    int? orderId,
    String? note,
    double? refundAmount,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? isPayment,
    bool? isListen,
    OrderItem? order,
    BuyerOrderState? orderState,
    RefundState? refundState,
  }) {
    return RefundItem(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      orderId: orderId ?? this.orderId,
      note: note ?? this.note,
      isPayment: isPayment ?? this.isPayment,
      refundAmount: refundAmount ?? this.refundAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isListen: isListen ?? this.isListen,
      order: order ?? this.order,
      orderState: orderState ?? this.orderState,
      refundState: refundState ?? this.refundState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'buyer_id':buyerId,
      'seller_id':sellerId,
      'order_id':orderId,
      'note':note,
      'refund_amount':refundAmount,
      'status':status,
      'created_at':createdAt,
      'updated_at':updatedAt,
      'order': order?.toMap(),
    };
  }

  factory RefundItem.fromMap(Map<String, dynamic> map) {
    return RefundItem(
      id: map['id'] ?? 0,
      buyerId: map['buyer_id'] != null? int.parse(map['buyer_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      orderId: map['order_id'] != null? int.parse(map['order_id'].toString()):0,
      note: map['note'] ?? '',
      refundAmount: map['refund_amount'] != null? double.parse(map['refund_amount'].toString()):0.0,
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      isPayment: map['payment'] ?? '',
      order: map['order'] != null ? OrderItem.fromMap(map['order'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RefundItem.fromJson(String source) => RefundItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static RefundItem init(){
    return const RefundItem(
      id : 0,
      buyerId : 0,
      sellerId : 0,
      orderId : 0,
      note : '',
      refundAmount : 0,
      status : '',
      isPayment : '',
      createdAt : '',
      updatedAt : '',
      isListen : true,
      order : null,
      orderState : BuyerOrderInitial(),
      refundState : RefundInitial(),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      buyerId,
      sellerId,
      orderId,
      note,
      refundAmount,
      status,
      isPayment,
      createdAt,
      updatedAt,
      order,
      isListen,
      orderState,
      refundState,
    ];
  }
}