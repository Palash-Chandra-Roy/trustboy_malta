import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'sign_up_state.dart';

class SignUpStateModel extends Equatable {
  final bool agree;
  final String name;
  final String email;
  final String languageCode;
  final String token;
  final String countryCode;
  final String password;
  final bool showPassword;
  final bool showConfirmPassword;
  final String confirmPassword;
  final String countryId;
  final String stateId;
  final String cityId;
  final String phone;
  final String company;
  final String userType;
  final String langCode;
  final SignUpState signUpState;

  const SignUpStateModel({
    this.agree = true,
    this.name = '',
    this.email = '',
    this.languageCode = '',
    this.token = '',
    this.countryCode = '',
    this.password = '',
    this.confirmPassword = '',
    this.countryId = '',
    this.stateId = '',
    this.cityId = '',
    this.phone = '',
    this.company = '',
    this.userType = 'Buyer',
    this.langCode = '',
    this.showPassword = true,
    this.showConfirmPassword = true,
    this.signUpState = const SignUpStateInitial(),
  });

  SignUpStateModel copyWith({
    bool? agree,
    String? name,
    String? email,
    String? languageCode,
    String? token,
    String? countryCode,
    String? password,
    String? confirmPassword,
    String? countryId,
    String? stateId,
    String? cityId,
    String? phone,
    String? company,
    String? userType,
    String? langCode,
    bool? showPassword,
    bool? showConfirmPassword,
    SignUpState? signUpState,
  }) {
    return SignUpStateModel(
      agree: agree ?? this.agree,
      name: name ?? this.name,
      email: email ?? this.email,
      languageCode: languageCode ?? this.languageCode,
      token: token ?? this.token,
      countryCode: countryCode ?? this.countryCode,
      password: password ?? this.password,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      phone: phone ?? this.phone,
      showPassword: showPassword ?? this.showPassword,
      company: company ?? this.company,
      userType: userType ?? this.userType,
      langCode: langCode ?? this.langCode,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      signUpState: signUpState ?? this.signUpState,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'name': name.trim()});
    result.addAll({'email': email.trim()});
    result.addAll({'password': password});
    result.addAll({'password_confirmation': confirmPassword});
    result.addAll({'user_type': userType.toLowerCase()});

    return result;
  }

  Map<String, dynamic> toOtpMap() {
    final result = <String, dynamic>{};
    result.addAll({'otp': token});
    result.addAll({'email': email.trim()});
    return result;
  }

  SignUpStateModel clear() {
    return const SignUpStateModel(
      agree: true,
      name: '',
      email: '',
      token: '',
      countryCode: '',
      password: '',
      confirmPassword: '',
      countryId: '',
      stateId: '',
      cityId: '',
      phone: '',
      company: '',
      userType: 'Buyer',
      langCode: '',
      showPassword: true,
      showConfirmPassword: true,
      signUpState: SignUpStateInitial(),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SignUpModelState(agree: $agree, name: $name, email: $email, token: $token, countryCode: $countryCode, password: $password, confirmPassword: $confirmPassword, signUpState: $signUpState)';
  }

  @override
  List<Object> get props {
    return [
      agree,
      name,
      email,
      languageCode,
      token,
      countryCode,
      password,
      showPassword,
      countryId,
      stateId,
      cityId,
      phone,
      company,
      userType,
      langCode,
      showConfirmPassword,
      confirmPassword,
      signUpState,
    ];
  }
}
