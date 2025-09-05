import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpEventName extends SignUpEvent {
  final String name;

  const SignUpEventName(this.name);

  @override
  List<Object> get props => [name];
}

class SignUpEventEmail extends SignUpEvent {
  final String email;

  const SignUpEventEmail(this.email);

  @override
  List<Object> get props => [email];
}

class SignUpEventCountryId extends SignUpEvent {
  final String countryId;

  const SignUpEventCountryId(this.countryId);

  @override
  List<Object> get props => [countryId];
}

class SignUpEventUserType extends SignUpEvent {
  final String userType;

  const SignUpEventUserType(this.userType);

  @override
  List<Object> get props => [userType];
}

class SignUpEventStateId extends SignUpEvent {
  final String stateId;

  const SignUpEventStateId(this.stateId);

  @override
  List<Object> get props => [stateId];
}

class SignUpEventCityId extends SignUpEvent {
  final String cityId;

  const SignUpEventCityId(this.cityId);

  @override
  List<Object> get props => [cityId];
}

class SignUpPhone extends SignUpEvent {
  final String phone;

  const SignUpPhone(this.phone);

  @override
  List<Object> get props => [phone];
}

class SignUpCompanyName extends SignUpEvent {
  final String company;

  const SignUpCompanyName(this.company);

  @override
  List<Object> get props => [company];
}

class SignUpEventLanguageCode extends SignUpEvent {
  final String languageCode;

  const SignUpEventLanguageCode(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class SignUpEventPassword extends SignUpEvent {
  final String password;

  const SignUpEventPassword(this.password);

  @override
  List<Object> get props => [password];
}

class SignUpEventPasswordConfirm extends SignUpEvent {
  final String passwordConfirm;

  const SignUpEventPasswordConfirm(this.passwordConfirm);

  @override
  List<Object> get props => [passwordConfirm];
}

class SignUpEventShowPassword extends SignUpEvent {
  const SignUpEventShowPassword();

  @override
  List<Object> get props => [];
}

class SignUpEventShowConfirmPassword extends SignUpEvent {
  const SignUpEventShowConfirmPassword();

  @override
  List<Object> get props => [];
}

class SignUpEventSubmit extends SignUpEvent {}

class SignUpEventAgree extends SignUpEvent {}

class SignUpEventVerificationCode extends SignUpEvent {
  final String code;

  const SignUpEventVerificationCode(this.code);

  @override
  List<Object> get props => [code];
}

class SignUpEventNewUserVerification extends SignUpEvent {
  final String token;

  const SignUpEventNewUserVerification(this.token);

  @override
  List<Object> get props => [token];
}

class SignUpEventNewUserSubmit extends SignUpEvent {}

class SignUpEventFormDataClear extends SignUpEvent {}

class SignUpEventResendVerificationSubmit extends SignUpEvent {
  const SignUpEventResendVerificationSubmit();

  @override
  List<Object> get props => [];
}
