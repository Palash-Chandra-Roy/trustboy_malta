import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../data_provider/remote_url.dart';

class GalleryModel extends Equatable {
  final int id;
  final int listingId;
  final String image;
  final String langCode;
  final String title;
  final String description;
  final String createdAt;
  final String updatedAt;
  const GalleryModel({
    required this.id,
    required this.listingId,
    required this.image,
    this.langCode = '',
    this.title= '',
    this.description= '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  GalleryModel copyWith({
    int? id,
    int? listingId,
    String? image,
    String? langCode,
    String? title,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return GalleryModel(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      image: image ?? this.image,
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id' : id,
      'listing_id' : listingId,
      'image' : image,
      'lang_code' : langCode,
      'title' : title,
      'description' : description,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
  }

  factory GalleryModel.fromMap(Map<String, dynamic> map) {
    return GalleryModel(
      id: map['id'] ?? 0,
      listingId: map['listing_id'] != null? int.parse(map['listing_id'].toString()):0,
      image: map['image'] != null? RemoteUrls.imageUrl(map['image']):'',
      langCode: map['lang_code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryModel.fromJson(String source) => GalleryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      listingId,
      image,
      langCode,
      title,
      description,
      createdAt,
      updatedAt,
    ];
  }
}
