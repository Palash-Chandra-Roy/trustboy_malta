import 'dart:convert';

import 'package:equatable/equatable.dart';
import '/data/models/home/seller_model.dart';
import '/logic/cubit/service_detail/service_detail_cubit.dart';

class ReviewModel extends Equatable {
  final int id;
  final int orderId;
  final int listingId;//used as carousel slided index
  final int buyerId;
  final int sellerId;
  final int rating;
  final int count;
  final double percentage;
  final String image;
  final String review;
  final String status;
  final String reviewBy;
  final String createdAt;
  final String updatedAt;
  final SellerModel? buyer;
  final bool readMore;
  final ServiceDetailState detailState;

  const ReviewModel({
    required this.id,
    required this.orderId,
    required this.listingId,
    required this.buyerId,
    required this.sellerId,
    required this.count,
    required this.percentage,
    required this.rating,
    required this.review,
    required this.image,
    required this.status,
    required this.reviewBy,
    required this.createdAt,
    required this.updatedAt,
    required this.buyer,
    required this.readMore,
    this.detailState = const ServiceDetailInitial(),
  });

  ReviewModel copyWith({
    int? id,
    int? orderId,
    int? listingId,
    int? buyerId,
    int? sellerId,
    int? rating,
    int? count,
    double? percentage,
    String? review,
    String? image,
    String? status,
    String? reviewBy,
    String? createdAt,
    String? updatedAt,
    SellerModel? buyer,
    bool? readMore,
    ServiceDetailState? detailState,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      listingId: listingId ?? this.listingId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      rating: rating ?? this.rating,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
      review: review ?? this.review,
      image: image ?? this.image,
      status: status ?? this.status,
      reviewBy: reviewBy ?? this.reviewBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      buyer: buyer ?? this.buyer,
      readMore: readMore ?? this.readMore,
      detailState: detailState ?? this.detailState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order_id': orderId,
      'listing_id': listingId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'rating': rating,
      'review': review,
      'count': count,
      'percentage': percentage,
      'image': image,
      'status': status,
      'review_by': reviewBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? 0,
      orderId:
          map['order_id'] != null ? int.parse(map['order_id'].toString()) : 0,
      listingId: map['listing_id'] != null
          ? int.parse(map['listing_id'].toString())
          : 0,
      buyerId:
          map['buyer_id'] != null ? int.parse(map['buyer_id'].toString()) : 0,
      sellerId:
          map['seller_id'] != null ? int.parse(map['seller_id'].toString()) : 0,
      rating: map['rating'] != null ? int.parse(map['rating'].toString()) : 0,
      count: map['count'] != null ? int.parse(map['count'].toString()) : 0,
      percentage: map['percentage'] != null
          ? double.parse(map['percentage'].toString())
          : 0.0,
      review: map['review'].toString().replaceAll('&#039;', "'") ?? '',
      image: map['image'] ?? '',
      status: map['status'] ?? '',
      reviewBy: map['review_by'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      readMore: map['read_more'] ?? false,
      buyer: map['buyer'] != null
          ? SellerModel.fromMap(map['buyer'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static ReviewModel init() {
    return const ReviewModel(
      id: 0,
      orderId: 0,
      listingId: 0,
      buyerId: 0,
      sellerId: 0,
      rating: 0,
      count: 0,
      percentage: 0,
      review: '',
      image: '',
      status: '',
      reviewBy: '',
      createdAt: '',
      updatedAt: '',
      readMore: false,
      buyer: null,
      detailState: ServiceDetailInitial(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      orderId,
      listingId,
      buyerId,
      sellerId,
      rating,
      count,
      percentage,
      review,
      image,
      status,
      reviewBy,
      createdAt,
      updatedAt,
      readMore,
      buyer,
      detailState,
    ];
  }
}
