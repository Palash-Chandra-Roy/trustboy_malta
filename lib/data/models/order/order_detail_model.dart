import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../home/seller_model.dart';
import '../refund/refund_item.dart';
import '../service/review_model.dart';
import 'order_item_model.dart';


class OrderDetail extends Equatable {
  final OrderItem? order;
  final SellerModel? seller;
  final SellerModel? buyer;
  final int totalJob;
  final int reviewExist;
  final bool ableToRefund;
  final bool canSendRefund;
  final bool refundAvailable;
  final ReviewModel? review;
  final RefundItem? refund;
  const OrderDetail({
    required this.order,
    required this.seller,
    required this.buyer,
    required this.totalJob,
    required this.reviewExist,
    required this.ableToRefund,
    required this.canSendRefund,
    required this.refundAvailable,
    required this.review,
    required this.refund,
  });

  OrderDetail copyWith({
    OrderItem? order,
    SellerModel? seller,
    SellerModel? buyer,
    int? totalJob,
    int? reviewExist,
    bool? ableToRefund,
    bool? canSendRefund,
    bool? refundAvailable,
    ReviewModel? review,
    RefundItem? refund,
  }) {
    return OrderDetail(
      order: order ?? this.order,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
      totalJob: totalJob ?? this.totalJob,
      reviewExist: reviewExist ?? this.reviewExist,
      ableToRefund: ableToRefund ?? this.ableToRefund,
      canSendRefund: canSendRefund ?? this.canSendRefund,
      refundAvailable: refundAvailable ?? this.refundAvailable,
      review: review ?? this.review,
      refund: refund ?? this.refund,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order': order?.toMap(),
      'seller': seller?.toMap(),
      'buyer': buyer?.toMap(),
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      order: map['order'] != null ? OrderItem.fromMap(map['order'] as Map<String,dynamic>) : null,
      seller: map['seller'] != null ? SellerModel.fromMap(map['seller'] as Map<String,dynamic>) : null,
      buyer: map['buyer'] != null ? SellerModel.fromMap(map['buyer'] as Map<String,dynamic>) : null,
      totalJob: map['total_job'] != null? int.parse(map['total_job'].toString()):0,
      reviewExist: map['review_exist'] != null? int.parse(map['review_exist'].toString()):0,
      ableToRefund: map['able_to_refund'] ?? false,
      canSendRefund: map['can_send_refund'] ?? false,
      refundAvailable: map['refund_available'] ?? false,
      review: map['review'] != null ? ReviewModel.fromMap(map['review'] as Map<String,dynamic>) : null,
      refund: map['refund'] != null ? RefundItem.fromMap(map['refund'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromJson(String source) => OrderDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      order,
      seller,
      buyer,
      totalJob,
      reviewExist,
      ableToRefund,
      canSendRefund,
      refundAvailable,
      review,
      refund,
    ];
  }
}