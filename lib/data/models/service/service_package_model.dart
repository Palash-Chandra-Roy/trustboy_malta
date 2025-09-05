import 'dart:convert';

import 'package:equatable/equatable.dart';

class ServicePackageModel extends Equatable {
  final int id;
  final int listingId;
  final String basicName;
  final String basicDescription;
  final double basicPrice;
  final int basicDeliveryDate;
  final int basicRevision;
  final String basicFnWebsite;
  final int basicPage;
  final String basicResponsive;
  final String basicSourceCode;
  final String basicContentUpload;
  final String basicSpeedOptimized;
  final String standardName;
  final String standardDescription;
  final double standardPrice;
  final int standardDeliveryDate;
  final int standardRevision;
  final String standardFnWebsite;
  final int standardPage;
  final String standardResponsive;
  final String standardSourceCode;
  final String standardContentUpload;
  final String standardSpeedOptimized;
  final String premiumName;
  final String premiumDescription;
  final double premiumPrice;
  final int premiumDeliveryDate;
  final int premiumRevision;
  final String premiumFnWebsite;
  final int premiumPage;
  final String premiumResponsive;
  final String premiumSourceCode;
  final String premiumContentUpload;
  final String premiumSpeedOptimized;
  final String createdAt;
  final String updatedAt;
  const ServicePackageModel({
    required this.id,
    required this.listingId,
    required this.basicName,
    required this.basicDescription,
    required this.basicPrice,
    required this.basicDeliveryDate,
    required this.basicRevision,
    required this.basicFnWebsite,
    required this.basicPage,
    required this.basicResponsive,
    required this.basicSourceCode,
    required this.basicContentUpload,
    required this.basicSpeedOptimized,
    required this.standardName,
    required this.standardDescription,
    required this.standardPrice,
    required this.standardDeliveryDate,
    required this.standardRevision,
    required this.standardFnWebsite,
    required this.standardPage,
    required this.standardResponsive,
    required this.standardSourceCode,
    required this.standardContentUpload,
    required this.standardSpeedOptimized,
    required this.premiumName,
    required this.premiumDescription,
    required this.premiumPrice,
    required this.premiumDeliveryDate,
    required this.premiumRevision,
    required this.premiumFnWebsite,
    required this.premiumPage,
    required this.premiumResponsive,
    required this.premiumSourceCode,
    required this.premiumContentUpload,
    required this.premiumSpeedOptimized,
    required this.createdAt,
    required this.updatedAt,
  });

  ServicePackageModel copyWith({
    int? id,
    int? listingId,
    String? basicName,
    String? basicDescription,
    double? basicPrice,
    int? basicDeliveryDate,
    int? basicRevision,
    String? basicFnWebsite,
    int? basicPage,
    String? basicResponsive,
    String? basicSourceCode,
    String? basicContentUpload,
    String? basicSpeedOptimized,
    String? standardName,
    String? standardDescription,
    double? standardPrice,
    int? standardDeliveryDate,
    int? standardRevision,
    String? standardFnWebsite,
    int? standardPage,
    String? standardResponsive,
    String? standardSourceCode,
    String? standardContentUpload,
    String? standardSpeedOptimized,
    String? premiumName,
    String? premiumDescription,
    double? premiumPrice,
    int? premiumDeliveryDate,
    int? premiumRevision,
    String? premiumFnWebsite,
    int? premiumPage,
    String? premiumResponsive,
    String? premiumSourceCode,
    String? premiumContentUpload,
    String? premiumSpeedOptimized,
    String? createdAt,
    String? updatedAt,
  }) {
    return ServicePackageModel(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      basicName: basicName ?? this.basicName,
      basicDescription: basicDescription ?? this.basicDescription,
      basicPrice: basicPrice ?? this.basicPrice,
      basicDeliveryDate: basicDeliveryDate ?? this.basicDeliveryDate,
      basicRevision: basicRevision ?? this.basicRevision,
      basicFnWebsite: basicFnWebsite ?? this.basicFnWebsite,
      basicPage: basicPage ?? this.basicPage,
      basicResponsive: basicResponsive ?? this.basicResponsive,
      basicSourceCode: basicSourceCode ?? this.basicSourceCode,
      basicContentUpload: basicContentUpload ?? this.basicContentUpload,
      basicSpeedOptimized: basicSpeedOptimized ?? this.basicSpeedOptimized,
      standardName: standardName ?? this.standardName,
      standardDescription: standardDescription ?? this.standardDescription,
      standardPrice: standardPrice ?? this.standardPrice,
      standardDeliveryDate: standardDeliveryDate ?? this.standardDeliveryDate,
      standardRevision: standardRevision ?? this.standardRevision,
      standardFnWebsite: standardFnWebsite ?? this.standardFnWebsite,
      standardPage: standardPage ?? this.standardPage,
      standardResponsive: standardResponsive ?? this.standardResponsive,
      standardSourceCode: standardSourceCode ?? this.standardSourceCode,
      standardContentUpload: standardContentUpload ?? this.standardContentUpload,
      standardSpeedOptimized: standardSpeedOptimized ?? this.standardSpeedOptimized,
      premiumName: premiumName ?? this.premiumName,
      premiumDescription: premiumDescription ?? this.premiumDescription,
      premiumPrice: premiumPrice ?? this.premiumPrice,
      premiumDeliveryDate: premiumDeliveryDate ?? this.premiumDeliveryDate,
      premiumRevision: premiumRevision ?? this.premiumRevision,
      premiumFnWebsite: premiumFnWebsite ?? this.premiumFnWebsite,
      premiumPage: premiumPage ?? this.premiumPage,
      premiumResponsive: premiumResponsive ?? this.premiumResponsive,
      premiumSourceCode: premiumSourceCode ?? this.premiumSourceCode,
      premiumContentUpload: premiumContentUpload ?? this.premiumContentUpload,
      premiumSpeedOptimized: premiumSpeedOptimized ?? this.premiumSpeedOptimized,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'listing_id':listingId,
      'basic_name':basicName,
      'basic_description':basicDescription,
      'basic_price':basicPrice,
      'basic_delivery_date':basicDeliveryDate,
      'basic_revision':basicRevision,
      'basic_fn_website':basicFnWebsite,
      'basic_page':basicPage,
      'basic_responsive':basicResponsive,
      'basic_source_code':basicSourceCode,
      'basic_content_upload':basicContentUpload,
      'basic_speed_optimized':basicSpeedOptimized,
      'standard_name':standardName,
      'standard_description':standardDescription,
      'standard_price':standardPrice,
      'standard_delivery_date':standardDeliveryDate,
      'standard_revision':standardRevision,
      'standard_fn_website':standardFnWebsite,
      'standard_page':standardPage,
      'standard_responsive':standardResponsive,
      'standard_source_code':standardSourceCode,
      'standard_content_upload':standardContentUpload,
      'standard_speed_optimized':standardSpeedOptimized,
      'premium_name':premiumName,
      'premium_description':premiumDescription,
      'premium_price':premiumPrice,
      'premium_delivery_date':premiumDeliveryDate,
      'premium_revision':premiumRevision,
      'premium_fn_website':premiumFnWebsite,
      'premium_page':premiumPage,
      'premium_responsive':premiumResponsive,
      'premium_source_code':premiumSourceCode,
      'premium_content_upload':premiumContentUpload,
      'premium_speed_optimized':premiumSpeedOptimized,
      'created_at':createdAt,
      'updated_at':updatedAt,
    };
  }

  factory ServicePackageModel.fromMap(Map<String, dynamic> map) {
    return ServicePackageModel(
      id: map['id'] ?? 0,
      listingId: map['listing_id']!= null? int.parse(map['listing_id'].toString()):0,
      basicName: map['basic_name'] ?? '',
      basicDescription: map['basic_description'] ?? '',
      basicPrice: map['basic_price']!= null? double.parse(map['basic_price'].toString()):0.0,
      basicDeliveryDate: map['basic_delivery_date']!= null? int.parse(map['basic_delivery_date'].toString()):0,
      basicRevision: map['basic_revision']!= null? int.parse(map['basic_revision'].toString()):0,
      basicFnWebsite: map['basic_fn_website'] ?? '',
      basicPage: map['basic_page']!= null? int.parse(map['basic_page'].toString()):0,
      basicResponsive: map['basic_responsive'] ?? '',
      basicSourceCode: map['basic_source_code'] ?? '',
      basicContentUpload: map['basic_content_upload'] ?? '',
      basicSpeedOptimized: map['basic_speed_optimized'] ?? '',
      standardName: map['standard_name'] ?? '',
      standardDescription: map['standard_description'] ?? '',
      standardPrice: map['standard_price']!= null? double.parse(map['standard_price'].toString()):0.0,
      standardDeliveryDate: map['standard_delivery_date']!= null? int.parse(map['standard_delivery_date'].toString()):0,
      standardRevision: map['standard_revision']!= null? int.parse(map['standard_revision'].toString()):0,
      standardFnWebsite: map['standard_fn_website'] ?? '',
      standardPage: map['standard_page']!= null? int.parse(map['standard_page'].toString()):0,
      standardResponsive: map['standard_responsive'] ?? '',
      standardSourceCode: map['standard_source_code'] ?? '',
      standardContentUpload: map['standard_content_upload'] ?? '',
      standardSpeedOptimized: map['standard_speed_optimized'] ?? '',
      premiumName: map['premium_name'] ?? '',
      premiumDescription: map['premium_description'] ?? '',
      premiumPrice: map['premium_price']!= null? double.parse(map['premium_price'].toString()):0.0,
      premiumDeliveryDate: map['premium_delivery_date']!= null? int.parse(map['premium_delivery_date'].toString()):0,
      premiumRevision: map['premium_revision']!= null? int.parse(map['premium_revision'].toString()):0,
      premiumFnWebsite: map['premium_fn_website'] ?? '',
      premiumPage: map['premium_page']!= null? int.parse(map['premium_page'].toString()):0,
      premiumResponsive: map['premium_responsive'] ?? '',
      premiumSourceCode: map['premium_source_code'] ?? '',
      premiumContentUpload: map['premium_content_upload'] ?? '',
      premiumSpeedOptimized: map['premium_speed_optimized'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicePackageModel.fromJson(String source) => ServicePackageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      listingId,
      basicName,
      basicDescription,
      basicPrice,
      basicDeliveryDate,
      basicRevision,
      basicFnWebsite,
      basicPage,
      basicResponsive,
      basicSourceCode,
      basicContentUpload,
      basicSpeedOptimized,
      standardName,
      standardDescription,
      standardPrice,
      standardDeliveryDate,
      standardRevision,
      standardFnWebsite,
      standardPage,
      standardResponsive,
      standardSourceCode,
      standardContentUpload,
      standardSpeedOptimized,
      premiumName,
      premiumDescription,
      premiumPrice,
      premiumDeliveryDate,
      premiumRevision,
      premiumFnWebsite,
      premiumPage,
      premiumResponsive,
      premiumSourceCode,
      premiumContentUpload,
      premiumSpeedOptimized,
      createdAt,
      updatedAt,
    ];
  }
}

