import 'dart:convert';
import 'package:equatable/equatable.dart';

import '../../../logic/cubit/terms_and_policy/terms_and_policy_state.dart';

class TermsConditionsModel extends Equatable {
  final int id;
  final int jobPostId;
  final String title;
  final String langCode;
  final String description;
  final String createdAt;
  final String updatedAt;
  final TermsAndPolicyState termState;
  const TermsConditionsModel({
    this.id = 0,
    this.jobPostId = 0,
    this.title = '',
    this.langCode = '',
    this.description = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.termState = const TermsAndPolicyInitial(),
  });


  TermsConditionsModel copyWith({
    int? id,
    String? langCode,
    int? jobPostId,
    String? title,
    String? description,
    String? createdAt,
    String? updatedAt,
    TermsAndPolicyState? termState,
  }) {
    return TermsConditionsModel(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      title: title ?? this.title,
      langCode: langCode ?? this.langCode,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      termState: termState ?? this.termState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lang_code': langCode,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory TermsConditionsModel.fromMap(Map<String, dynamic> map) {
    return TermsConditionsModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      langCode: map['lang_code'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TermsConditionsModel.fromJson(String source) => TermsConditionsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  // static TermsConditionsModel init(){
  //   return TermsConditionsModel(
  //     id ,
  //     langCode ,
  //     description ,
  //     createdAt ,
  //     updatedAt ,
  //     termState ,
  //   );
  // }

  @override
  List<Object> get props {
    return [
      id,
      jobPostId,
      title,
      langCode,
      description,
      createdAt,
      updatedAt,
      termState,
    ];
  }
}
