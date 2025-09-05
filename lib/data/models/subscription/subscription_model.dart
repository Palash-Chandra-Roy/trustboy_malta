import 'dart:convert';

import 'package:equatable/equatable.dart';

class SubscriptionModel extends Equatable {
  final int id;
  final String planName;
  final double planPrice;
  final String expirationDate;
  final int maxListing;
  final int featuredListing;
  final String recommendedSeller;
  final String status;
  final int serial;
  final String createdAt;
  final String updatedAt;
  const SubscriptionModel({
    required this.id,
    required this.planName,
    required this.planPrice,
    required this.expirationDate,
    required this.maxListing,
    required this.featuredListing,
    required this.recommendedSeller,
    required this.status,
    required this.serial,
    required this.createdAt,
    required this.updatedAt,
  });

  SubscriptionModel copyWith({
    int? id,
    String? planName,
    double? planPrice,
    String? expirationDate,
    int? maxListing,
    int? featuredListing,
    String? recommendedSeller,
    String? status,
    int? serial,
    String? createdAt,
    String? updatedAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      planPrice: planPrice ?? this.planPrice,
      expirationDate: expirationDate ?? this.expirationDate,
      maxListing: maxListing ?? this.maxListing,
      featuredListing: featuredListing ?? this.featuredListing,
      recommendedSeller: recommendedSeller ?? this.recommendedSeller,
      status: status ?? this.status,
      serial: serial ?? this.serial,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id' : id,
      'plan_name' : planName,
      'plan_price' : planPrice,
      'expiration_date' : expirationDate,
      'max_listing' : maxListing,
      'featured_listing' : featuredListing,
      'recommended_seller' : recommendedSeller,
      'status' : status,
      'serial' : serial,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] ?? 0,
      planName: map['plan_name'] ?? '',
      planPrice: map['plan_price'] != null? double.parse(map['plan_price'].toString()):0.0,
      expirationDate: map['expiration_date'] ?? '',
      maxListing: map['max_listing'] != null? int.parse(map['max_listing'].toString()):0,
      featuredListing: map['featured_listing'] ?? '',
      recommendedSeller: map['recommended_seller'] ?? '',
      status: map['status'] ?? '',
      serial: map['serial'] != null? int.parse(map['serial'].toString()):0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) => SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      planName,
      planPrice,
      expirationDate,
      maxListing,
      featuredListing,
      recommendedSeller,
      status,
      serial,
      createdAt,
      updatedAt,
    ];
  }
}