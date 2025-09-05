import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order_item_model.dart';

class OrderModel extends Equatable {
  final List<OrderItem>? orders;
  final List<OrderItem>? activeOrders;
  final List<OrderItem>? awaitingOrders;
  final List<OrderItem>? rejectedOrders;
  final List<OrderItem>? cancelOrders;
  final List<OrderItem>? completedOrders;
  const OrderModel({
    required this.orders,
    required this.activeOrders,
    required this.awaitingOrders,
    required this.rejectedOrders,
    required this.cancelOrders,
    required this.completedOrders,
  });

  OrderModel copyWith({
    List<OrderItem>? orders,
    List<OrderItem>? activeOrders,
    List<OrderItem>? awaitingOrders,
    List<OrderItem>? rejectedOrders,
    List<OrderItem>? cancelOrders,
    List<OrderItem>? completedOrders,
  }) {
    return OrderModel(
      orders: orders ?? this.orders,
      activeOrders: activeOrders ?? this.activeOrders,
      awaitingOrders: awaitingOrders ?? this.awaitingOrders,
      rejectedOrders: rejectedOrders ?? this.rejectedOrders,
      cancelOrders: cancelOrders ?? this.cancelOrders,
      completedOrders: completedOrders ?? this.completedOrders,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orders': orders?.map((x) => x.toMap()).toList(),
      'active_orders': activeOrders?.map((x) => x.toMap()).toList(),
      'awaiting_orders': awaitingOrders?.map((x) => x.toMap()).toList(),
      'rejected_orders': rejectedOrders?.map((x) => x.toMap()).toList(),
      'cancel_orders': cancelOrders?.map((x) => x.toMap()).toList(),
      'complete_orders': completedOrders?.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orders: map['orders'] != null ? List<OrderItem>.from((map['orders'] as List<dynamic>).map<OrderItem?>((x) => OrderItem.fromMap(x as Map<String,dynamic>),),) : [],
      activeOrders: map['active_orders'] != null ? List<OrderItem>.from((map['active_orders'] as List<dynamic>).map<OrderItem?>((x) => OrderItem.fromMap(x as Map<String,dynamic>),),) : [],
      awaitingOrders: map['awaiting_orders'] != null ? List<OrderItem>.from((map['awaiting_orders'] as List<dynamic>).map<OrderItem?>((x) => OrderItem.fromMap(x as Map<String,dynamic>),),) : [],
      rejectedOrders: map['rejected_orders'] != null ? List<OrderItem>.from((map['rejected_orders'] as List<dynamic>).map<OrderItem?>((x) => OrderItem.fromMap(x as Map<String,dynamic>),),) : [],
      cancelOrders: map['cancel_orders'] != null ? List<OrderItem>.from((map['cancel_orders'] as List<dynamic>).map<OrderItem?>((x) => OrderItem.fromMap(x as Map<String,dynamic>),),) : [],
      completedOrders: map['complete_orders'] != null ? List<OrderItem>.from((map['complete_orders'] as List<dynamic>).map<OrderItem?>((x) => OrderItem.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      orders,
      activeOrders,
      awaitingOrders,
      rejectedOrders,
      cancelOrders,
      completedOrders,
    ];
  }
}