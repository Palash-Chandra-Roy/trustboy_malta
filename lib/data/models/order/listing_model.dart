import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../home/category_model.dart';
import '../service/service_package_model.dart';

class ListingModel extends Equatable {
  final int id;
  final int subCategoryId;
  final int sellerId;
  final int categoryId;
  final String thumbImage;
  final String slug;
  final int totalView;
  final double regularPrice;
  final double offerPrice;
  final String isFeatured;
  final String status;
  final String approvedByAdmin;
  final String tags;
  final String seoTitle;
  final String seoDescription;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String description;
  final double avgRating;
  final int totalRating;
  final ServicePackageModel? listingPackage;
  final CategoryModel? category;
  const ListingModel({
    required this.id,
    required this.subCategoryId,
    required this.sellerId,
    required this.categoryId,
    required this.thumbImage,
    required this.slug,
    required this.totalView,
    required this.regularPrice,
    required this.offerPrice,
    required this.isFeatured,
    required this.status,
    required this.approvedByAdmin,
    required this.tags,
    required this.seoTitle,
    required this.seoDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.avgRating,
    required this.totalRating,
    required this.listingPackage,
    required this.category,
  });

  ListingModel copyWith({
    int? id,
    int? subCategoryId,
    int? sellerId,
    int? categoryId,
    String? thumbImage,
    String? slug,
    int? totalView,
    double? regularPrice,
    double? offerPrice,
    String? isFeatured,
    String? status,
    String? approvedByAdmin,
    String? tags,
    String? seoTitle,
    String? seoDescription,
    String? createdAt,
    String? updatedAt,
    String? title,
    String? description,
    double? avgRating,
    int? totalRating,
    ServicePackageModel? listingPackage,
    CategoryModel? category,
  }) {
    return ListingModel(
      id: id ?? this.id,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      sellerId: sellerId ?? this.sellerId,
      categoryId: categoryId ?? this.categoryId,
      thumbImage: thumbImage ?? this.thumbImage,
      slug: slug ?? this.slug,
      totalView: totalView ?? this.totalView,
      regularPrice: regularPrice ?? this.regularPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      approvedByAdmin: approvedByAdmin ?? this.approvedByAdmin,
      tags: tags ?? this.tags,
      seoTitle: seoTitle ?? this.seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      avgRating: avgRating ?? this.avgRating,
      totalRating: totalRating ?? this.totalRating,
      listingPackage: listingPackage ?? this.listingPackage,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'sub_category_id':subCategoryId,
      'seller_id':sellerId,
      'category_id':categoryId,
      'thumb_image':thumbImage,
      'slug':slug,
      'total_view':totalView,
      'regular_price':regularPrice,
      'offer_price':offerPrice,
      'is_featured':isFeatured,
      'status':status,
      'approved_by_admin':approvedByAdmin,
      'tags':tags,
      'seo_title':seoTitle,
      'seo_description':seoDescription,
      'created_at':createdAt,
      'updated_at':updatedAt,
      'title':title,
      'description':description,
      'avg_rating':avgRating,
      'total_rating':totalRating,
      'listing_package': listingPackage?.toMap(),
    };
  }

  factory ListingModel.fromMap(Map<String, dynamic> map) {
    return ListingModel(
      id: map['id'] ?? 0,
      subCategoryId: map['sub_category_id'] != null? int.parse(map['sub_category_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      categoryId: map['category_id'] != null? int.parse(map['category_id'].toString()):0,
      thumbImage: map['thumb_image'] ?? '',
      slug: map['slug'] ?? '',
      totalView: map['total_view'] != null? int.parse(map['total_view'].toString()):0,
      regularPrice: map['regular_price'] != null? double.parse(map['regular_price'].toString()):0.0,
      offerPrice: map['offer_price'] != null? double.parse(map['offer_price'].toString()):0.0,
      isFeatured: map['is_featured'] ?? '',
      status: map['status'] ?? '',
      approvedByAdmin: map['approved_by_admin'] ?? '',
      tags: map['tags'] ?? '',
      seoTitle: map['seo_title'] ?? '',
      seoDescription: map['seo_description'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      avgRating: map['avg_rating'] != null? double.parse(map['avg_rating'].toString()):0.0,
      totalRating: map['total_rating'] != null? int.parse(map['total_rating'].toString()):0,
      listingPackage: map['listing_package'] != null ? ServicePackageModel.fromMap(map['listing_package'] as Map<String,dynamic>) : null,
      category: map['category'] != null ? CategoryModel.fromMap(map['category'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingModel.fromJson(String source) => ListingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      subCategoryId,
      sellerId,
      categoryId,
      thumbImage,
      slug,
      totalView,
      regularPrice,
      offerPrice,
      isFeatured,
      status,
      approvedByAdmin,
      tags,
      seoTitle,
      seoDescription,
      createdAt,
      updatedAt,
      title,
      description,
      avgRating,
      totalRating,
      listingPackage,
      category,
    ];
  }
}