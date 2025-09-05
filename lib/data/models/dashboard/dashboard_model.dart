import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../order/order_item_model.dart';
import '../withdraw/withdraw_model.dart';

class DashboardModel extends Equatable {
  final int activeOrders;
  final int completeOrders;
  final int cancelOrders;
  final int rejectedOrders;
  final double totalIncome;
  final double totalCommission;
  final double netIncome;
  final double currentBalance;
  final double totalWithdrawAmount;
  final double pendingWithdraw;
  final List<OrderItem>? orders;
  final List<WithdrawModel>? withdraws;
  const DashboardModel({
    required this.activeOrders,
    required this.completeOrders,
    required this.cancelOrders,
    required this.rejectedOrders,
    required this.totalIncome,
    required this.totalCommission,
    required this.netIncome,
    required this.currentBalance,
    required this.totalWithdrawAmount,
    required this.pendingWithdraw,
    required this.orders,
    required this.withdraws,
  });

  DashboardModel copyWith({
    int? activeOrders,
    int? completeOrders,
    int? cancelOrders,
    int? rejectedOrders,
    double? totalIncome,
    double? totalCommission,
    double? netIncome,
    double? currentBalance,
    double? totalWithdrawAmount,
    double? pendingWithdraw,
    List<OrderItem>? orders,
    List<WithdrawModel>? withdraws,
  }) {
    return DashboardModel(
      activeOrders: activeOrders ?? this.activeOrders,
      completeOrders: completeOrders ?? this.completeOrders,
      cancelOrders: cancelOrders ?? this.cancelOrders,
      rejectedOrders: rejectedOrders ?? this.rejectedOrders,
      totalIncome: totalIncome ?? this.totalIncome,
      totalCommission: totalCommission ?? this.totalCommission,
      netIncome: netIncome ?? this.netIncome,
      currentBalance: currentBalance ?? this.currentBalance,
      totalWithdrawAmount: totalWithdrawAmount ?? this.totalWithdrawAmount,
      pendingWithdraw: pendingWithdraw ?? this.pendingWithdraw,
      orders: orders ?? this.orders,
      withdraws: withdraws ?? this.withdraws,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activeOrders': activeOrders,
      'completeOrders': completeOrders,
      'cancelOrders': cancelOrders,
      'rejectedOrders': rejectedOrders,
      'orders': orders?.map((x) => x.toMap()).toList(),
      'withdraw_list': withdraws?.map((x) => x.toMap()).toList(),
    };
  }

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      activeOrders: map['active_orders'] != null? int.parse(map['active_orders'].toString()):0,
      completeOrders: map['complete_orders'] != null? int.parse(map['complete_orders'].toString()):0,
      cancelOrders: map['cancel_orders'] != null? int.parse(map['cancel_orders'].toString()):0,
      rejectedOrders: map['rejected_orders'] != null? int.parse(map['rejected_orders'].toString()):0,
      totalIncome: map['total_income'] != null? double.parse(map['total_income'].toString()):0.0,
      totalCommission: map['total_commission'] != null? double.parse(map['total_commission'].toString()):0.0,
      netIncome: map['net_income'] != null? double.parse(map['net_income'].toString()):0.0,
      currentBalance: map['current_balance'] != null? double.parse(map['current_balance'].toString()):0.0,
      totalWithdrawAmount: map['total_withdraw_amount'] != null? double.parse(map['total_withdraw_amount'].toString()):0.0,
      pendingWithdraw: map['pending_withdraw'] != null? double.parse(map['pending_withdraw'].toString()):0.0,
      orders: map['orders'] != null ? List<OrderItem>.from((map['orders'] as List<dynamic>).map<OrderItem?>((x) => OrderItem.fromMap(x as Map<String,dynamic>),),) : [],
      withdraws: map['withdraw_list'] != null ? List<WithdrawModel>.from((map['withdraw_list'] as List<dynamic>).map<WithdrawModel?>((x) => WithdrawModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardModel.fromJson(String source) => DashboardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      activeOrders,
      completeOrders,
      cancelOrders,
      rejectedOrders,
      orders,
      totalIncome,
      totalCommission,
      netIncome,
      currentBalance,
      totalWithdrawAmount,
      pendingWithdraw,
      withdraws,
    ];
  }
}