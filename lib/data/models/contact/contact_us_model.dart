import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/contact/contact_cubit.dart';

class ContactUsModel extends Equatable {
  final int id;
  final String question;
  final String phone;
  final String email;
  final String phone2;
  final String email2;
  final String answer;
  final String mapCode;
  final String title;
  final String description;
  final String address;
  final String contactDescription;
  final String createdAt;
  final String updatedAt;
  final ContactState contactState;

  const ContactUsModel({
    this.id = 0,
    this.question = '',
    this.phone = '',
    this.email = '',
    this.phone2 = '',
    this.email2 = '',
    this.answer = '',
    this.mapCode = '',
    this.title = '',
    this.description = '',
    this.address = '',
    this.contactDescription = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.contactState = const ContactInitial(),
  });

  ContactUsModel copyWith({
    int? id,
    String? question,
    String? phone,
    String? email,
    String? phone2,
    String? email2,
    String? answer,
    String? mapCode,
    String? title,
    String? description,
    String? address,
    String? contactDescription,
    String? createdAt,
    String? updatedAt,
    ContactState? contactState,
  }) {
    return ContactUsModel(
      id: id ?? this.id,
      question: question ?? this.question,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      phone2: phone2 ?? this.phone2,
      email2: email2 ?? this.email2,
      answer: answer ?? this.answer,
      mapCode: mapCode ?? this.mapCode,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      contactDescription: contactDescription ?? this.contactDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contactState: contactState ?? this.contactState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': question,
      'email': email,
      'phone': phone,
      'subject': phone2,
      'message': description,
    };
  }

  factory ContactUsModel.fromMap(Map<String, dynamic> map) {
    return ContactUsModel(
      id: map['id'] ?? 0,
      question: map['question'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      phone2: map['phone2'] ?? '',
      email2: map['email2'] ?? '',
      answer: map['answer'] ?? '',
      mapCode: map['map_code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      address: map['address'] ?? '',
      contactDescription: map['contact_description'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactUsModel.fromJson(String source) =>
      ContactUsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      question,
      phone,
      email,
      phone2,
      email2,
      answer,
      mapCode,
      title,
      description,
      address,
      contactDescription,
      createdAt,
      updatedAt,
      contactState,
    ];
  }
}
