// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:work_zone/presentation/utils/utils.dart';

import '../../../logic/cubit/chat/chat_cubit.dart';

class MessageModel extends Equatable {
  final int id;
  final int buyerId;
  final int sellerId;
  final String message;
  final int buyerReadMsg;
  final int sellerReadMsg;
  final String sendBy;
  final int serviceId;
  final String createdAt;
  final String updatedAt;
  bool isOpenSupport;
  bool isSeller;
  final ChatState chatState;
   MessageModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.message,
    required this.buyerReadMsg,
    required this.sellerReadMsg,
    required this.sendBy,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
     this.isOpenSupport = false,
     this.isSeller = false,
     this.chatState = const ChatInitial(),
  });

  MessageModel copyWith({
    int? id,
    int? buyerId,
    int? sellerId,
    String? message,
    int? buyerReadMsg,
    int? sellerReadMsg,
    String? sendBy,
    int? serviceId,
    String? createdAt,
    String? updatedAt,
    bool? isOpenSupport,
    bool? isSeller,
    ChatState? chatState,
  }) {
    return MessageModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      message: message ?? this.message,
      buyerReadMsg: buyerReadMsg ?? this.buyerReadMsg,
      sellerReadMsg: sellerReadMsg ?? this.sellerReadMsg,
      sendBy: sendBy ?? this.sendBy,
      serviceId: serviceId ?? this.serviceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOpenSupport: isOpenSupport ?? this.isOpenSupport,
      isSeller: isSeller ?? this.isSeller,
      chatState: chatState ?? this.chatState,
    );
  }


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if(isSeller){
      result.addAll({'buyer_id': sellerId.toString()});
    }else{
      result.addAll({'seller_id': sellerId.toString()});
    }

    result.addAll({'message': message});

    if(serviceId != 0){
      result.addAll({'service_id': serviceId.toString()});
    }

    return result;
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? 0,
      buyerId: map['buyer_id'] != null? int.parse(map['buyer_id'].toString()):0,
      sellerId: map['seller_id'] != null? int.parse(map['seller_id'].toString()):0,
      // message: map['message'] ?? '',
      message: Utils.decodeHtmlEntities(map['message']??''),
      buyerReadMsg: map['buyer_read_msg'] != null? int.parse(map['buyer_read_msg'].toString()):0,
      sellerReadMsg: map['seller_read_msg'] != null? int.parse(map['seller_read_msg'].toString()):0,
      sendBy: map['send_by'] ?? '',
      serviceId: map['service_id'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static MessageModel init(){
    return MessageModel(
      id : 0,
      buyerId : 0,
      sellerId : 0,
      message : '',
      buyerReadMsg : 0,
      sellerReadMsg : 0,
      sendBy : '',
      serviceId : 0,
      createdAt : '',
      updatedAt : '',
      isOpenSupport : false,
      isSeller : false,
      chatState : ChatInitial(),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      buyerId,
      sellerId,
      message,
      buyerReadMsg,
      sellerReadMsg,
      sendBy,
      serviceId,
      createdAt,
      updatedAt,
      isOpenSupport,
      isSeller,
      chatState,
    ];
  }
}
