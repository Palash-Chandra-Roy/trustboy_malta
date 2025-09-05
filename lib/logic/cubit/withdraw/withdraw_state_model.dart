import 'package:equatable/equatable.dart';

import '../../../data/models/withdraw/method_model.dart';
import 'withdraw_cubit.dart';

class WithdrawStateModel extends Equatable {
  final String methodId;
  final String withdrawAmount;
  final String accountInfo;
  final String langCode;
  final MethodModel? methods;
  final WithdrawState withdrawState;

  const WithdrawStateModel({
    this.methodId = '',
    this.withdrawAmount = '',
    this.accountInfo = '',
    this.langCode = '',
    this.methods,
    this.withdrawState = const WithdrawInitial(),
  });

  WithdrawStateModel copyWith({
    String? methodId,
    String? withdrawAmount,
    String? accountInfo,
    String? langCode,
    MethodModel? methods,
    WithdrawState? withdrawState,
  }) {
    return WithdrawStateModel(
      methodId: methodId ?? this.methodId,
      withdrawAmount: withdrawAmount ?? this.withdrawAmount,
      accountInfo: accountInfo ?? this.accountInfo,
      langCode: langCode ?? this.langCode,
      methods: methods ?? this.methods,
      withdrawState: withdrawState ?? this.withdrawState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'method_id': methodId,
      'amount': withdrawAmount,
      'description': accountInfo,
      'lang_code': langCode,
    };
  }

  WithdrawStateModel clear() {
    return const WithdrawStateModel(
      methodId: '',
      withdrawAmount: '',
      accountInfo: '',
      langCode: '',
      methods:  null,
      withdrawState: WithdrawInitial(),
    );
  }

  @override
  List<Object?> get props => [
        methodId,
        withdrawAmount,
        accountInfo,
        langCode,
        methods,
        withdrawState,
      ];
}
