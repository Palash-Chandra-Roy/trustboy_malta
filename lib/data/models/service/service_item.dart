// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../logic/cubit/service/service_cubit.dart';
import '../../../../presentation/utils/utils.dart';
import '../home/category_model.dart';
import '../home/seller_model.dart';
import 'gallery_model.dart';
import 'review_model.dart';
import 'service_package_model.dart';


class ServiceItem extends Equatable {
  final int id;//used as state id
  final int subCategoryId;
  final int sellerId;//used as tab index
  final int packageTab;//used as tab index
  final int categoryId;
  final String thumbImage;
  final String slug;
  final int totalView;//used for stepper identity
  final double regularPrice;
  final double offerPrice;
  final String isFeatured;
  final String status;
  final String approvedByAdmin;
  final String tags;
  final List<String> tagList;
  final String seoTitle;
  final String seoDescription;
  final String isDraft;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String description;
  final double avgRating;
  final bool havePlan;
  final int totalRating; //used as translate_id
  final SellerModel ? seller;
  final PackageItem ? basic;
  final PackageItem ? standard;
  final PackageItem ? premium;
  final ServicePackageModel ? listing;
  final List<ReviewModel>? reviews;
  final List<CategoryModel>? categories;
  final List<CategoryModel>? subCategories;
  final List<GalleryModel> galleries;
  final ServiceState ? serviceState;
  const ServiceItem({
    required this.id,
    required this.subCategoryId,
    required this.sellerId,
    required this.packageTab,
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
    required this.isDraft,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.avgRating,
    required this.totalRating,
    required this.seller,
    required this.listing,
    required this.reviews,
    required this.havePlan,
     this.basic,
     this.standard,
     this.premium,
    this.tagList = const <String>[],
    this.categories = const <CategoryModel>[],
    this.subCategories = const <CategoryModel>[],
    this.galleries = const <GalleryModel>[],
    this.serviceState = const ServiceInitial(),
  });

  ServiceItem copyWith({
    int? id,
    int? subCategoryId,
    int? sellerId,
    int? packageTab,
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
    List<String>? tagList,
    String? seoTitle,
    String? seoDescription,
    String? isDraft,
    String? createdAt,
    String? updatedAt,
    String? title,
    String? description,
    double? avgRating,
    bool? havePlan,
    int? totalRating,
    SellerModel ? seller,
    PackageItem ? basic,
    PackageItem ? standard,
    PackageItem ? premium,
    ServicePackageModel ? listing,
    List<ReviewModel>? reviews,
    List<CategoryModel>? categories,
    List<CategoryModel>? subCategories,
    List<GalleryModel>? galleries,
    ServiceState ? serviceState,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      sellerId: sellerId ?? this.sellerId,
      packageTab: packageTab ?? this.packageTab,
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
      tagList: tagList ?? this.tagList,
      seoTitle: seoTitle ?? this.seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
      isDraft: isDraft ?? this.isDraft,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      avgRating: avgRating ?? this.avgRating,
      totalRating: totalRating ?? this.totalRating,
      listing: listing ?? this.listing,
      seller: seller ?? this.seller,
      reviews: reviews ?? this.reviews,
      havePlan: havePlan ?? this.havePlan,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      basic: basic ?? this.basic,
      standard: standard ?? this.standard,
      premium: premium ?? this.premium,
      galleries: galleries ?? this.galleries,
      serviceState: serviceState ?? this.serviceState,
    );
  }

  Map<String, String> toMap() {
    final result = <String, String>{};

    if(totalView == 0){
      result.addAll({'title': title});
      result.addAll({'slug': slug});
      result.addAll({'description': description});
      result.addAll({'category_id': categoryId.toString()});
      result.addAll({'sub_category_id': subCategoryId.toString()});
    }else if(totalView == 1){
     /* if(packageTab == 0){
        result.addAll({...basic?.toMap('basic')??{}});
      } else if(packageTab == 1){
        result.addAll({...standard?.toMap('standard')??{}});
      }else{
        result.addAll({...premium?.toMap('premium')??{}});
      }*/

      result.addAll({...basic?.toMap('basic')??{},...standard?.toMap('standard')??{},...premium?.toMap('premium')??{}});


    } else if(totalView == 3){

      List<Map<String, String>> tempLang = [];
      for (var lang in tagList) {
        if (lang.isNotEmpty) {
          tempLang.add({'value': lang});
        }
      }

      String langJson = jsonEncode(tempLang);
      result['tags'] = langJson;
      result.addAll({'seo_title': seoTitle});
      result.addAll({'seo_description': seoDescription});
    }

    if(totalRating != 0){
      result.addAll({'translate_id': totalRating.toString()});
    }


    return result;
  }

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      id: map['id'] ?? 0,
      subCategoryId: map['sub_category_id'] != null? int.parse(map['sub_category_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      packageTab: map['package_id'] != null? int.parse(map['seller_id'].toString()):0,
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
      isDraft: map['is_draft'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      title: map['title'] ?? '',
      havePlan: map['have_plan'] ?? false,
      // description: map['description']??'',// .toString().replaceAll('&lt;','<').replaceAll('&gt;','>'),
      description:  Utils.decodeHtmlEntities(map['description']??''),
      avgRating: map['avg_rating'] != null? double.parse(map['avg_rating'].toString()):0.0,
      totalRating: map['total_rating'] != null? int.parse(map['total_rating'].toString()):0,
      listing: map['listing_package'] != null ? ServicePackageModel .fromMap(map['listing_package'] as Map<String,dynamic>) : null,
      seller: map['seller'] != null ? SellerModel .fromMap(map['seller'] as Map<String,dynamic>) : null,
      reviews: map['reviews'] != null ? List<ReviewModel>.from((map['reviews'] as List<dynamic>).map<ReviewModel?>((x) => ReviewModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceItem.fromJson(String source) => ServiceItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;


  static ServiceItem init(){
    return const ServiceItem(
      id : 0,
      subCategoryId : 0,
      sellerId : 0,
      packageTab : 0,
      categoryId : 0,
      thumbImage : '',
      slug : '',
      totalView : 0,
      regularPrice : 0,
      offerPrice : 0,
      isFeatured : '',
      status : '',
      approvedByAdmin : '',
      tags : '',
      seoTitle : '',
      seoDescription : '',
      isDraft : '',
      createdAt : '',
      updatedAt : '',
      title : '',
      description : '',
      avgRating : 0,
      totalRating : 0,
      havePlan : false,
      listing : null,
      basic : null,
      standard : null,
      premium : null,
      seller : null,
      tagList : <String>[],
      reviews : <ReviewModel>[],
      categories : <CategoryModel>[],
      subCategories : <CategoryModel>[],
      galleries : <GalleryModel>[],
      serviceState : ServiceInitial(),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      subCategoryId,
      sellerId,
      packageTab,
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
      tagList,
      seoTitle,
      seoDescription,
      isDraft,
      createdAt,
      updatedAt,
      title,
      description,
      avgRating,
      totalRating,
      listing,
      havePlan,
      seller,
      reviews,
      basic,
      standard,
      premium,
      categories,
      subCategories,
      galleries,
      serviceState,
    ];
  }
}

class PackageItem extends Equatable {
  String description;
  String price;
  String delivery;
  String revision;
  String website;
  String page;
  String responsive;
  String code;
  String content;
  String optimize;
   PackageItem({
    this.description = '',
    this.price = '',
    this.delivery = '',
    this.revision = '',
    this.website = '',
    this.page = '',
    this.responsive = '',
    this.code = '',
    this.content = '',
    this.optimize = '',
  });

  PackageItem copyWith({
    String? description,
    String? price,
    String? delivery,
    String? revision,
    String? website,
    String? page,
    String? responsive,
    String? code,
    String? content,
    String? optimize,
  }) {
    return PackageItem(
      description: description ?? this.description,
      price: price ?? this.price,
      delivery: delivery ?? this.delivery,
      revision: revision ?? this.revision,
      website: website ?? this.website,
      page: page ?? this.page,
      responsive: responsive ?? this.responsive,
      code: code ?? this.code,
      content: content ?? this.content,
      optimize: optimize ?? this.optimize,
    );
  }

  Map<String, dynamic> toMap(String package) {
    return <String, dynamic>{
      '${package}_description': description,
      '${package}_price': price,
      '${package}_delivery_date': delivery,
      '${package}_revision': revision,
      '${package}_fn_website': website.toLowerCase(),
      '${package}_page': page,
      '${package}_responsive': responsive.toLowerCase(),
      '${package}_source_code': code.toLowerCase(),
      '${package}_content_upload': content.toLowerCase(),
      '${package}_speed_optimized': optimize.toLowerCase(),
    };
  }


  static PackageItem errors(String package){
    return PackageItem(
      description:'${package}_description',
      price:'${package}_price',
      delivery:'${package}_delivery_date',
      revision:'${package}_revision',
      website:'${package}_fn_website',
      page:'${package}_page',
      responsive:'${package}_responsive',
      code:'${package}_source_code',
      content:'${package}_content_upload',
      optimize:'${package}_speed_optimized',
    );
  }

  factory PackageItem.fromMap(Map<String, dynamic> map) {
    return PackageItem(
      description: map['description'] as String,
      price: map['price'] as String,
      delivery: map['delivery'] as String,
      revision: map['revision'] as String,
      website: map['website'] as String,
      page: map['page'] as String,
      responsive: map['responsive'] as String,
      code: map['code'] as String,
      content: map['content'] as String,
      optimize: map['optimize'] as String,
    );
  }

  String toJson() => json.encode(toMap(''));

  factory PackageItem.fromJson(String source) => PackageItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

   /*bool get isValid => [description, price, delivery, revision, website, page, responsive, code, content, optimize]
      .every((element) => element.trim().isNotEmpty);*/

  static bool isValid(PackageItem? item) {

    if (item == null) return false;

    return [
      item.description,
      item.price,
      item.delivery,
      item.revision,
      item.website,
      item.page,
      item.responsive,
      item.code,
      item.content,
      item.optimize,
    ].every((element) => element.trim().isNotEmpty);
  }


  @override
  List<Object> get props {
    return [
      description,
      price,
      delivery,
      revision,
      website,
      page,
      responsive,
      code,
      content,
      optimize,
    ];
  }
}