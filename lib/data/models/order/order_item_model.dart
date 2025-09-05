import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../home/seller_model.dart';
import '../refund/refund_item.dart';
import '../service/review_model.dart';
import 'listing_model.dart';


class OrderItem extends Equatable {
  final int id;
  final String orderId;
  final int buyerId;
  final int sellerId;
  final int listingId;
  final int listingPackageId;
  final double totalAmount;
  final double packageAmount;
  final double additionalAmount;
  final String packageName;
  final String packageDescription;
  final int deliveryDate;
  final int revision;
  final String fnWebsite;
  final int numberOfPage;
  final String responsive;
  final String sourceCode;
  final String contentUpload;
  final String speedOptimized;
  final String paymentMethod;
  final String paymentStatus;
  final String transactionId;
  final String orderStatus;
  final String approvedBySeller;
  final String completedByBuyer;
  final String createdAt;
  final String updatedAt;
  final String submitFile;
  final ListingModel? listing;
  final SellerModel? seller;
  final int totalJob;
  final int totalRating;
  final double avgRating;
  final int reviewExist;
  final bool ableToRefund;
  final bool canSendRefund;
  final bool refundAvailable;
  final ReviewModel? review;
  final RefundItem? refund;
  const OrderItem({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.listingId,
    required this.listingPackageId,
    required this.totalAmount,
    required this.packageAmount,
    required this.additionalAmount,
    required this.packageName,
    required this.packageDescription,
    required this.deliveryDate,
    required this.revision,
    required this.fnWebsite,
    required this.numberOfPage,
    required this.responsive,
    required this.sourceCode,
    required this.contentUpload,
    required this.speedOptimized,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    required this.orderStatus,
    required this.approvedBySeller,
    required this.completedByBuyer,
    required this.createdAt,
    required this.updatedAt,
    required this.submitFile,
    required this.listing,
    required this.seller,
    required this.totalJob,
    required this.totalRating,
    required this.avgRating,
    required this.reviewExist,
    required this.ableToRefund,
    required this.canSendRefund,
    required this.refundAvailable,
    required this.review,
    required this.refund,
  });

  OrderItem copyWith({
    int? id,
    String? orderId,
    int? buyerId,
    int? sellerId,
    int? listingId,
    int? listingPackageId,
    double? totalAmount,
    double? packageAmount,
    double? additionalAmount,
    String? packageName,
    String? packageDescription,
    int? deliveryDate,
    int? revision,
    String? fnWebsite,
    int? numberOfPage,
    String? responsive,
    String? sourceCode,
    String? contentUpload,
    String? speedOptimized,
    String? paymentMethod,
    String? paymentStatus,
    String? transactionId,
    String? orderStatus,
    String? approvedBySeller,
    String? completedByBuyer,
    String? createdAt,
    String? updatedAt,
    String? submitFile,
    ListingModel? listing,
    SellerModel? seller,
    int? totalJob,
    int? totalRating,
    double? avgRating,
    int? reviewExist,
    bool? ableToRefund,
    bool? canSendRefund,
    bool? refundAvailable,
    ReviewModel? review,
    RefundItem? refund,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      listingId: listingId ?? this.listingId,
      listingPackageId: listingPackageId ?? this.listingPackageId,
      totalAmount: totalAmount ?? this.totalAmount,
      packageAmount: packageAmount ?? this.packageAmount,
      additionalAmount: additionalAmount ?? this.additionalAmount,
      packageName: packageName ?? this.packageName,
      packageDescription: packageDescription ?? this.packageDescription,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      revision: revision ?? this.revision,
      fnWebsite: fnWebsite ?? this.fnWebsite,
      numberOfPage: numberOfPage ?? this.numberOfPage,
      responsive: responsive ?? this.responsive,
      sourceCode: sourceCode ?? this.sourceCode,
      contentUpload: contentUpload ?? this.contentUpload,
      speedOptimized: speedOptimized ?? this.speedOptimized,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
      orderStatus: orderStatus ?? this.orderStatus,
      approvedBySeller: approvedBySeller ?? this.approvedBySeller,
      completedByBuyer: completedByBuyer ?? this.completedByBuyer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      submitFile: submitFile ?? this.submitFile,
      listing: listing ?? this.listing,
      seller: seller ?? this.seller,
      totalJob: totalJob ?? this.totalJob,
      totalRating: totalRating ?? this.totalRating,
      avgRating: avgRating ?? this.avgRating,
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
      'id':id,
      'order_id':orderId,
      'buyer_id':buyerId,
      'seller_id':sellerId,
      'listing_id':listingId,
      'listing_package_id':listingPackageId,
      'total_amount':totalAmount,
      'package_amount':packageAmount,
      'additional_amount':additionalAmount,
      'package_name':packageName,
      'package_description':packageDescription,
      'delivery_date':deliveryDate,
      'revision':revision,
      'fn_website':fnWebsite,
      'number_of_page':numberOfPage,
      'responsive':responsive,
      'source_code':sourceCode,
      'content_upload':contentUpload,
      'speed_optimized':speedOptimized,
      'payment_method':paymentMethod,
      'payment_status':paymentStatus,
      'transaction_id':transactionId,
      'order_status':orderStatus,
      'approved_by_seller':approvedBySeller,
      'completed_by_buyer':completedByBuyer,
      'created_at':createdAt,
      'updated_at':updatedAt,
      'submit_file':submitFile,
      'listing': listing?.toMap(),
      'seller': seller?.toMap(),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? 0,
      orderId: map['order_id'] ?? '',
      buyerId: map['buyer_id'] != null? int.parse(map['buyer_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      listingId: map['listing_id'] != null? int.parse(map['listing_id'].toString()):0,
      listingPackageId: map['listing_package_id'] != null? int.parse(map['listing_package_id'].toString()):0,
      totalAmount: map['total_amount'] != null? double.parse(map['total_amount'].toString()):0.0,
      packageAmount: map['package_amount'] != null? double.parse(map['package_amount'].toString()):0.0,
      additionalAmount: map['additional_amount'] != null? double.parse(map['additional_amount'].toString()):0.0,
      totalRating: map['total_rating'] != null? int.parse(map['total_rating'].toString()):0,
      avgRating: map['avg_rating'] != null? double.parse(map['avg_rating'].toString()):0.0,
      packageName: map['package_name'] ?? '',
      packageDescription: map['package_description'] ?? '',
      deliveryDate: map['delivery_date'] != null? int.parse(map['delivery_date'].toString()):0,
      revision: map['revision'] != null? int.parse(map['revision'].toString()):0,
      fnWebsite: map['fn_website'] ?? '',
      numberOfPage: map['number_of_page'] != null? int.parse(map['number_of_page'].toString()):0,
      responsive: map['responsive'] ?? '',
      sourceCode: map['source_code'] ?? '',
      contentUpload: map['content_upload'] ?? '',
      speedOptimized: map['speed_optimized'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      paymentStatus: map['payment_status'] ?? '',
      transactionId: map['transaction_id'] ?? '',
      orderStatus: map['order_status'] ?? '',
      approvedBySeller: map['approved_by_seller'] ?? '',
      completedByBuyer: map['completed_by_buyer'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      submitFile: map['submit_file'] ?? '',
      listing: map['listing'] != null ? ListingModel.fromMap(map['listing'] as Map<String,dynamic>) : null,
      seller: map['seller'] != null ? SellerModel.fromMap(map['seller'] as Map<String,dynamic>) : null,
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

  factory OrderItem.fromJson(String source) => OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      orderId,
      buyerId,
      sellerId,
      listingId,
      listingPackageId,
      totalAmount,
      packageAmount,
      additionalAmount,
      packageName,
      packageDescription,
      deliveryDate,
      revision,
      fnWebsite,
      numberOfPage,
      responsive,
      sourceCode,
      contentUpload,
      speedOptimized,
      paymentMethod,
      paymentStatus,
      transactionId,
      orderStatus,
      approvedBySeller,
      completedByBuyer,
      createdAt,
      updatedAt,
      submitFile,
      listing,
      seller,
      totalJob,
      totalRating,
      avgRating,
      reviewExist,
      ableToRefund,
      canSendRefund,
      refundAvailable,
      review,
      refund,
    ];
  }
}
