import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../service/other_model.dart';
import '../service/service_item.dart';
import '../setting/splash_model.dart';
import 'category_model.dart';
import 'job_post.dart';
import 'seller_model.dart';


class HomeModel extends Equatable {
  final OtherModel? introBanner;
  final OtherModel? joinSeller;
  final OtherModel? counter;
  final List<CategoryModel>? categories;
  final List<ServiceItem>? featureService;
  final List<JobPostItem>? jobPost;
  final List<SellerModel>? topSellers;
  final List<SplashModel>? sliders;
  const HomeModel({
    required this.introBanner,
    required this.joinSeller,
    required this.counter,
    required this.categories,
    required this.featureService,
    required this.jobPost,
    required this.topSellers,
    required this.sliders,
  });

  HomeModel copyWith({
    OtherModel? introBanner,
    OtherModel? joinSeller,
    OtherModel? counter,
    List<CategoryModel>? categories,
    List<ServiceItem>? featureService,
    List<JobPostItem>? jobPost,
    List<SellerModel>? topSellers,
    List<SplashModel>? sliders,
  }) {
    return HomeModel(
      introBanner: introBanner ?? this.introBanner,
      joinSeller: joinSeller ?? this.joinSeller,
      counter: counter ?? this.counter,
      categories: categories ?? this.categories,
      featureService: featureService ?? this.featureService,
      jobPost: jobPost ?? this.jobPost,
      topSellers: topSellers ?? this.topSellers,
      sliders: sliders ?? this.sliders,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'intro_banner': introBanner?.toMap(),
      'join_seller': joinSeller?.toMap(),
      'counter': counter?.toMap(),
      'categories': categories?.map((x) => x.toMap()).toList(),
      'featured_services': featureService?.map((x) => x.toMap()).toList(),
      'job_posts': jobPost?.map((x) => x.toMap()).toList(),
      'top_sellers': topSellers?.map((x) => x.toMap()).toList(),
      'sliders': sliders?.map((x) => x.toMap()).toList(),
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      introBanner: map['intro_banner'] != null ? OtherModel.fromMap(map['intro_banner'] as Map<String,dynamic>) : null,
      joinSeller: map['join_seller'] != null ? OtherModel.fromMap(map['join_seller'] as Map<String,dynamic>) : null,
      counter: map['counter'] != null ? OtherModel.fromMap(map['counter'] as Map<String,dynamic>) : null,
      categories: map['categories'] != null ? List<CategoryModel>.from((map['categories'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
      featureService: map['featured_services'] != null ? List<ServiceItem>.from((map['featured_services'] as List<dynamic>).map<ServiceItem?>((x) => ServiceItem.fromMap(x as Map<String,dynamic>),),) : [],
      jobPost: map['job_posts'] != null ? List<JobPostItem>.from((map['job_posts'] as List<dynamic>).map<JobPostItem?>((x) => JobPostItem.fromMap(x as Map<String,dynamic>),),) : null,
      topSellers: map['top_sellers'] != null ? List<SellerModel>.from((map['top_sellers'] as List<dynamic>).map<SellerModel?>((x) => SellerModel.fromMap(x as Map<String,dynamic>),),) : [],
      sliders: map['slider'] != null ? List<SplashModel>.from((map['slider'] as List<dynamic>).map<SplashModel?>((x) => SplashModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) => HomeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      introBanner,
      joinSeller,
      counter,
      categories,
      featureService,
      jobPost,
      topSellers,
      sliders,
    ];
  }
}