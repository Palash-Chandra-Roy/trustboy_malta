import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../logic/cubit/wishlist/wishlist_state.dart';

class OtherModel extends Equatable {
  final String image;
  final String title;
  final String aToZ;
  final String zToA;
  final String lowToHigh;
  final String highToLow;
  final int totalCustomer;
  final int totalService;
  final int totalJob;
  final List<int> tempWishId;
  final bool isTap;
  final WishlistState wishState;

  const OtherModel({
    this.image = '',
    this.title = '',
    this.aToZ = '',
    this.zToA = '',
    this.lowToHigh = '',
    this.highToLow = '',
    this.totalCustomer = 0,
    this.totalService = 0,
    this.totalJob = 0,
    this.isTap = true,
    this.tempWishId = const <int>[],
    this.wishState = const WishListInitial(),
  });

  OtherModel copyWith({
    String? image,
    String? title,
    String? aToZ,
    String? zToA,
    String? lowToHigh,
    String? highToLow,
    int? totalCustomer,
    int? totalService,
    int? totalJob,
    bool? isTap,
    List<int>? tempWishId,
    WishlistState? wishState,
  }) {
    return OtherModel(
      image: image ?? this.image,
      title: title ?? this.title,
      aToZ: aToZ ?? this.aToZ,
      zToA: zToA ?? this.zToA,
      lowToHigh: lowToHigh ?? this.lowToHigh,
      highToLow: highToLow ?? this.highToLow,
      totalCustomer: totalCustomer ?? this.totalCustomer,
      totalService: totalService ?? this.totalService,
      totalJob: totalJob ?? this.totalJob,
      isTap: isTap ?? this.isTap,
      tempWishId: tempWishId ?? this.tempWishId,
      wishState: wishState ?? this.wishState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'title': title,
      'total_customer': totalCustomer,
      'total_service': totalService,
      'total_job': totalJob,
    };
  }

  factory OtherModel.fromMap(Map<String, dynamic> map) {
    return OtherModel(
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      aToZ: map['a_to_z'] ?? '',
      zToA: map['z_to_a'] ?? '',
      lowToHigh: map['low_to_high'] ?? '',
      highToLow: map['high_to_low'] ?? '',
      totalCustomer: map['total_customer'] != null ? int.parse(map['total_customer'].toString()) : 0,
      totalService: map['total_service'] != null ? int.parse(map['total_service'].toString()) : 0,
      totalJob: map['total_job'] != null ? int.parse(map['total_job'].toString()) : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherModel.fromJson(String source) =>
      OtherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      image,
      title,
      aToZ,
      zToA,
      lowToHigh,
      highToLow,
      totalCustomer,
      totalService,
      totalJob,
      isTap,
      tempWishId,
      wishState,
    ];
  }
}
