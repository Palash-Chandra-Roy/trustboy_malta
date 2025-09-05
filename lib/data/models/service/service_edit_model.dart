import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../home/category_model.dart';
import 'gallery_model.dart';
import 'service_item.dart';
import 'service_package_model.dart';

class ServiceEditInfo extends Equatable {
  final String message;
  final List<CategoryModel>? categories;
  final List<CategoryModel>? subCategories;
  final ServiceItem? listing;
  final GalleryModel? translate;
  final ServicePackageModel? listingPackage;
  final ServicePackageModel? package; // used for package response
  final List<GalleryModel>? galleries;
  const ServiceEditInfo({
    required this.message,
    required this.categories,
    required this.subCategories,
    required this.listing,
    required this.translate,
    required this.listingPackage,
    required this.package,
    required this.galleries,
  });

  ServiceEditInfo copyWith({
    String? message,
    List<CategoryModel>? categories,
    List<CategoryModel>? subCategories,
    ServiceItem? listing,
    GalleryModel? translate,
    ServicePackageModel? listingPackage,
    ServicePackageModel? package,
    List<GalleryModel>? galleries,
  }) {
    return ServiceEditInfo(
      message: message ?? this.message,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      listing: listing ?? this.listing,
      translate: translate ?? this.translate,
      listingPackage: listingPackage ?? this.listingPackage,
      package: package ?? this.package,
      galleries: galleries ?? this.galleries,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'categories': categories?.map((x) => x.toMap()).toList(),
      'sub_categories': subCategories?.map((x) => x.toMap()).toList(),
      'listing': listing?.toMap(),
      'listing_translate': translate?.toMap(),
      'listing_package': listingPackage?.toMap(),
      'package': package?.toMap(),
      'galleries': galleries?.map((x) => x.toMap()).toList(),
    };
  }

  factory ServiceEditInfo.fromMap(Map<String, dynamic> map) {
    return ServiceEditInfo(
      message: map['message'] ?? '',
      categories: map['categories'] != null ? List<CategoryModel>.from((map['categories'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
      subCategories: map['sub_categories'] != null ? List<CategoryModel>.from((map['sub_categories'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
      listing: map['listing'] != null ? ServiceItem.fromMap(map['listing'] as Map<String,dynamic>) : null,
      translate: map['listing_translate'] != null ? GalleryModel.fromMap(map['listing_translate'] as Map<String,dynamic>) : null,
      listingPackage: map['listing_package'] != null ? ServicePackageModel.fromMap(map['listing_package'] as Map<String,dynamic>) : null,
      package: map['package'] != null ? ServicePackageModel.fromMap(map['package'] as Map<String,dynamic>) : null,
      galleries: map['galleries'] != null ? List<GalleryModel>.from((map['galleries'] as List<dynamic>).map<GalleryModel?>((x) => GalleryModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceEditInfo.fromJson(String source) => ServiceEditInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      message,
      categories,
      subCategories,
      listing,
      translate,
      listingPackage,
      package,
      galleries,
    ];
  }
}