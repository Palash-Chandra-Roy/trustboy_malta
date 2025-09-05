import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/job_post/job_post_cubit.dart';
import 'seller_model.dart';

class ApplicationModel extends Equatable {
  final int id;// category_id
  final int jobPostId;//city_id
  final int sellerId;//
  final int userId;
  final String description;//description
  final String status;//slug
  final String createdAt;//job_type
  final String updatedAt;//regular price
  final SellerModel? seller;
  final JobPostState postState;

  const ApplicationModel({
    required this.id,
    required this.jobPostId,
    required this.sellerId,
    required this.userId,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.seller,
    this.postState = const JobPostInitial(),
  });

  ApplicationModel copyWith({
    int? id,
    int? jobPostId,
    int? sellerId,
    int? userId,
    String? description,
    String? status,
    String? createdAt,
    String? updatedAt,
    SellerModel? seller,
     JobPostState? postState,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      sellerId: sellerId ?? this.sellerId,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seller: seller ?? this.seller,
      postState: postState ?? this.postState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'job_post_id': jobPostId,
      'seller_id': sellerId,
      'user_id': userId,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'seller': seller?.toMap(),
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'] as int,
      jobPostId: map['job_post_id'] != null? int.parse(map['job_post_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      userId: map['user_id'] != null? int.parse(map['user_id'].toString()):0,
      description: map['description'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      seller: map['seller'] != null ? SellerModel.fromMap(map['seller'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationModel.fromJson(String source) =>
      ApplicationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;


  static ApplicationModel init(){
    return const ApplicationModel(
      id : 0,
      jobPostId : 0,
      sellerId : 0,
      userId : 0,
      description : '',
      status : '',
      createdAt : '',
      updatedAt : '',
      seller : null,
      postState : JobPostInitial(),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      jobPostId,
      sellerId,
      userId,
      description,
      status,
      createdAt,
      updatedAt,
      seller,
      postState,
    ];
  }
}
