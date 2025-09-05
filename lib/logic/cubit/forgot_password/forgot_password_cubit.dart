import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/data_provider/remote_url.dart';

import '../../../../logic/bloc/login/login_bloc.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../repository/auth_repository.dart';
import 'forgot_password_state_model.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<PasswordStateModel> {
  final AuthRepository _authRepository;
  final LoginBloc _loginBloc;

  ForgotPasswordCubit({
    required AuthRepository authRepository,
    required LoginBloc loginBloc,
  })  : _authRepository = authRepository,
        _loginBloc = loginBloc,
        super(PasswordStateModel.init());

  void changeEmail(String text) {
    emit(state.copyWith(
        email: text, passwordState: const ForgotPasswordStateInitial()));
  }

  void message(String text) {
    emit(state.copyWith(message: text));
  }

  void changeCode(String text) {
    emit(state.copyWith(
        code: text, passwordState: const ForgotPasswordStateInitial()));
  }

  void changePassword(String text) {
    emit(state.copyWith(
        password: text, passwordState: const ForgotPasswordStateInitial()));
  }

  void changeConfirmPassword(String text) {
    emit(state.copyWith(
        confirmPassword: text,
        passwordState: const ForgotPasswordStateInitial()));
  }

  void showPassword() {
    emit(state.copyWith(
        showPassword: !state.showPassword,
        passwordState: const ForgotPasswordStateInitial()));
  }

  void showConfirmPassword() {
    emit(state.copyWith(
        showConfirmPassword: !state.showConfirmPassword,
        passwordState: const ForgotPasswordStateInitial()));
  }

  Future<void> forgotPassWord() async {
    emit(state.copyWith(passwordState: const ForgotPasswordStateLoading()));
    final uri = Uri.parse(RemoteUrls.sendForgetPassword(_loginBloc.userInformation?.accessToken??''));
    final body = {
      "email": state.email,
      'lang_code': _loginBloc.state.langCode,
    };

    final result = await _authRepository.forgotPassword(uri,body);
    result.fold(
      (failure) {
        if (failure is InvalidAuthData) {
          final errors = ForgotPasswordFormValidateError(failure.errors);
          emit(state.copyWith(passwordState: errors));
        } else {
          final errors =
              ForgotPasswordStateError(failure.message, failure.statusCode);
          emit(state.copyWith(passwordState: errors));
        }
      },
      (data) {
        emit(state.copyWith(passwordState: ForgotPasswordStateLoaded(data)));
      },
    );
  }

  Future<void> updatePassword() async {
    debugPrint('update-body ${state.toMap()}');
    emit(state.copyWith(passwordState: const ForgotPasswordStateLoading()));
    final uri = Uri.parse(RemoteUrls.changePassword).replace(queryParameters: {'lang_code': _loginBloc.state.langCode});

    final result = await _authRepository.updatePassword(uri,state);
    result.fold(
      (failure) {
        if (failure is InvalidAuthData) {
          final errors = ForgotPasswordFormValidateError(failure.errors);
          emit(state.copyWith(passwordState: errors));
        } else {
          final errors = ForgotPasswordStateError(failure.message, failure.statusCode);
          emit(state.copyWith(passwordState: errors));
        }
      },
      (data) {
        emit(state.copyWith(passwordState: PasswordStateUpdated(data)));
      },
    );
  }

  void verifyForgotPasswordCode() {
    emit(state.copyWith(passwordState: const VerifyingForgotPasswordLoading()));
    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        emit(state.copyWith(
            passwordState: const VerifyingForgotPasswordCodeLoaded()));
      },
    );
  }

  void clear() {
    emit(state.clear());
  }
}
