part of 'change_password_cubit.dart';

class ChangePasswordStateModel extends Equatable {
  final String currentPassword;
  final String newPassword;
  final bool isShowNewPassword;
  final bool isShowConfirmPassword;
  final bool isShowCurrentPassword;
  final String confirmationPassword;
  final String langCode;
  final String token;
  final ChangePasswordState status;

  const ChangePasswordStateModel({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmationPassword = '',
    this.langCode = '',
    this.token = '',
    this.isShowNewPassword = true,
    this.isShowConfirmPassword = true,
    this.isShowCurrentPassword = true,
    this.status = const ChangePasswordStateInitial(),
  });

  ChangePasswordStateModel copyWith({
    String? currentPassword,
    String? newPassword,
    String? langCode,
    String? token,
    String? confirmationPassword,
    bool? isShowNewPassword,
    bool? isShowConfirmPassword,
    bool? isShowCurrentPassword,
    ChangePasswordState? status,
  }) {
    return ChangePasswordStateModel(
      currentPassword: currentPassword ?? this.currentPassword,
      isShowCurrentPassword:
          isShowCurrentPassword ?? this.isShowCurrentPassword,
      newPassword: newPassword ?? this.newPassword,
      langCode: langCode ?? this.langCode,
      token: token ?? this.token,
      isShowNewPassword: isShowNewPassword ?? this.isShowNewPassword,
      isShowConfirmPassword:
          isShowConfirmPassword ?? this.isShowConfirmPassword,
      confirmationPassword: confirmationPassword ?? this.confirmationPassword,
      status: status ?? this.status,
    );
  }

  ChangePasswordStateModel clear() {
    return const ChangePasswordStateModel(
      currentPassword: '',
      newPassword: '',
      confirmationPassword: '',
      isShowCurrentPassword: true,
      isShowConfirmPassword: true,
      isShowNewPassword: true,
      status: ChangePasswordStateInitial(),
    );
  }

  Map<String, String> toMap() {
    final result = <String, String>{};
    result.addAll({'current_password': currentPassword});
    result.addAll({'password': newPassword});
    result.addAll({'password_confirmation': confirmationPassword});
    return result;
  }

  @override
  String toString() {
    return 'ChangePasswordStateModel(password: $newPassword, passwordConfirmation: $confirmationPassword, status: $status)';
  }

  @override
  List<Object> get props => [
        newPassword,
        currentPassword,
        confirmationPassword,
        isShowNewPassword,
        langCode,
        token,
        isShowConfirmPassword,
        isShowCurrentPassword,
        status
      ];
}

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordStateInitial extends ChangePasswordState {
  const ChangePasswordStateInitial();
}

class ChangePasswordStateLoading extends ChangePasswordState {
  const ChangePasswordStateLoading();
}

class ChangePasswordStateLoaded extends ChangePasswordState {
  final String message;

  const ChangePasswordStateLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class ChangePasswordStateError extends ChangePasswordState {
  final String message;
  final int statusCode;

  const ChangePasswordStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class ChangePasswordStateFormError extends ChangePasswordState {
  final Errors errors;

  const ChangePasswordStateFormError(this.errors);

  @override
  List<Object> get props => [errors];
}
