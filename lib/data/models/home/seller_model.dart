import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/profile/profile_state.dart';
class SellerModel extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final int kycStatus;
  final String phone;
  final String address;
  final String gender;
  final String image;
  final double hourlyPayment;
  final String designation;
  final String isTopSeller;
  final String emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String status;
  final String isBanned;
  final int isSeller;
  final bool isSellerPage;
  final String aboutMe;
  final String language;
  final List<String> languageList;
  final String universityName;
  final String universityLocation;
  final String universityTimePeriod;
  final String schoolName;
  final String schoolLocation;
  final String schoolTimePeriod;
  final String skills;
  final List<String> skillList;
  final String verificationToken;
  final String provider;
  final String providerId;
  final String forgetPasswordToken;
  final int feezStatus;
  final int onlineStatus;
  final int online;
  final String verificationOtp; //hourlyPayment
  final String forgetPasswordOtp;
  final double avgRating;
  final int totalRating;
  final ProfileState profileState;
  const SellerModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.kycStatus,
    required this.phone,
    required this.address,
    required this.gender,
    required this.image,
    required this.hourlyPayment,
    required this.designation,
    required this.isTopSeller,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.isBanned,
    required this.isSeller,
    required this.isSellerPage,
    required this.aboutMe,
    required this.language,
     this.languageList = const <String>[],
    required this.universityName,
    required this.universityLocation,
    required this.universityTimePeriod,
    required this.schoolName,
    required this.schoolLocation,
    required this.schoolTimePeriod,
    required this.skills,
     this.skillList = const <String>[],
    required this.verificationToken,
    required this.provider,
    required this.providerId,
    required this.forgetPasswordToken,
    required this.feezStatus,
    required this.onlineStatus,
    required this.online,
    required this.verificationOtp,
    required this.forgetPasswordOtp,
    required this.avgRating,
    required this.totalRating,
    this.profileState = const ProfileInitial(),
  });

  SellerModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    int? kycStatus,
    String? phone,
    String? address,
    String? gender,
    String? image,
    double? hourlyPayment,
    String? designation,
    String? isTopSeller,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    String? status,
    String? isBanned,
    int? isSeller,
    bool? isSellerPage,
    String? aboutMe,
    String? language,
    String? universityName,
    String? universityLocation,
    String? universityTimePeriod,
    String? schoolName,
    String? schoolLocation,
    String? schoolTimePeriod,
    String? skills,
    List<String>? skillList,
    List<String>? languageList,
    String? verificationToken,
    String? provider,
    String? providerId,
    String? forgetPasswordToken,
    int? feezStatus,
    int? onlineStatus,
    int? online,
    String? verificationOtp,
    String? forgetPasswordOtp,
    double? avgRating,
    int? totalRating,
    ProfileState? profileState,
  }) {
    return SellerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      kycStatus: kycStatus ?? this.kycStatus,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      hourlyPayment: hourlyPayment ?? this.hourlyPayment,
      designation: designation ?? this.designation,
      isTopSeller: isTopSeller ?? this.isTopSeller,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      isBanned: isBanned ?? this.isBanned,
      isSeller: isSeller ?? this.isSeller,
      isSellerPage: isSellerPage ?? this.isSellerPage,
      aboutMe: aboutMe ?? this.aboutMe,
      language: language ?? this.language,
      universityName: universityName ?? this.universityName,
      universityLocation: universityLocation ?? this.universityLocation,
      universityTimePeriod: universityTimePeriod ?? this.universityTimePeriod,
      schoolName: schoolName ?? this.schoolName,
      schoolLocation: schoolLocation ?? this.schoolLocation,
      schoolTimePeriod: schoolTimePeriod ?? this.schoolTimePeriod,
      skills: skills ?? this.skills,
      verificationToken: verificationToken ?? this.verificationToken,
      provider: provider ?? this.provider,
      providerId: providerId ?? this.providerId,
      forgetPasswordToken: forgetPasswordToken ?? this.forgetPasswordToken,
      feezStatus: feezStatus ?? this.feezStatus,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      online: online ?? this.online,
      verificationOtp: verificationOtp ?? this.verificationOtp,
      forgetPasswordOtp: forgetPasswordOtp ?? this.forgetPasswordOtp,
      avgRating: avgRating ?? this.avgRating,
      totalRating: totalRating ?? this.totalRating,
      skillList: skillList ?? this.skillList,
      languageList: languageList ?? this.languageList,
      profileState: profileState ?? this.profileState,
    );
  }

  Map<String, String> toMap() {
    final result = <String, String>{};

    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'address': address});
    result.addAll({'gender': gender});
    result.addAll({'designation': designation});
    result.addAll({'about_me': aboutMe});

    if(isSellerPage){
      result.addAll({'university_name': universityName});
      result.addAll({'university_location': universityLocation});
      result.addAll({'university_time_period': universityTimePeriod});

      result.addAll({'school_name': schoolName});
      result.addAll({'school_location': schoolLocation});
      result.addAll({'school_time_period': schoolTimePeriod});

      result.addAll({'hourly_payment': verificationOtp});

      List<Map<String, String>> tempSkills = [];
      for (var skill in skillList) {
        if (skill.isNotEmpty) {
          tempSkills.add({'value': skill});
        }
      }
      String tagsJson = jsonEncode(tempSkills);
      result['skills'] = tagsJson;

      List<Map<String, String>> tempLang = [];
      for (var lang in languageList) {
        if (lang.isNotEmpty) {
          tempLang.add({'value': lang});
        }
      }
      String langJson = jsonEncode(tempLang);
      result['language'] = langJson;
    }

    return result;
  }

  factory SellerModel.fromMap(Map<String, dynamic> map) {
    return SellerModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      kycStatus: map['kyc_status'] != null? int.parse(map['kyc_status'].toString()):0,
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      image: map['image'] ?? '',
      hourlyPayment: map['hourly_payment'] != null? double.parse(map['hourly_payment'].toString()):0.0,
      designation: map['designation'] ?? '',
      isTopSeller: map['is_top_seller'] ?? '',
      emailVerifiedAt: map['email_verified_at'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      status: map['status'] ?? '',
      isBanned: map['is_banned'] ?? '',
      isSeller: map['is_seller'] != null? int.parse(map['is_seller'].toString()):0,
      isSellerPage: map['is_seller_page'] ?? false,
      aboutMe: map['about_me'] ?? '',
      language: map['language'] ?? '',
      universityName: map['university_name'] ?? '',
      universityLocation: map['university_location'] ?? '',
      universityTimePeriod: map['university_time_period'] ?? '',
      schoolName: map['school_name'] ?? '',
      schoolLocation: map['school_location'] ?? '',
      schoolTimePeriod: map['school_time_period'] ?? '',
      skills: map['skills'] ?? '',
      verificationToken: map['verification_token'] ?? '',
      provider: map['provider'] ?? '',
      providerId: map['provider_id'] ?? '',
      forgetPasswordToken: map['forget_password_token'] ?? '',
      feezStatus: map['feez_status'] != null? int.parse(map['feez_status'].toString()):0,
      onlineStatus: map['online_status'] != null? int.parse(map['online_status'].toString()):0,
      online: map['online'] != null? int.parse(map['online'].toString()):0,
      verificationOtp: map['verification_otp'] ?? '',
      forgetPasswordOtp: map['forget_password_otp'] ?? '',
      avgRating: map['avg_rating'] != null? double.parse(map['avg_rating'].toString()):0.0,
      totalRating: map['total_rating'] != null? int.parse(map['total_rating'].toString()):0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SellerModel.fromJson(String source) => SellerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;


  static SellerModel init(){
    return const SellerModel(
      id : 0,
      name : '',
      username : '',
      email : '',
      kycStatus : 0,
      phone : '',
      address : '',
      gender : '',
      image : '',
      hourlyPayment : 0,
      designation : '',
      isTopSeller : '',
      emailVerifiedAt : '',
      createdAt : '',
      updatedAt : '',
      status : '',
      isBanned : '',
      isSeller : 0,
      isSellerPage : false,
      aboutMe : '',
      language : '',
      universityName : '',
      universityLocation : '',
      universityTimePeriod : '',
      schoolName : '',
      schoolLocation : '',
      schoolTimePeriod : '',
      skills : '',
      verificationToken : '',
      provider : '',
      providerId : '',
      forgetPasswordToken : '',
      feezStatus : 0,
      onlineStatus : 0,
      online : 0,
      verificationOtp : '',
      forgetPasswordOtp : '',
      avgRating : 0.0,
      totalRating : 0,
      skillList : <String>[],
      languageList : <String>[],
      profileState : ProfileInitial(),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      username,
      email,
      kycStatus,
      phone,
      address,
      gender,
      image,
      hourlyPayment,
      designation,
      isTopSeller,
      emailVerifiedAt,
      createdAt,
      updatedAt,
      status,
      isBanned,
      isSeller,
      isSellerPage,
      aboutMe,
      language,
      universityName,
      universityLocation,
      universityTimePeriod,
      schoolName,
      schoolLocation,
      schoolTimePeriod,
      skills,
      verificationToken,
      provider,
      providerId,
      forgetPasswordToken,
      feezStatus,
      onlineStatus,
      online,
      verificationOtp,
      forgetPasswordOtp,
      avgRating,
      totalRating,
      skillList,
      languageList,
      profileState,
    ];
  }
}
