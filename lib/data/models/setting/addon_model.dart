// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddonModel extends Equatable {
  final int id;
  final int status;
  final bool wallet;
  final bool subscription;
  final bool refund;
  final bool liveChat;
  const AddonModel({
    required this.id,
    required this.status,
    required this.wallet,
    required this.subscription,
    required this.refund,
    required this.liveChat,
  });

  @override
  List<Object> get props {
    return [
      id,
      status,
      wallet,
      subscription,
      refund,
      liveChat,
    ];
  }

  AddonModel copyWith({
    int? id,
    int? status,
    bool? wallet,
    bool? subscription,
    bool? refund,
    bool? liveChat,
  }) {
    return AddonModel(
      id: id ?? this.id,
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      subscription: subscription ?? this.subscription,
      refund: refund ?? this.refund,
      liveChat: liveChat ?? this.liveChat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'image': wallet,
      'description': subscription,
      'created_at': refund,
      'updated_at': liveChat,
    };
  }

  factory AddonModel.fromMap(Map<String, dynamic> map) {
    return AddonModel(
      id: map['id'] ?? 0,
      status: map['status'] != null ? int.parse(map['status'].toString()):0,
      wallet: map['wallet'] ?? false,
      subscription: map['subscription'] ?? false,
      refund: map['refund'] ?? false,
      liveChat: map['LiveChat'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddonModel.fromJson(String source) => AddonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
