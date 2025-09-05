import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../delete/delete_cubit.dart';
import 'forgot_password_cubit.dart';

class PasswordStateModel extends Equatable {
  final String email;
  final String code;
  final String password;
  final String languageCode;
  final String confirmPassword;
  final String langCode;
  final String message;
  final bool showPassword;
  final bool showConfirmPassword;
  final ForgotPasswordState passwordState;
  final DeleteState deleteState;

  const PasswordStateModel({
    this.email = '',
    this.code = '',
    this.password = '',
    this.languageCode = '',
    this.confirmPassword = '',
    this.langCode = '',
    this.message = '',
    this.showPassword = true,
    this.showConfirmPassword = true,
    this.passwordState = const ForgotPasswordStateInitial(),
    this.deleteState = const DeleteInitial(),
  });

  PasswordStateModel copyWith({
    String? email,
    String? code,
    String? password,
    String? languageCode,
    String? confirmPassword,
    String? langCode,
    String? message,
    bool? showPassword,
    bool? showConfirmPassword,
    ForgotPasswordState? passwordState,
    DeleteState? deleteState,
  }) {
    return PasswordStateModel(
      email: email ?? this.email,
      code: code ?? this.code,
      password: password ?? this.password,
      languageCode: languageCode ?? this.languageCode,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      langCode: langCode ?? this.langCode,
      message: message ?? this.message,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      passwordState: passwordState ?? this.passwordState,
      deleteState: deleteState ?? this.deleteState,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'otp': code,
      'password': password,
      'password_confirmation': confirmPassword,
      'lang_code': languageCode,
      // 'showPassword': showPassword,
      // 'showConfirmPassword': showConfirmPassword,
    };
  }

  static PasswordStateModel init() {
    return const PasswordStateModel(
      email: '',
      code: '',
      password: '',
      languageCode: '',
      confirmPassword: '',
      langCode: '',
      message: '',
      showPassword: true,
      showConfirmPassword: true,
      passwordState: ForgotPasswordStateInitial(),
      deleteState: DeleteInitial(),
    );
  }

  PasswordStateModel clear() {
    return const PasswordStateModel(
      email: '',
      code: '',
      password: '',
      confirmPassword: '',
      langCode: '',
      message: '',
      showPassword: true,
      showConfirmPassword: true,
      passwordState: ForgotPasswordStateInitial(),
      deleteState: DeleteInitial(),
    );
  }

  factory PasswordStateModel.fromMap(Map<String, dynamic> map) {
    return PasswordStateModel(
      email: map['email'] ?? '',
      code: map['token'] ?? '',
      password: map['password'] ?? '',
      confirmPassword: map['password_confirmation'] ?? '',
      showPassword: map['showPassword'] ?? false,
      showConfirmPassword: map['showConfirmPassword'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordStateModel.fromJson(String source) =>
      PasswordStateModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PasswordStateModel(email: $email, code: $code, password: $password, confirmPassword: $confirmPassword, showPassword: $showPassword, showConfirmPassword: $showConfirmPassword, passwordState: $passwordState)';
  }

  @override
  List<Object> get props {
    return [
      email,
      code,
      password,
      languageCode,
      confirmPassword,
      langCode,
      message,
      showPassword,
      showConfirmPassword,
      passwordState,
      deleteState,
    ];
  }
}
