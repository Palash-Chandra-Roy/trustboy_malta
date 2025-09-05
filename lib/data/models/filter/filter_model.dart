import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../home/category_model.dart';
import '../service/other_model.dart';

class FilterModel extends Equatable {
  final OtherModel? sortBy;
  final OtherModel? priceFilter;
  final String? isTopRated;
  final String? isFeatured;
  final List<CategoryModel>? categories;
  final List<CategoryModel>? subCategories;
  final List<CategoryModel>? cities;
  const FilterModel({
    required this.sortBy,
    required this.priceFilter,
    required this.isTopRated,
    required this.isFeatured,
    required this.categories,
    required this.subCategories,
    required this.cities,
  });

  FilterModel copyWith({
    OtherModel? sortBy,
    OtherModel? priceFilter,
    String? isTopRated,
    String? isFeatured,
    List<CategoryModel>? categories,
    List<CategoryModel>? subCategories,
    List<CategoryModel>? cities,
  }) {
    return FilterModel(
      sortBy: sortBy ?? this.sortBy,
      priceFilter: priceFilter ?? this.priceFilter,
      isTopRated: isTopRated ?? this.isTopRated,
      isFeatured: isFeatured ?? this.isFeatured,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      cities: cities ?? this.cities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sort_by': sortBy?.toMap(),
      'price_filter': priceFilter?.toMap(),
      'is_toprated': isTopRated,
      'is_featured': isFeatured,
      'categories': categories?.map((x) => x.toMap()).toList(),
      'sub_categories': subCategories?.map((x) => x.toMap()).toList(),
      'cities': cities?.map((x) => x.toMap()).toList(),
    };
  }

  factory FilterModel.fromMap(Map<String, dynamic> map) {
    return FilterModel(
      sortBy: map['sort_by'] != null ? OtherModel.fromMap(map['sort_by'] as Map<String,dynamic>) : null,
      priceFilter: map['price_filter'] != null ? OtherModel.fromMap(map['price_filter'] as Map<String,dynamic>) : null,
      isTopRated: map['is_toprated'] ?? '',
      isFeatured: map['is_featured'] ?? '',
      categories: map['categories'] != null ? List<CategoryModel>.from((map['categories'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
      subCategories: map['sub_categories'] != null ? List<CategoryModel>.from((map['sub_categories'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
      cities: map['cities'] != null ? List<CategoryModel>.from((map['cities'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterModel.fromJson(String source) => FilterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      sortBy,
      priceFilter,
      isTopRated,
      categories,
      subCategories,
      cities,
    ];
  }
}