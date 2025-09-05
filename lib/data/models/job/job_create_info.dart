import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../home/category_model.dart';
import '../home/job_post.dart';
import '../terms_conditions/terms_conditions.dart';

class JobCreateInfo extends Equatable {
  final List<CategoryModel>? categories;
  final List<CategoryModel>? cities;
  final List<String>? types;

  final JobPostItem ? jobPost;
  final TermsConditionsModel ? jobPostTranslate;
  final String message;

  const JobCreateInfo({
    required this.categories,
    required this.cities,
    required this.types,
    required this.jobPost,
    required this.jobPostTranslate,
    required this.message,
  });

  JobCreateInfo copyWith({
    List<CategoryModel>? categories,
    List<CategoryModel>? cities,
    List<String>? types,
    JobPostItem ? jobPost,
    TermsConditionsModel ? jobPostTranslate,
    String? message,
  }) {
    return JobCreateInfo(
      categories: categories ?? this.categories,
      cities: cities ?? this.cities,
      types: types ?? this.types,
      jobPost: jobPost ?? this.jobPost,
      jobPostTranslate: jobPostTranslate ?? this.jobPostTranslate,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categories': categories?.map((x) => x.toMap()).toList(),
      'cities': cities?.map((x) => x.toMap()).toList(),
      'types': types,
    };
  }

  factory JobCreateInfo.fromMap(Map<String, dynamic> map) {
    return JobCreateInfo(
        categories: map['categories'] != null ? List<CategoryModel>.from((map['categories'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
        cities: map['cities'] != null ? List<CategoryModel>.from((map['cities'] as List<dynamic>).map<CategoryModel?>((x) => CategoryModel.fromMap(x as Map<String,dynamic>),),) : [],
        types: map['job_types'] != null ? List<String>.from((map['job_types'] as List<dynamic>)) : [],
        jobPost: map['job_post'] != null ? JobPostItem .fromMap(map['job_post'] as Map<String,dynamic>) : null,
        jobPostTranslate: map['job_post_translate'] != null ? TermsConditionsModel .fromMap(map['job_post_translate'] as Map<String,dynamic>) : null,
        message: map['message'] ?? '',
    );
  }


  String toJson() => json.encode(toMap());

  factory JobCreateInfo.fromJson(String source) => JobCreateInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [categories, cities, types,jobPost,jobPostTranslate, message];
}

