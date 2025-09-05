// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SplashModel extends Equatable {
  final String? splashScreen1;
  final String? splashScreen2;
  final String? splashScreen3;
  final String? splashScreen1Title;
  final String? splashScreen2Title;
  final String? splashScreen3Title;
  final String? image;
  final String? title;
  const SplashModel({
    this.splashScreen1 = '',
    this.splashScreen2 = '',
    this.splashScreen3 = '',
    this.splashScreen1Title = '',
    this.splashScreen2Title = '',
    this.splashScreen3Title = '',
    this.image = '',
    this.title = '',
  });

  SplashModel copyWith({
    String? splashScreen1,
    String? splashScreen2,
    String? splashScreen3,
    String? splashScreen1Title,
    String? splashScreen2Title,
    String? splashScreen3Title,
    String? image,
    String? title,
  }) {
    return SplashModel(
      splashScreen1: splashScreen1 ?? this.splashScreen1,
      splashScreen2: splashScreen2 ?? this.splashScreen2,
      splashScreen3: splashScreen3 ?? this.splashScreen3,
      splashScreen1Title: splashScreen1Title ?? this.splashScreen1Title,
      splashScreen2Title: splashScreen2Title ?? this.splashScreen2Title,
      splashScreen3Title: splashScreen3Title ?? this.splashScreen3Title,
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'splash_screen1' : splashScreen1,
      'splash_screen2' : splashScreen2,
      'splash_screen3' : splashScreen3,
      'splash_screen1_title' : splashScreen1Title,
      'splash_screen2_title' : splashScreen2Title,
      'splash_screen3_title' : splashScreen3Title,
    };
  }

  factory SplashModel.fromMap(Map<String, dynamic> map) {
    return SplashModel(
      splashScreen1: map['splash_screen1']?? '',
      splashScreen2: map['splash_screen2']?? '',
      splashScreen3: map['splash_screen3']?? '',
      splashScreen1Title: map['splash_screen1_title']?? '',
      splashScreen2Title: map['splash_screen2_title']?? '',
      splashScreen3Title: map['splash_screen3_title']?? '',
      image: map['image']?? '',
      title: map['title']?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SplashModel.fromJson(String source) => SplashModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      splashScreen1,
      splashScreen2,
      splashScreen3,
      splashScreen1Title,
      splashScreen2Title,
      splashScreen3Title,
      image,
      title,
    ];
  }
}