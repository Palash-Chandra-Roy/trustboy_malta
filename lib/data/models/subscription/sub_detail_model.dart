// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/subscription/subscription_cubit.dart';
import 'subscription_model.dart';

class SubDetailModel extends Equatable {
  final int id;
  final String orderId;
  final int userId;
  final int subscriptionPlanId;
  final String planName;
  final double planPrice;
  final String expirationDate;
  final String expiration;
  final int maxListing;
  final int featuredListing;
  final String recommendedSeller;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String transaction;
  final String createdAt;
  final String updatedAt;
  final SubscriptionModel ? subModel;
  int currentPage;
  bool isEmpty;
  final SubscriptionState subState;
   SubDetailModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.subscriptionPlanId,
    required this.planName,
    required this.planPrice,
    required this.expirationDate,
    required this.expiration,
    required this.maxListing,
    required this.featuredListing,
    required this.recommendedSeller,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transaction,
    required this.createdAt,
    required this.updatedAt,
    this.currentPage = 1,
    this.isEmpty = false,
    this.subModel,
    this.subState = const SubscriptionInitial(),
  });

  SubDetailModel copyWith({
    int? id,
    String? orderId,
    int? userId,
    int? subscriptionPlanId,
    String? planName,
    double? planPrice,
    String? expirationDate,
    String? expiration,
    int? maxListing,
    int? featuredListing,
    String? recommendedSeller,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    String? transaction,
    String? createdAt,
    String? updatedAt,
    int? currentPage,
    bool? isEmpty,
    SubscriptionModel ? subModel,
    SubscriptionState? subState,
  }) {
    return SubDetailModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      planName: planName ?? this.planName,
      planPrice: planPrice ?? this.planPrice,
      expirationDate: expirationDate ?? this.expirationDate,
      expiration: expiration ?? this.expiration,
      maxListing: maxListing ?? this.maxListing,
      featuredListing: featuredListing ?? this.featuredListing,
      recommendedSeller: recommendedSeller ?? this.recommendedSeller,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transaction: transaction ?? this.transaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentPage: currentPage ?? this.currentPage,
      subModel: subModel ?? this.subModel,
      isEmpty: isEmpty ?? this.isEmpty,
      subState: subState ?? this.subState,
    );
  }

 /* Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id' : id,
      'order_id' : orderId,
      'user_id' : userId,
      'subscription_plan_id' : subscriptionPlanId,
      'plan_name' : planName,
      'plan_price' : planPrice,
      'expiration_date' : expirationDate,
      'expiration' : expiration,
      'max_listing' : maxListing,
      'featured_listing' : featuredListing,
      'recommended_seller' : recommendedSeller,
      'status' : status,
      'payment_method' : paymentMethod,
      'payment_status' : paymentStatus,
      'transaction' : transaction,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
  }*/

  Map<String, String> toMap() {

    final result = <String, String>{};

    if(planName == 'stripe'){
      result.addAll({'card_number': paymentMethod});
      result.addAll({'month': transaction});
      result.addAll({'year': status});
      result.addAll({'cvc': updatedAt});
    }else{
      result.addAll({'tnx_info': paymentStatus});
    }

    return result;
  }

  factory SubDetailModel.fromMap(Map<String, dynamic> map) {
    return SubDetailModel(
      id: map['id'] ?? 0,
      orderId: map['order_id'] ?? '',
      userId: map['user_id']  != null? int.parse(map['user_id'].toString()):0,
      subscriptionPlanId: map['subscription_plan_id']  != null? int.parse(map['subscription_plan_id'].toString()):0,
      planName: map['plan_name'] ?? '',
      planPrice: map['plan_price']  != null? double.parse(map['plan_price'].toString()):0.0,
      expirationDate: map['expiration_date'] ?? '',
      expiration: map['expiration'] ?? '',
      maxListing: map['max_listing']  != null? int.parse(map['max_listing'].toString()):0,
      featuredListing: map['featured_listing']  != null? int.parse(map['featured_listing'].toString()):0,
      recommendedSeller: map['recommended_seller'] ?? '',
      status: map['status'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      paymentStatus: map['payment_status'] ?? '',
      transaction: map['transaction'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubDetailModel.fromJson(String source) => SubDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static SubDetailModel init(){
    return SubDetailModel(
      id : 0,
      orderId : '',
      userId : 0,
      subscriptionPlanId : 0,
      planName : '',
      planPrice : 0.0,
      expirationDate : '',
      expiration : '',
      maxListing : 0,
      featuredListing : 0,
      recommendedSeller : '',
      status : '',
      paymentMethod : '',
      paymentStatus : '',
      transaction : '',
      createdAt : '',
      updatedAt : '',
      currentPage : 1,
      isEmpty : false,
      subModel : null,
      subState : const SubscriptionInitial(),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      orderId,
      userId,
      subscriptionPlanId,
      planName,
      planPrice,
      expirationDate,
      expiration,
      maxListing,
      featuredListing,
      recommendedSeller,
      status,
      paymentMethod,
      paymentStatus,
      transaction,
      createdAt,
      updatedAt,
      currentPage,
      isEmpty,
      subModel,
      subState,
    ];
  }
}