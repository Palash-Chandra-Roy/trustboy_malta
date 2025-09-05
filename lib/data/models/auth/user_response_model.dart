import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserResponseModel extends Equatable {
  final String accessToken;
  final String tokenType;
  final int isVendor;
  final int expireIn;
  final UserResponse? user;
  final String userType;

  const UserResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.isVendor,
    required this.expireIn,
    required this.user,
    required this.userType,
  });

  UserResponseModel copyWith({
    String? accessToken,
    String? tokenType,
    int? isVendor,
    int? expireIn,
    UserResponse? user,
    String? userType,
  }) {
    return UserResponseModel(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      isVendor: isVendor ?? this.isVendor,
      expireIn: expireIn ?? this.expireIn,
      user: user ?? this.user,
      userType: userType ?? this.userType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'token_type': tokenType,
      'is_vendor': isVendor,
      'expires_in': expireIn,
      'user': user?.toMap(),
    };
  }

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      accessToken: map['access_token'] ?? '',
      tokenType: map['token_type'] ?? '',
      userType: map['user_type'] ?? '',
      isVendor: map['is_vendor'] ?? 0,
      expireIn: map['expires_in'] ?? 0,
      user: map['user'] != null
          ? UserResponse.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResponseModel.fromJson(String source) =>
      UserResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      accessToken,
      tokenType,
      isVendor,
      expireIn,
      user,
      userType,
    ];
  }
}

class UserResponse extends Equatable {
  final int id;
  final String username;
  final String name;
  final String image;
  final String status;
  final String isBanned;
  final int isSeller;
  final String isTopSeller;
  final String designation;
  final double hourlyPayment;
  final int kycStatus;
  final int onlineStatus;
  final int online;
  final double avgRating;
  final int totalRating;

  const UserResponse({
    required this.id,
    required this.username,
    required this.name,
    required this.image,
    required this.status,
    required this.isBanned,
    required this.isSeller,
    required this.isTopSeller,
    required this.designation,
    required this.hourlyPayment,
    required this.kycStatus,
    required this.onlineStatus,
    required this.online,
    required this.avgRating,
    required this.totalRating,
  });

  UserResponse copyWith({
    int? id,
    String? username,
    String? name,
    String? image,
    String? status,
    String? isBanned,
    int? isSeller,
    String? isTopSeller,
    String? designation,
    double? hourlyPayment,
    int? kycStatus,
    int? onlineStatus,
    int? online,
    double? avgRating,
    int? totalRating,
  }) {
    return UserResponse(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      image: image ?? this.image,
      status: status ?? this.status,
      isBanned: isBanned ?? this.isBanned,
      isSeller: isSeller ?? this.isSeller,
      isTopSeller: isTopSeller ?? this.isTopSeller,
      designation: designation ?? this.designation,
      hourlyPayment: hourlyPayment ?? this.hourlyPayment,
      kycStatus: kycStatus ?? this.kycStatus,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      online: online ?? this.online,
      avgRating: avgRating ?? this.avgRating,
      totalRating: totalRating ?? this.totalRating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'name': name,
      'image': image,
      'status': status,
      'is_banned': isBanned,
      'is_seller': isSeller,
      'is_top_seller': isTopSeller,
      'designation': designation,
      'hourly_payment': hourlyPayment,
      'kyc_status': kycStatus,
      'online_status': onlineStatus,
      'online': online,
      'avg_rating': avgRating,
      'total_rating': totalRating,
    };
  }

  factory UserResponse.fromMap(Map<String, dynamic> map) {
    return UserResponse(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      status: map['status'] ?? '',
      isBanned: map['is_banned'] ?? '',
      isSeller: map['is_seller'] != null? int.parse(map['is_seller'].toString()):00,
      isTopSeller: map['is_top_seller'] ?? '',
      designation: map['designation'] ?? '',
      hourlyPayment: map['hourly_payment'] != null? double.parse(map['hourly_payment'].toString()):0.0,
      kycStatus: map['kyc_status'] != null? int.parse(map['kyc_status'].toString()):0,
      onlineStatus: map['online_status'] != null? int.parse(map['online_status'].toString()):0,
      online: map['online'] != null? int.parse(map['online'].toString()):0,
      avgRating: map['avg_rating'] != null? double.parse(map['avg_rating'].toString()):0.0,
      totalRating: map['total_rating'] != null? int.parse(map['total_rating'].toString()):0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResponse.fromJson(String source) =>
      UserResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      username,
      name,
      image,
      status,
      isBanned,
      isSeller,
      isTopSeller,
      designation,
      hourlyPayment,
      kycStatus,
      onlineStatus,
      online,
      avgRating,
      totalRating,
    ];
  }
}
