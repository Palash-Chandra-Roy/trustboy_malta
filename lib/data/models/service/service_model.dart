import 'dart:convert';

import 'package:equatable/equatable.dart';
import '/data/models/home/seller_model.dart';

import 'review_model.dart';
import 'service_item.dart';
import 'service_package_model.dart';

class ServiceModel extends Equatable {
  final ServiceItem ? service;
  final ServicePackageModel ? servicePackage;
  final List<ReviewModel> ? galleries;
  final List<ReviewModel> ? reviews;
  final SellerModel ? seller;
  final int totalJobDone;
  final int totalService;
  final int totalRatings;
  final double avgRatings;
  final bool ableToLiveChat;
  final Map<String,ReviewModel>? ratingData;


  final List<ServiceItem> ? sellerService;//used for two times
  final List<ServiceItem> ? activeService;
  final List<ServiceItem> ? pendingService;
  const ServiceModel({
    required this.service,
    required this.sellerService,
    required this.servicePackage,
    required this.seller,
    required this.galleries,
    required this.reviews,
    required this.totalJobDone,
    required this.totalService,
    required this.totalRatings,
    required this.avgRatings,
    required this.ableToLiveChat,
    required this.ratingData,
    required this.activeService,
    required this.pendingService,
  });

  ServiceModel copyWith({
    ServiceItem ? service,
    List<ServiceItem> ? sellerService,
    List<ServiceItem> ? allServices,
    List<ServiceItem> ? activeService,
    List<ServiceItem> ? pendingService,
    ServicePackageModel ? servicePackage,
    SellerModel ? seller,
    List<ReviewModel> ? galleries,
    List<ReviewModel> ? reviews,
    int? totalJobDone,
    int? totalService,
    int? totalRatings,
    double? avgRatings,
    bool? ableToLiveChat,
    Map<String,ReviewModel>? ratingData,
  }) {
    return ServiceModel(
      service: service ?? this.service,
      sellerService: sellerService ?? this.sellerService,
      activeService: activeService ?? this.activeService,
      pendingService: pendingService ?? this.pendingService,
      servicePackage: servicePackage ?? this.servicePackage,
      seller: seller ?? this.seller,
      galleries: galleries ?? this.galleries,
      reviews: reviews ?? this.reviews,
      totalJobDone: totalJobDone ?? this.totalJobDone,
      totalService: totalService ?? this.totalService,
      totalRatings: totalRatings ?? this.totalRatings,
      avgRatings: avgRatings ?? this.avgRatings,
      ableToLiveChat: ableToLiveChat ?? this.ableToLiveChat,
      ratingData: ratingData ?? this.ratingData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service': service?.toMap(),
      'services': sellerService?.map((x) => x.toMap()).toList(),
      'service_package': servicePackage?.toMap(),
      'seller': seller?.toMap(),
      'galleries': galleries?.map((x) => x.toMap()).toList(),
      'review_list': reviews?.map((x) => x.toMap()).toList(),
      'total_job_done': totalJobDone,
      'total_service': totalService,
      'total_ratings': totalRatings,
      'avg_ratings': avgRatings,
      'able_to_live_chat': ableToLiveChat,
      'rating_data': ratingData,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      service: map['service'] != null ? ServiceItem .fromMap(map['service'] as Map<String,dynamic>) : null,
      servicePackage: map['service_package'] != null ? ServicePackageModel .fromMap(map['service_package'] as Map<String,dynamic>) : null,
      seller: map['seller'] != null ? SellerModel .fromMap(map['seller'] as Map<String,dynamic>) : null,
      sellerService: map['services'] != null ? List<ServiceItem> .from((map['services'] as List<dynamic>).map<ServiceItem ?>((x) => ServiceItem .fromMap(x as Map<String,dynamic>),),) : [],
      activeService: map['active_services'] != null ? List<ServiceItem> .from((map['active_services'] as List<dynamic>).map<ServiceItem ?>((x) => ServiceItem .fromMap(x as Map<String,dynamic>),),) : [],
      pendingService: map['pending_services'] != null ? List<ServiceItem> .from((map['pending_services'] as List<dynamic>).map<ServiceItem ?>((x) => ServiceItem .fromMap(x as Map<String,dynamic>),),) : [],
      galleries: map['galleries'] != null ? List<ReviewModel> .from((map['galleries'] as List<dynamic>).map<ReviewModel ?>((x) => ReviewModel .fromMap(x as Map<String,dynamic>),),) : [],
      reviews: map['review_list'] != null ? List<ReviewModel> .from((map['review_list'] as List<dynamic>).map<ReviewModel ?>((x) => ReviewModel .fromMap(x as Map<String,dynamic>),),) : [],
      totalJobDone: map['total_job_done'] != null? int.parse(map['total_job_done'].toString()):0,
      totalService: map['total_service'] != null? int.parse(map['total_service'].toString()):0,
      totalRatings: map['total_ratings'] != null? int.parse(map['total_ratings'].toString()):0,
      avgRatings: map['avg_ratings'] != null? double.parse(map['avg_ratings'].toString()):0.0,
      ableToLiveChat: map['able_to_live_chat'] ?? false,
      ratingData: map['rating_data'] != null ? (map['rating_data'] as Map<String, dynamic>).map((key, value) => MapEntry(key, ReviewModel.fromMap(value)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceModel.fromJson(String source) => ServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      service,
      sellerService,
      activeService,
      pendingService,
      servicePackage,
      seller,
      galleries,
      reviews,
      totalJobDone,
      totalService,
      totalRatings,
      avgRatings,
      ableToLiveChat,
      ratingData,
    ];
  }
}