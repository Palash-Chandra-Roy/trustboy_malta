import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../../presentation/utils/utils.dart';
import '../auth/user_response_model.dart';
import 'category_model.dart';
import 'seller_model.dart';

class JobPostModel extends Equatable {
  final JobPostItem ? jobPost;
  final SellerModel ? author;
  final int totalJobByAuthor;
  ///job post
  final List<JobPostItem>? buyerJobPosts;
  final List<JobPostItem>? buyerAwaitJobPosts;
  final List<JobPostItem>? buyerActiveJobPosts;
  final List<JobPostItem>? buyerHiredJobPosts;

///job request
  final List<JobReqItem>? sellerJobsReq;
  final List<JobReqItem>? sellerPendingJobsReq;
  final List<JobReqItem>? sellerRejectedJobsReq;
  final List<JobReqItem>? sellerHiredJobsReq;

  const JobPostModel({
    required this.jobPost,
    required this.author,
    required this.totalJobByAuthor,
    required this.buyerJobPosts,
    required this.buyerAwaitJobPosts,
    required this.buyerActiveJobPosts,
    required this.buyerHiredJobPosts,
    required this.sellerJobsReq,
    required this.sellerPendingJobsReq,
    required this.sellerRejectedJobsReq,
    required this.sellerHiredJobsReq,
  });

  JobPostModel copyWith({
    JobPostItem ? jobPost,
    SellerModel ? author,
    int? totalJobByAuthor,
   List<JobPostItem>? buyerJobPosts,
   List<JobPostItem>? buyerAwaitJobPosts,
   List<JobPostItem>? buyerActiveJobPosts,
   List<JobPostItem>? buyerHiredJobPosts,
    List<JobReqItem>? sellerJobsReq,
   List<JobReqItem>? sellerAwaitJobsReq,
   List<JobReqItem>? sellerActiveJobsReq,
   List<JobReqItem>? sellerHiredJobsReq,
  }) {
    return JobPostModel(
      jobPost: jobPost ?? this.jobPost,
      author: author ?? this.author,
      totalJobByAuthor: totalJobByAuthor ?? this.totalJobByAuthor,
      buyerJobPosts: buyerJobPosts ?? this.buyerJobPosts,
      buyerAwaitJobPosts: buyerAwaitJobPosts ?? this.buyerAwaitJobPosts,
      buyerActiveJobPosts: buyerActiveJobPosts ?? this.buyerActiveJobPosts,
      buyerHiredJobPosts: buyerHiredJobPosts ?? this.buyerHiredJobPosts,
      sellerJobsReq: sellerJobsReq ?? this.sellerJobsReq,
      sellerPendingJobsReq: sellerAwaitJobsReq ?? sellerPendingJobsReq,
      sellerRejectedJobsReq: sellerActiveJobsReq ?? sellerRejectedJobsReq,
      sellerHiredJobsReq: sellerHiredJobsReq ?? this.sellerHiredJobsReq,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobPost': jobPost?.toMap(),
      'author': author?.toMap(),
      'totalJobByAuthor': totalJobByAuthor,
      // 'JobPosts': buyerJobPosts?.map((x) => x.toMap()).toList(),
      // 'AwaitJobPosts': buyerAwaitJobPosts?.map((x) => x.toMap()).toList(),
      // 'ActiveJobPosts': buyerActiveJobPosts?.map((x) => x.toMap()).toList(),
      // 'HiredJobPosts': buyerHiredJobPosts?.map((x) => x.toMap()).toList(),
    };
  }

  factory JobPostModel.fromMap(Map<String, dynamic> map) {
    return JobPostModel(
      jobPost: map['job_post'] != null ? JobPostItem.fromMap(map['job_post'] as Map<String,dynamic>) : null,
      author: map['author'] != null ? SellerModel.fromMap(map['author'] as Map<String,dynamic>) : null,
      totalJobByAuthor: map['total_job_by_author'] != null?  int.parse( map['total_job_by_author'].toString()):0,
      buyerJobPosts: map['job_posts'] != null ? List<JobPostItem>.from((map['job_posts'] as List<dynamic>).map<JobPostItem?>((x) => JobPostItem.fromMap(x as Map<String,dynamic>),),) : [],
      buyerAwaitJobPosts: map['awaiting_job_posts'] != null ? List<JobPostItem>.from((map['awaiting_job_posts'] as List<dynamic>).map<JobPostItem?>((x) => JobPostItem.fromMap(x as Map<String,dynamic>),),) : [],
      buyerActiveJobPosts: map['active_job_posts'] != null ? List<JobPostItem>.from((map['active_job_posts'] as List<dynamic>).map<JobPostItem?>((x) => JobPostItem.fromMap(x as Map<String,dynamic>),),) : [],
      buyerHiredJobPosts: map['hired_job_posts'] != null ? List<JobPostItem>.from((map['hired_job_posts'] as List<dynamic>).map<JobPostItem?>((x) => JobPostItem.fromMap(x as Map<String,dynamic>),),) : [],
      sellerJobsReq: map['job_requests'] != null ? List<JobReqItem>.from((map['job_requests'] as List<dynamic>).map<JobReqItem?>((x) => JobReqItem.fromMap(x as Map<String,dynamic>),),) : [],
      sellerHiredJobsReq: map['hired_job_requests'] != null ? List<JobReqItem>.from((map['hired_job_requests'] as List<dynamic>).map<JobReqItem?>((x) => JobReqItem.fromMap(x as Map<String,dynamic>),),) : [],
      sellerPendingJobsReq: map['pending_job_requests'] != null ? List<JobReqItem>.from((map['pending_job_requests'] as List<dynamic>).map<JobReqItem?>((x) => JobReqItem.fromMap(x as Map<String,dynamic>),),) : [],
      sellerRejectedJobsReq: map['reject_job_requests'] != null ? List<JobReqItem>.from((map['reject_job_requests'] as List<dynamic>).map<JobReqItem?>((x) => JobReqItem.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory JobPostModel.fromJson(String source) => JobPostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [jobPost, author, totalJobByAuthor,buyerJobPosts, buyerAwaitJobPosts, buyerActiveJobPosts, buyerHiredJobPosts,sellerJobsReq,sellerPendingJobsReq,
    sellerRejectedJobsReq,
    sellerHiredJobsReq,];
}

class JobPostItem extends Equatable {
  final int id;
  final int userId;
  final int categoryId;
  final int cityId;//used as applicant_id
  final String thumbImage;
  final String slug;
  final String jobType;
  final int totalView;
  final double regularPrice;
  final String isUrgent; //used as price
  final String status; // used as lang_code
  final String approvedByAdmin;
  final String createdAt;//used as temp image
  final String updatedAt;
  final int totalJobApplication;
  final String title;
  final String description;
  final String checkJobStatus;
  final UserResponse ? author;
  final CategoryModel ? category;
  final CategoryModel ? city;
  final JobPostState postState;
  const JobPostItem({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.cityId,
    required this.thumbImage,
    required this.slug,
    required this.jobType,
    required this.totalView,
    required this.regularPrice,
    required this.isUrgent,
    required this.status,
    required this.approvedByAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.totalJobApplication,
    required this.title,
    required this.description,
    required this.checkJobStatus,
    required this.author,
    required this.category,
    required this.city,
    this.postState = const JobPostInitial(),
  });

  JobPostItem copyWith({
    int? id,
    int? userId,
    int? categoryId,
    int? cityId,
    String? thumbImage,
    String? slug,
    String? jobType,
    int? totalView,
    double? regularPrice,
    String? isUrgent,
    String? status,
    String? approvedByAdmin,
    String? createdAt,
    String? updatedAt,
    int? totalJobApplication,
    String? title,
    String? description,
    String? checkJobStatus,
    UserResponse ? author,
    CategoryModel ? category,
    CategoryModel ? city,
    JobPostState? postState,
  }) {
    return JobPostItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      cityId: cityId ?? this.cityId,
      thumbImage: thumbImage ?? this.thumbImage,
      slug: slug ?? this.slug,
      jobType: jobType ?? this.jobType,
      totalView: totalView ?? this.totalView,
      regularPrice: regularPrice ?? this.regularPrice,
      isUrgent: isUrgent ?? this.isUrgent,
      status: status ?? this.status,
      approvedByAdmin: approvedByAdmin ?? this.approvedByAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalJobApplication: totalJobApplication ?? this.totalJobApplication,
      title: title ?? this.title,
      description: description ?? this.description,
      checkJobStatus: checkJobStatus ?? this.checkJobStatus,
      author: author ?? this.author,
      category: category ?? this.category,
      city: city ?? this.city,
      postState: postState ?? this.postState,
    );
  }

  Map<String, String> toMap() {
    final result = <String, String>{};
    result.addAll({'category_id':categoryId.toString()});
    result.addAll({'city_id':cityId.toString()});
    result.addAll({'slug':slug});
    result.addAll({'job_type':jobType});
    result.addAll({'regular_price':isUrgent});
    result.addAll({'title':title});
    result.addAll({'description':description});
    if(userId != 0){
    result.addAll({'translate_id':userId.toString()});
    result.addAll({'lang_code':status});
    }
    return result;

    //   // 'id':id,
    //   // 'thumb_image':thumbImage,
    //   // 'total_view':totalView,
    //   // 'is_urgent':isUrgent,
    //   // 'status':status,
    //   // 'approved_by_admin':approvedByAdmin,
    //   // 'created_at':createdAt,
    //   // 'updated_at':updatedAt,
    //   // 'total_job_application':totalJobApplication,
    //   // 'check_job_status':checkJobStatus,
    //   // 'author':author?.toMap(),
    //   // 'category':category?.toMap(),
    //   // 'city':city?.toMap(),
  }

  Map<String, String> toApplyMap() {
    final result = <String, String>{};
    result.addAll({'description':description});
    return result;
  }

  factory JobPostItem.fromMap(Map<String, dynamic> map) {
    return JobPostItem(
      id: map['id'] ?? '',
      userId: map['user_id'] != null? int.parse(map['user_id'].toString()):0,
      categoryId: map['category_id'] != null? int.parse(map['category_id'].toString()):0,
      thumbImage: map['thumb_image'] ?? '',
      cityId: map['city_id'] != null? int.parse(map['city_id'].toString()):0,
      slug: map['slug'] ?? '',
      jobType: map['job_type'] ?? '',
      totalView: map['total_view'] != null? int.parse(map['total_view'].toString()):0,
      regularPrice: map['regular_price'] != null? double.parse(map['regular_price'].toString()):0.0,
      isUrgent: map['is_urgent'] ?? '',
      status: map['status'] ?? '',
      approvedByAdmin: map['approved_by_admin'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      totalJobApplication: map['total_job_application'] ?? '',
      title: map['title'] ?? '',
      description: Utils.decodeHtmlEntities(map['description']) ?? '',
      checkJobStatus: map['check_job_status'] ?? '',
      author: map['author'] != null ? UserResponse .fromMap(map['author'] as Map<String,dynamic>) : null,
      category: map['category'] != null ? CategoryModel .fromMap(map['category'] as Map<String,dynamic>) : null,
      city: map['city'] != null ? CategoryModel .fromMap(map['city'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobPostItem.fromJson(String source) => JobPostItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;


  static JobPostItem init(){
    return const JobPostItem(
      id : 0,
      userId : 0,
      categoryId : 0,
      cityId : 0,
      thumbImage : '',
      slug : '',
      jobType : '',
      totalView : 0,
      regularPrice : 0,
      isUrgent : '',
      status : '',
      approvedByAdmin : '',
      createdAt : '',
      updatedAt : '',
      totalJobApplication : 0,
      title : '',
      description : '',
      checkJobStatus : '',
      author : null,
      category : null,
      city : null,
      postState : JobPostInitial(),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      categoryId,
      cityId,
      thumbImage,
      slug,
      jobType,
      totalView,
      regularPrice,
      isUrgent,
      status,
      approvedByAdmin,
      createdAt,
      updatedAt,
      totalJobApplication,
      title,
      description,
      checkJobStatus,
      author,
      category,
      city,
      postState,
    ];
  }
}

class JobReqItem extends Equatable {
  final int id;
  final int jobPostId;
  final int sellerId;
  final int userId;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final JobPostItem? jobPost;
  const JobReqItem({
    required this.id,
    required this.jobPostId,
    required this.sellerId,
    required this.userId,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.jobPost,
  });

  JobReqItem copyWith({
    int? id,
    int? jobPostId,
    int? sellerId,
    int? userId,
    String? description,
    String? status,
    String? createdAt,
    String? updatedAt,
    JobPostItem? jobPost,
  }) {
    return JobReqItem(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      sellerId: sellerId ?? this.sellerId,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      jobPost: jobPost ?? this.jobPost,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'job_post_id':jobPostId,
      'seller_id':sellerId,
      'user_id':userId,
      'description':description,
      'status':status,
      'created_at':createdAt,
      'updated_at':updatedAt,
      'jobPost': jobPost?.toMap(),
    };
  }

  factory JobReqItem.fromMap(Map<String, dynamic> map) {
    return JobReqItem(
      id: map['id'] ?? 0,
      jobPostId: map['job_post_id'] != null? int.parse(map['job_post_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      userId: map['user_id'] != null? int.parse(map['user_id'].toString()):0,
      description: Utils.decodeHtmlEntities(map['description']) ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      jobPost: map['job_post'] != null ? JobPostItem.fromMap(map['job_post'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobReqItem.fromJson(String source) => JobReqItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

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
      jobPost,
    ];
  }
}

