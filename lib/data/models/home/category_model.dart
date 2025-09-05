// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:work_zone/presentation/utils/utils.dart';

import '../../../logic/cubit/service_list/service_list_cubit.dart';

class CategoryModel extends Equatable {
  final int id;
  final int categoryId;
  final String name;
  final String slug;
  final String icon;//used as service by category
  final String image;//used as category
  final String city;//used as category
  final String price;//used as category
  int totalService;
  bool isListEmpty;
  List<CategoryModel> categories;
  List<CategoryModel> cities;
  final ServiceListState serviceState;

  CategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,//used as search
    required this.slug,//used as sort_by
    required this.icon,
    required this.image,
    required this.city,
    required this.price,
    this.categories = const <CategoryModel>[],
    this.cities = const <CategoryModel>[],
    this.totalService = 1,
    this.isListEmpty = false,
    this.serviceState = const ServiceListInitial(),
  });

  CategoryModel copyWith({
    int? id,
    int? categoryId,
    String? name,
    String? city,
    String? slug,
    String? icon,
    String? image,
    String? price,
    int? totalService,
    bool? isListEmpty,
    List<CategoryModel>? categories,
    List<CategoryModel>? cities,
    ServiceListState? serviceState,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      city: city ?? this.city,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      cities: cities ?? this.cities,
      totalService: totalService ?? this.totalService,
      isListEmpty: isListEmpty ?? this.isListEmpty,
      serviceState: serviceState ?? this.serviceState,
    );
  }


  Map<String, String> toMap() {
    final result = <String, String>{};

    result.addAll({'search': name});
    result.addAll({'category': Utils.convertToSlug(image)});
    result.addAll({'city':  Utils.convertToSlug(city)});
    result.addAll({'price_filter':  price});
    result.addAll({'sort_by': slug.replaceAll(RegExp(r'\(ASC\)|\(DSC\)'), '').toLowerCase().replaceAll(' ', '_')});
    // result.addAll({'lang_code': icon});

   /* if(categories.isNotEmpty){
      for (int i = 0; i< categories.length; i++) {
        if(categories[i].id != 0){
          result.addAll({'categories[$i]': categories[i].id.toString()});
        }
      }
    }
    if(cities.isNotEmpty){
      for (int i = 0; i< cities.length; i++) {
        if(cities[i].id != 0){
          result.addAll({'cities[$i]': cities[i].id.toString()});
        }
      }
    }*/

    return result;
  }

  Map<String, String> toJobMap() {
    final result = <String, String>{};

    result.addAll({'search': name});
    result.addAll({'category_id': Utils.convertToSlug(image)});
    result.addAll({'city_id':  Utils.convertToSlug(city)});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      categoryId: map['category_id'] != null?int.parse(map['category_id'].toString()):0,
      name: map['name'] ?? "",
      city: map['city'] ?? "",
      slug: map['slug'] ?? "",
      icon: map['icon'] ?? "",
      image: map['image'] ?? "",
      price: map['price'] ?? "",
      totalService: map['totalService'] != null?int.parse(map['totalService'].toString()):0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static CategoryModel init() {
    return  CategoryModel(
      id: 0,
      categoryId: 0,
      name: '',
      city: '',
      slug: '',
      icon: '',
      image: '',
      price: '',
      totalService: 1,
      categories : const <CategoryModel>[],
      cities : const <CategoryModel>[],
      isListEmpty: false,
      serviceState: const ServiceListInitial(),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      categoryId,
      name,
      city,
      slug,
      icon,
      image,
      price,
      totalService,
      isListEmpty,
      categories,
      cities,
      serviceState,
    ];
  }
}
